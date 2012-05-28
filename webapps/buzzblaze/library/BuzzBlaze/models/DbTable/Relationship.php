<?php

class BuzzBlaze_Model_DbTable_Relationship extends BuzzBlaze_Model_DbTable_Abstract
{

  protected $_name = 'relationships';
  protected $_referenceMap = array(
    'User' => array(
      'columns' => 'user_ID',
      'refTableClass' => 'BuzzBlaze_Model_DbTable_User',
      'refColumns' => 'user_ID',
      'onDelete' => self::CASCADE,
      'onUpdate' => self::RESTRICT
    ),
    'Follower' => array(
      'columns' => 'follower_ID',
      'refTableClass' => 'BuzzBlaze_Model_DbTable_User',
      'refColumns' => 'user_ID',
      'onDelete' => self::CASCADE,
      'onUpdate' => self::RESTRICT
    )
  );

  public function followingCount($userid)
  {
    $select = $this->select()
        ->from($this, array('count(*) as following_count'))
        ->where('follower_ID = ?', $userid);

    $row = $this->fetchRow($select);

    return $row->following_count;
  }

  public function followersCount($userid)
  {
    $select = $this->select()
        ->from($this, array('count(*) as followers_count'))
        ->where('user_ID = ?', $userid);

    $row = $this->fetchRow($select);

    return $row->followers_count;
  }

  public function isFollowing($userid, $followerid)
  {
    $select = $this->select()
      ->where('user_ID = ?', $followerid)
      ->where('follower_ID = ?', $userid)
      ->limit(1);

    return $this->fetchRow($select);
  }

  public function isMutual($userid, $followerid)
  {
    $select = $this->select()
      ->where("user_ID = {$userid} AND follower_ID = {$followerid}")
      ->orWhere("user_ID = {$followerid} AND follower_ID = {$userid}")
      ->having('count(*) = 2');

    $row = $this->fetchRow($select);

    return ($row) ? true : false;
  }

  public function selectFollowers($userid)
  {
    $select = $this->select()
      ->setIntegrityCheck(false)
      ->from(array('ur' => $this->_name), '')
      ->joinLeft(array('u' => 'bb_users'), 'u.user_ID = ur.follower_ID', '*')
      ->where('ur.user_ID = ?', $userid)
      ->order('ur.relationship_created DESC')
      ->limit(20);

    return $select;
  }

  public function followers($userid)
  {
    return $this->fetchAll($this->selectFollowers($userid));
  }

  public function selectFollowing($userid)
  {
    $select = $this->select()
      ->setIntegrityCheck(false)
      ->from(array('ur' => $this->_name), '')
      ->joinLeft(array('u' => 'bb_users'), 'u.user_ID = ur.user_ID', '*')
      ->where('ur.follower_ID = ?', $userid)
      ->order('ur.relationship_created DESC')
      ->limit(20);

    return $select;
  }

  public function following($userid)
  {
    return $this->fetchAll($this->selectFollowing($userid));
  }

  public function follow($userid, $followerid)
  {
    if($this->isFollowing($userid, $followerid)) {
      return true;
    }

    $row = $this->createRow();
    $row->user_ID = $followerid;
    $row->follower_ID = $userid;

    return $row->save();
  }

  public function unfollow($userid, $followerid)
  {
    $row = $this->isFollowing($userid, $followerid);

    return ($row) ? $row->delete() : true;
  }

  public function followingIds($userid)
  {
    $select = $this->select()
      ->from($this, 'user_ID')
      ->where('follower_ID = ?', $userid);

    return $this->fetchAll($select);
  }

}

