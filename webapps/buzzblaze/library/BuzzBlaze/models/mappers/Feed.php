<?php

class BuzzBlaze_Model_Mapper_Feed extends BuzzBlaze_Model_Mapper_Abstract
{

  protected $_httpClient;
  protected $_simplePie;

  public function subscribers($feed)
  {
    return $this->_getMapper('User')->convertRowset(
      $this->getDbTable()->subscribers($feed->getId())
    );
  }

  public function recentFeeds($options = array())
  {
    $default = array(
      'limit' => 20,
      'order' => 'feed_added DESC'
    );
    $options = $this->_mergeOptions($default, $options);

    return $this->fetchAll($options);
  }

  public function updatesQueue($options = array())
  {
    $default = array(
      'limit' => 300,
      'order' => 'feed_last_fetched ASC'
    );
    $options = $this->_mergeOptions($default, $options);

    return $this->fetchAll($options);
  }

  public function getHttpClient()
  {
    if(null === $this->_httpClient) {
      $this->_httpClient = new Zend_Http_Client();
      $this->_httpClient->setConfig(array(
        'timeout' => 300,
        'ssl' => array(
          'verify_peer' => true,
          'allow_self_signed' => false,
          'capture_peer_cert' => true
        )
      ));
    }

    return $this->_httpClient;
  }

  public function _initFeedReader()
  {
    Zend_Loader::loadClass('Zend_Feed_Reader');

    Zend_Feed_Reader::setHttpClient($this->getHttpClient());
    Zend_Feed_Reader::setCache($this->_cache());
    Zend_Feed_Reader::useHttpConditionalGet();
  }

  protected function _autoDiscoverFeeds($url)
  {
    $links = Zend_Feed_Reader::findFeedLinks($url);

    if(isset($links->rss)) {
      return $links->rss;
    }

    if(isset($links->atom)) {
      return $links->atom;
    }

    if(isset($links->rdf)) {
      return $links->rdf;
    }

    return null;
  }

  public function autoAddFeed($url)
  {
    // init feed reader
    $this->_initFeedReader();

    $feedUrl = $this->_autoDiscoverFeeds($url);
    if(null === $feedUrl) {
      $feedUrl = $url;
    }

    $feed = $this->findOneBy('feed_url', $feedUrl);

    if(!$feed) {
      $feed = new BuzzBlaze_Model_Feed();
      $feed->setUrl($this->_cleanupUrl($feedUrl))->autoSetUuid();

      return $this->fetchUpdates($feed);
    }

    return $feed;
  }

  public function manualAddFeed($data)
  {
    $feed = $this->findOneBy('feed_url', $data['xmlUrl']);

    if(!$feed) {
      $feed = new BuzzBlaze_Model_Feed();
      $feed->setUrl($this->_cleanupUrl($data['xmlUrl']))
        ->autoSetUuid()
        ->setWebsite($data['htmlUrl'])
        ->setTitle($data['title'])
        ->save();
    }

    return $feed;
  }

  public function fetchUpdates($feed)
  {
    $result = $this->_parseFeedReader($feed);

    if(false === $result) {
      return $this->_processSimplePie($feed);
    }

    return $result;
  }

