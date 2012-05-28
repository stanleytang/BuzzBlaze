<?php

class BuzzBlaze_Model_DbTable_UserFeed extends BuzzBlaze_Model_DbTable_Abstract
{

  protected $_name = 'user_feeds';
  protected $_referenceMap = array(
    'Feed' => array(
      'columns' => 'feed_ID',
      'refTableClass' => 'BuzzBlaze_Model_DbTable_Feed',
      'refColumns' => 'feed_ID',
      'onDelete' => self::CASCADE,
      'onUpdate' => self::RESTRICT
    ),
    'UserPage' => array(
      'columns' => 'page_ID',
      'refTableClass' => 'BuzzBlaze_Model_DbTable_UserPage',
      'refColumns' => 'page_ID',
      'onDelete' => self::CASCADE,
      'onUpdate' => self::RESTRICT
    )
  );

  public function validateUserFeed($userid, $pageid, $ufeedid)
  {
    $select = $this->select()
      ->setIntegrityCheck(false)
      ->distinct()
      ->from(array('uf' => $this->_name), '')
      ->joinLeft(array('up' => 'bb_user_pages'), 'up.page_ID = uf.page_ID', '')
      ->joinLeft(array('u' => 'bb_users'), 'u.user_ID = up.user_ID', '')
      ->where(sprintf('u.user_ID = %d AND uf.page_ID = %d AND uf.ufeed_ID = %d', $userid, $pageid, $ufeedid))
      ->limit(1);

    return $this->fetchRow($select);
  }

  public function feedsCount($userid)
  {
    $select = $this->select()
      ->setIntegrityCheck(false)
      ->from(array('p' => 'bb_user_pages'), '')
      ->joinRight(array('uf' => 'bb_user_feeds'), 'uf.page_ID = p.page_ID', 'count(DISTINCT uf.feed_ID) AS feeds_count')
      ->where('p.user_ID = ?', $userid);

    $row = $this->fetchRow($select);

    return $row->feeds_count;
  }

  public function selectFromUser($userid)
  {
    $select = $this->select()
      ->setIntegrityCheck(false)
      ->distinct()
      ->from(array('p' => 'bb_user_pages'), '')
      ->joinLeft(array('uf' => 'bb_user_feeds'), 'uf.page_ID = p.page_ID', array('page_ID', 'ufeed_ID'))
      ->joinRight(array('f' => 'bb_feeds'), 'f.feed_ID = uf.feed_ID', array('feed_ID', 'feed_uuid', 'feed_url', 'feed_title', 'feed_website', 'feed_description'))
      ->where('p.user_ID = ?', $userid)
      ->order('uf.ufeed_ID DESC');

    return $select;
  }

  public function fromUser($userid)
  {
    return $this->fetchAll($this->selectFromUser($userid));
  }

  public function isSubscribed($userid, $feedid)
  {
    $ufeeds = $this->fetchAll($this->selectFromUser($userid));

    foreach($ufeeds as $ufeed) {
      if($feedid == $ufeed->feed_ID) {
        return true;
      }
    }

    return false;
  }

}

