<?php

class BuzzBlaze_Model_DbTable_Notification extends BuzzBlaze_Model_DbTable_Abstract
{

  protected $_name = 'notifications';

  /**
   * delete notification by object_id and object_type
   */
  public function deleteByObject($id, $type)
  {
    $adapter = $this->getAdapter();

    $where = $adapter->quoteInto('object_ID = ?', $id);
    $where .= $adapter->quoteInto(' AND object_type = ?', $type);

    return $this->delete($where);
  }

  public function fromUser($userid)
  {
    $select = $this->select()
      ->where('user_ID = ?', $userid)
      ->order('notification_created DESC')
      ->limit(10);

    return $this->fetchAll($select);
  }

  public function allNotificationsSelect($userid = null)
  {
    $sqlUser = '';
    if(null !== $userid) {
      $sqlUser = ' AND n.user_ID = ' . $userid;
    }

    $fields = 'n.notification_created AS created, n.notification_scope AS scope, n.notification_event AS event,'
      . ' u.user_ID, u.user_login AS username, u.user_full_name AS full_name,'
      . ' n.object_type,';

    $sqlFeed = ('SELECT ' . $fields)
      . ' f.feed_title as object_title, f.feed_uuid AS object_uuid'
      . ' FROM bb_notifications as n'
      . ' LEFT JOIN bb_users AS u ON u.user_ID = n.user_ID'
      . ' LEFT JOIN bb_feeds as f ON f.feed_ID = n.object_ID'
      . ' WHERE n.object_type = "Feed"' . $sqlUser;

    $sqlEntry = ('SELECT ' . $fields)
      . ' e.entry_title as object_title, e.entry_uuid AS object_uuid'
      . ' FROM bb_notifications as n'
      . ' LEFT JOIN bb_users AS u ON u.user_ID = n.user_ID'
      . ' LEFT JOIN bb_feed_entries as e ON e.entry_ID = n.object_ID'
      . ' WHERE n.object_type = "FeedEntry"' . $sqlUser;

    $sqlOther = ('SELECT ' . $fields)
      . ' n.notification_event AS object_title, n.notification_event AS object_uuid'
      . ' FROM bb_notifications as n'
      . ' LEFT JOIN bb_users AS u ON u.user_ID = n.user_ID'
      . ' WHERE n.object_type = ""' . $sqlUser;

    $select = $this->select()
      ->union(array($sqlFeed, $sqlEntry, $sqlOther))
      ->order('created DESC');

    return $select;
  }

  public function allNotifications($userid = null, $limit = 10)
  {
    $select = $this->allNotificationsSelect($userid);
    $select->limit($limit);

    return $this->fetchAll($select);
  }

  public function friendNotificationsSelect($userid)
  {
    $relTable = new BuzzBlaze_Model_DbTable_Relationship();
    $followings = $relTable->followingIds($userid);

    if(0 == count($followings)) {
      return array();
    }

    $users = array();
    foreach($followings as $user) {
      $users[] = $user->user_ID;
    }

    if(empty($users)) {
      return false;
    }

    $fields = 'n.notification_created AS created, n.notification_scope AS scope, n.notification_event AS event,'
      . ' u.user_ID, u.user_login AS username, u.user_full_name AS full_name,'
      . ' n.object_type,';

    $sqlFeed = ('SELECT ' . $fields)
      . ' f.feed_title as object_title, f.feed_uuid AS object_uuid, f.feed_website AS object_url, f.feed_title, f.feed_uuid'
      . ' FROM bb_notifications as n'
      . ' LEFT JOIN bb_users AS u ON u.user_ID = n.user_ID'
      . ' LEFT JOIN bb_feeds as f ON f.feed_ID = n.object_ID'
      . ' WHERE n.user_ID in ('. implode(',', $users) . ') AND n.object_type = "Feed"';

    $sqlEntry = ('SELECT ' . $fields)
      . ' e.entry_title as object_title, e.entry_uuid AS object_uuid, e.entry_guid AS object_url, f.feed_title, f.feed_uuid'
      . ' FROM bb_notifications as n'
      . ' LEFT JOIN bb_users AS u ON u.user_ID = n.user_ID'
      . ' LEFT JOIN bb_feed_entries as e ON e.entry_ID = n.object_ID'
      . ' LEFT JOIN bb_feeds as f ON f.feed_ID = e.feed_ID'
      . ' WHERE n.user_ID in ('. implode(',', $users) . ') AND n.object_type = "FeedEntry"';

    $select = $this->select()
      ->union(array($sqlFeed, $sqlEntry))
      ->order('created DESC');

    return $select;
  }

  public function friendNotifications($userid, $limit = 10)
  {
    $select = $this->friendNotificationsSelect($userid);

    if(!$select) {
      return array();
    }

    $select->limit($limit);

    return $this->fetchAll($select);
  }

}

