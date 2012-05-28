<?php

class BuzzBlaze_Model_DbTable_UserAction extends BuzzBlaze_Model_DbTable_Abstract
{

  protected $_name = 'user_actions';
  protected $_referenceMap = array(
    'User' => array(
      'columns' => 'user_ID',
      'refTableClass' => 'BuzzBlaze_Model_DbTable_User',
      'refColumns' => 'user_ID',
      'onDelete' => self::CASCADE,
      'onUpdate' => self::RESTRICT
    ),
    'FeedEntry' => array(
      'columns' => 'entry_ID',
      'refTableClass' => 'BuzzBlaze_Model_DbTable_FeedEntry',
      'refColumns' => 'entry_ID',
      'onDelete' => self::CASCADE,
      'onUpdate' => self::RESTRICT
    )
  );

  public function likesCount($userid = null)
  {
    $select = $this->select()
      ->from($this, array('count(*) as likes_count'))
      ->where('action_type = ?', BuzzBlaze_Model_UserAction::TYPE_LIKE);

    if(null !== $userid) {
      $select->where('user_ID = ?', $userid);
    }

    $row = $this->fetchRow($select);

    return $row->likes_count;
  }

  public function isLiked($userid, $entryid)
  {
    $select = $this->select()
      ->where('action_type = ?', BuzzBlaze_Model_UserAction::TYPE_LIKE)
      ->where('entry_ID = ?', $entryid)
      ->where('user_ID = ?', $userid);

    return $this->fetchRow($select);
  }

  public function selectRecentlyLiked()
  {
    $select = $this->select()
      ->setIntegrityCheck(false)
      ->from(array('ua' => $this->_name), '')
      ->joinLeft(array(
        'fe' => 'bb_feed_entries'), 'fe.entry_ID = ua.entry_ID', array('fe.entry_title', 'fe.entry_uuid', 'fe.entry_url', 'fe.entry_guid')
      )
      ->joinLeft(array(
        'f' => 'bb_feeds'), 'f.feed_ID = fe.feed_ID', array('f.feed_website')
      )
      ->joinLeft(array(
        'u' => 'bb_users'), 'u.user_ID = ua.user_ID', array('u.user_login')
      )
      ->where('ua.action_type = ?', BuzzBlaze_Model_UserAction::TYPE_LIKE)
      ->order('ua.action_timestamp DESC')
      ->limit(30);

    return $select;
  }

  public function recentlyLiked()
  {
    return $this->fetchAll($this->selectRecentlyLiked());
  }

  public function selectLikes($userid)
  {
    $select = $this->select()
      ->setIntegrityCheck(false)
      ->from(array('ua' => $this->_name), '')
      ->joinLeft(array(
        'fe' => 'bb_feed_entries'), 'fe.entry_ID = ua.entry_ID', array('fe.entry_title', 'fe.entry_uuid', 'fe.entry_description', 'fe.entry_url')
      )
      ->joinLeft(array(
        'f' => 'bb_feeds'), 'f.feed_ID = fe.feed_ID', array('f.feed_title', 'f.feed_uuid', 'feed_website')
      )
      ->where(sprintf('ua.action_type = %d AND ua.user_ID = %d',
        BuzzBlaze_Model_UserAction::TYPE_LIKE, $userid
      ))
      ->order('ua.action_timestamp DESC');

    return $select;
  }

  public function likes($userid)
  {
    return $this->fetchAll($this->selectLikes($userid));
  }

  public function selectWhoLikes($entryid)
  {
    $select = $this->select()
      ->setIntegrityCheck(false)
      ->from(array('ua' => $this->_name), '')
      ->joinLeft(array(
        'u' => 'bb_users'), 'u.user_ID = ua.user_ID', '*'
      )
      ->where(sprintf('ua.action_type = %d AND ua.entry_ID = %d',
        BuzzBlaze_Model_UserAction::TYPE_LIKE, $entryid
      ));

    return $select;
  }

  public function whoLikes($entryid)
  {
    return $this->fetchAll($this->selectWhoLikes($entryid));
  }

  public function selectPopularEntries()
  {
    $today = date('Y-m-d', strtotime('today'));
    $last_month = date('Y-m-d', strtotime('last month'));

    $select = $this->select()
      ->setIntegrityCheck(false)
      ->from(array('ua' => $this->_name), '')
      ->joinRight(array(
        'fe' => 'bb_feed_entries'), 'fe.entry_ID = ua.entry_ID',
          array('fe.entry_title', 'fe.entry_uuid', '(fe.entry_title) AS popularity', 'fe.entry_content', 'fe.entry_guid', 'fe.entry_url')
      )
      ->joinRight(array(
        'u' => 'bb_users'), 'u.user_ID = ua.user_ID', array('u.user_login')
      )
      ->where('ua.action_type = ?', BuzzBlaze_Model_UserAction::TYPE_LIKE)
      ->where("ua.action_timestamp BETWEEN '{$last_month}' AND '{$today}'")
      ->order('popularity DESC')
      ->group('fe.entry_title');

    return $select;
  }

  public function popularEntries()
  {
    return $this->fetchAll($this->selectPopularEntries());
  }

  public function likesIds($userid)
  {
    $select = $this->select()
      ->from($this, array('entry_ID'))
      ->where('action_type = ?', BuzzBlaze_Model_UserAction::TYPE_LIKE)
      ->where('user_ID = ?', $userid);

    return $this->fetchAll($select);
  }

}

