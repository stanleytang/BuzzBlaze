<?php

class BuzzBlaze_Model_DbTable_UserMeta extends BuzzBlaze_Model_DbTable_Abstract
{

  protected $_name = 'user_meta';
  protected $_referenceMap = array(
    'User' => array(
      'columns' => 'user_ID',
      'refTableClass' => 'BuzzBlaze_Model_DbTable_User',
      'refColumns' => 'user_ID',
      'onDelete' => self::CASCADE,
      'onUpdate' => self::RESTRICT
    ),
  );

  public function updateMeta($userid, $key, $value)
  {
    $select = $this->select()
      ->where('user_ID = ?', $userid)
      ->where('meta_key = ?', $key)
      ->limit(1);

    $row = $this->fetchRow($select);
    if($row) {
      $row->meta_value = $value;

      if($row->save()) {
        return $row;
      }
    }

    $meta = $this->createRow();
    $meta->user_ID = $userid;
    $meta->meta_key = $key;
    $meta->meta_value = $value;

    if($meta->save()) {
      return $meta;
    }
  }

  public function fromUser($userid)
  {
    $select = $this->select()
      ->where('user_ID = ?', $userid);

    return $this->fetchAll($select);
  }

}
