<?php

class BuzzBlaze_Model_Mapper_UserPage extends BuzzBlaze_Model_Mapper_Abstract
{

  public function pagesCount($user)
  {
    return $this->getDbTable()->pagesCount($user->getId());
  }

  public function getPage($page, $user)
  {
    $options = array(
      'where' => array(
        sprintf("page_name = '%s' AND user_ID = %d", $page, $user->getId())
      ),
      'limit' => 1
    );

    return current($this->fetchAll($options));
  }

  public function feeds($page)
  {
    return $this->_getMapper('UserFeed')->findBy(
      'page_ID', $page->getId(), array('order' => 'ufeed_order ASC'), array('Feed')
    );
  }

  public function pages($user)
  {
    return $this->findBy('user_ID', $user->getId());
  }

  public function export($user, $format = 'opml')
  {
    switch($format) {
      case 'opml':
        $dom = new DOMDocument('1.0', 'UTF-8');
        $dom->formatOutput = true;

        $opml = $dom->createElement('opml');
        $opml->setAttribute('version', '2.0');
        $dom->appendChild($opml);

        $head = $dom->createElement('head');

        $siteConfig = Zend_Registry::get('siteConfig');
        $title = $dom->createElement('title', $user->getUsername() . ' subscriptions in ' . $siteConfig['title']);

        $head->appendChild($title);
        $opml->appendChild($head);

        $body = $dom->createElement('body');

        foreach($this->pages($user) as $page) {
          $category = $dom->createElement('outline');
          $category->setAttribute('title', $page->getTitle());
          $category->setAttribute('text', $page->getTitle());

          foreach($page->feeds() as $item) {
            $outline = $dom->createElement('outline');
            $outline->setAttribute('title', $item->getFeed()->getTitle());
            $outline->setAttribute('text', $item->getFeed()->getTitle());
            $outline->setAttribute('htmlUrl', $item->getFeed()->getWebsite());
            $outline->setAttribute('xmlUrl', $item->getFeed()->getUrl());
            //$outline->setAttribute('type', $item->getFeed()->getType()));
            //$outline->setAttribute('version', $item->getFeed()->getVersion());
            $category->appendChild($outline);
          }

          $body->appendChild($category);
        }

        $opml->appendChild($body);

        return $dom;
        break;
    }
  }

}

