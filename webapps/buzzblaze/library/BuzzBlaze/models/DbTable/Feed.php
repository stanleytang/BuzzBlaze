<?php

class BuzzBlaze_Model_DbTable_Feed extends BuzzBlaze_Model_DbTable_Abstract
{

  protected $_name = 'feeds';
  protected $_dependentTables = array(
    'BuzzBlaze_Model_DbTable_FeedEntry',
    'BuzzBlaze_Model_DbTable_UserFeed'
  );

  public function isExist($feedUrl)
  {
    $select = $this->select()
      ->where('feed_url = ?', $feedUrl)
      ->limit(1);

    return $this->fetchRow($select);
  }

  public function selectSubscribers($feedid)
  {
    $select = $this->select()
      ->setIntegrityCheck(false)
      ->distinct()
      ->from(array('f' => $this->_name), '')
      ->joinLeft(array('uf' => 'bb_user_feeds'), 'uf.feed_ID = f.feed_ID', '')
      ->joinLeft(array('up' => 'bb_user_pages'), 'up.page_ID = uf.page_ID', '')
      ->joinRight(array('u' => 'bb_users'), 'u.user_ID = up.user_ID', '*')
      ->where('f.feed_ID = ?', $feedid)
      ->group('u.user_ID')
      ->limit(50);

    return $select;
  }

  public function subscribers($feedid)
  {
    return $this->fetchAll($this->selectSubscribers($feedid));
  }

  public function statistics($feedid)
  {
    $select = $this->select()
      ->setIntegrityCheck(false)
      ->distinct()
      ->from(array('f' => $this->_name), '')
      ->joinLeft(array('uf' => 'bb_user_feeds'), 'uf.feed_ID = f.feed_ID', '')
      ->joinLeft(array('up' => 'bb_user_pages'), 'up.page_ID = uf.page_ID', 'count(*) AS pages_count')
      ->joinLeft(array('u' => 'bb_users'), 'u.user_ID = up.user_ID', 'count(*) AS users_count')
      ->where('f.feed_ID = ?', $feedid);

    return $this->fetchRow($select);
  }

  public function numberOfFeeds()
  {
    $select = $this->select()
      ->from($this, 'count(*) AS number_of_feeds');
    $row = $this->fetchRow($select);

    return $row->number_of_feeds;
  }

}

