<?php

class BuzzBlaze_Model_DbTable_UserPage extends BuzzBlaze_Model_DbTable_Abstract
{

  protected $_name = 'user_pages';
  protected $_dependentTables = array(
    'BuzzBlaze_Model_DbTable_UserFeed'
  );
  protected $_referenceMap = array(
    'User' => array(
      'columns' => 'user_ID',
      'refTableClass' => 'BuzzBlaze_Model_DbTable_User',
      'refColumns' => 'user_ID',
      'onDelete' => self::CASCADE,
      'onUpdate' => self::RESTRICT
    )
  );

  public function pagesCount($userid)
  {
    $select = $this->select()
      ->from($this, array('count(*) as pages_count'))
      ->where('user_ID = ?', $userid);

    $row = $this->fetchRow($select);

    return $row->pages_count;
  }

}

