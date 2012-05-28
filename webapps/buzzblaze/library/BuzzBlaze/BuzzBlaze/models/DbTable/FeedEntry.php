<?php

class BuzzBlaze_Model_DbTable_FeedEntry extends BuzzBlaze_Model_DbTable_Abstract
{

  protected $_name = 'feed_entries';
  protected $_dependentTables = array(
    'BuzzBlaze_Model_DbTable_UserAction'
  );
  protected $_referenceMap = array(
    'Feed' => array(
      'columns' => 'feed_ID',
      'refTableClass' => 'BuzzBlaze_Model_DbTable_Feed',
      'refColumns' => 'feed_ID',
      'onDelete' => self::CASCADE,
      'onUpdate' => self::RESTRICT
    )
  );

  public function fromFeed($feedid)
  {
    $select = $this->select()
      ->where('feed_ID = ?', $feedid)
      ->order('entry_published DESC')
      ->limit(30);

    return $this->fetchAll($select);
  }

  public function selectFromFeed($feedid, $offset = 1, $count = 10)
  {
    $select = $this->select()
      ->where('feed_ID = ?', $feedid)
      ->order('entry_published DESC')
      ->limit($offset, $count);

    return $select;
  }

  public function numberOfEntries()
  {
    $select = $this->select()
      ->from($this, 'count(*) AS number_of_entries');
    $row = $this->fetchRow($select);

    return $row->number_of_entries;
  }

  public function selectSearch($query)
  {
    $query = $this->getAdapter()->quote('%' . $query . '%');
    $select = $this->select()
      ->setIntegrityCheck(false)
      ->from(array('fe' => $this->_name))
      ->joinLeft(array('f' => 'bb_feeds'), 'f.feed_ID = fe.feed_ID', array('f.feed_uuid', 'f.feed_website'))
      ->where("entry_content LIKE {$query}");

    return $select;
  }

  public function selectFeedSearch($query)
  {
    $query = $this->getAdapter()->quote('%' . $query . '%');
    $select = $this->select()
      ->setIntegrityCheck(false)
      ->distinct()
      ->from(array('fe' => $this->_name), '')
      ->joinLeft(array('f' => 'bb_feeds'), 'f.feed_ID = fe.feed_ID', array('f.*'))
      ->where("entry_content LIKE {$query}")
      ->limit(30);

    return $select;
  }

  public function feedSearch($query)
  {
    return $this->fetchAll($this->selectFeedSearch($query));
  }

}

