<?php

class BuzzBlaze_Model_FeedEntry extends BuzzBlaze_Model_Abstract
{
  protected $_id;
  protected $_feed;
  protected $_uuid;
  protected $_guid;
  protected $_url;
  protected $_title;
  protected $_published;
  protected $_description = '';
  protected $_content = '';
  protected $_modified;
  protected $_hash;

  protected $_mapping = array(
    'id' => 'entry_ID',
    'feed' => 'feed_ID',
    'uuid' => 'entry_uuid',
    'guid' => 'entry_guid',
    'url' => 'entry_url',
    'title' => 'entry_title',
    'published' => 'entry_published',
    'description' => 'entry_description',
    'content' => 'entry_content',
    'hash' => 'entry_hash'
  );

  public function getPublished($format = null)
  {
    if(null != $format) {
      $date = new Zend_Date($this->_published, Zend_Date::ISO_8601);
      return $date->get($format);
    }

    return $this->_published;
  }

  public function whoLikes()
  {
    return $this->_getMapper('UserAction')->whoLikes($this);
  }

  public function whoReads()
  {
    return $this->_getMapper('UserAction')->whoReads($this);
  }

  public function autoSetUuid()
  {
    $uuid = $this->_generateUuid($this->getGuid(), UUID::nsURL);

    return $this->setUuid($uuid);
  }

  public function getCleanContent()
  {
    return grabArticleHtml($this->getContent(), false);
  }

  public function firstImage()
  {
    $matches = array();
    preg_match_all('|<img.*?src=[\'"](.*?)[\'"].*?>|i', $this->getCleanContent(), $matches);

    $valid = array();

    if(isset($matches[1][0])) {

      foreach($matches[1] as $url) {
        // select valid images only; remove ads and also social media button
        if(!(preg_match('/(api.tweetmeme.com|doubleclick.net|feeds.feedburner.com|.gif)/i', $url))) {
          $valid[] = $url;
        }
      }

      return current($valid);
    }

    return false;
  }

}