  protected function _parseFeedReader($feed)
  {
    try {
      $feedReader = Zend_Feed_Reader::import($feed->getUrl());

      $feed->setTitle($feedReader->getTitle())
        ->setWebsite($feedReader->getLink());

      if($feedReader->getDescription()) {
        $feed->setDescription($feedReader->getDescription());
      }

      // record last update time
      $feed->autoSetLastFetched();
      $feed->save();

      foreach($feedReader as $item) {
        $hash = md5($item->getContent());
        $entry = $this->_getMapper('FeedEntry')->findOneBy('entry_guid', $item->getId());

        if($entry) {
          if($hash != $entry->getHash()) {
            $entry->setUrl($item->getPermalink())
              ->setTitle($item->getTitle())
              ->setPublished(date('Y-m-d H:i:s', strtotime($item->getDateModified())))
              ->setDescription($item->getDescription())
              ->setContent($item->getContent())
              ->setHash($hash)
              ->save();
          }
        } else {
          $entry = new BuzzBlaze_Model_FeedEntry();
          $entry->setFeed($feed->getId())
            ->setGuid($item->getId())
            ->autoSetUuid()
            ->setUrl($item->getPermalink())
            ->setTitle($item->getTitle())
            ->setPublished(date('Y-m-d H:i:s', strtotime($item->getDateModified())))
            ->setDescription($item->getDescription())
            ->setContent($item->getContent())
            ->setHash($hash)
            ->save();
        }
      }

    } catch (Exception $e) {
      Zend_Registry::get('log')->warn($e->getMessage());
      return false;
    }

    return $feed;
  }

  public function getSimplePie()
  {
    if(null === $this->_simplePie) {
      $config = Zend_Registry::get('siteConfig');

      Zend_Loader::loadClass('SimplePie');
      $simplepie = new SimplePie();

      $simplepie->set_autodiscovery_level(SIMPLEPIE_LOCATOR_ALL);
      $simplepie->set_item_limit($config['simplePie']['itemLimit']);
      $simplepie->set_useragent($config['simplePie']['userAgent']);
      $simplepie->enable_cache($config['simplePie']['cache']['enable']);
      $simplepie->set_cache_location($config['simplePie']['cache']['location']);
      $simplepie->set_timeout($config['simplePie']['timeout']);
      $simplepie->enable_xml_dump($config['simplePie']['xmlDump']);
      $simplepie->handle_content_type();

      $this->_simplePie = $simplepie;
    }

    return $this->_simplePie;
  }

  protected function _processSimplePie($feed)
  {
    $simplepie = $this->getSimplePie();
    $simplepie->set_feed_url($this->_formatFeedUrl($feed->getUrl()));
    $simplepie->init();

    if($simplepie->error()) {
      Zend_Registry::get('log')->warn($simplepie->error());
      return false;
    }

    $feed->setTitle($simplepie->get_title())
      ->setWebsite($simplepie->get_link())
      ->setDescription($simplepie->get_description());

    // record last update time
    $feed->autoSetLastFetched();
    $feed->save();

    foreach($simplepie->get_items() as $item) {

      $hash = md5($item->get_content());
      $entry = $this->_getMapper('FeedEntry')->findOneBy('entry_guid', $item->get_id());

      if($entry) {
        if($hash != $entry->getHash()) {
          $entry->setUrl($item->get_permalink())
            ->setTitle($item->get_title())
            ->setPublished($item->get_date('Y-m-d H:i:s'))
            ->setDescription($item->get_description())
            ->setContent($item->get_content())
            ->setHash($hash)
            ->save();
        }
      } else {
        $entry = new BuzzBlaze_Model_FeedEntry();
        $entry->setFeed($feed->getId())
          ->setGuid($item->get_id())
          ->autoSetUuid()
          ->setUrl($item->get_permalink())
          ->setTitle($item->get_title())
          ->setPublished($item->get_date('Y-m-d H:i:s'))
          ->setDescription($item->get_description())
          ->setContent($item->get_content())
          ->setHash($hash)
          ->save();
      }
    }

    return $feed;
  }

  protected function _cleanupUrl($url)
  {
    $data = parse_url($url);

    return sprintf("%s://%s%s", $data['scheme'], $data['host'], (isset($data['path']) ? $data['path'] : ''));
  }

  protected function _formatFeedUrl($feedUrl)
  {
    $feedUrl = stripslashes($feedUrl);
    if(stripos($feedUrl, 'feedburner')) {
      $feedUrl .= '?format=xml';
    }

    return $feedUrl;
  }

  protected function _cache()
  {
    return Zend_Registry::get('cacheManager')->getCache('feed');
  }

}

