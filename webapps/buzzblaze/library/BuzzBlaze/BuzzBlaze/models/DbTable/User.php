<?php

class BuzzBlaze_Model_DbTable_User extends BuzzBlaze_Model_DbTable_Abstract
{

  protected $_name = 'users';
  protected $_dependentTables = array(
    'BuzzBlaze_Model_DbTable_Relationship',
    'BuzzBlaze_Model_DbTable_UserMeta',
    'BuzzBlaze_Model_DbTable_UserPage',
    'BuzzBlaze_Model_DbTable_UserAction'
  );

  public function numberOfActiveUsers()
  {
    $select = $this->select()
      ->from($this, array('count(*) AS number_of_active_users'))
      ->where('user_last_login >= ?', date('Y-m-d H:i:s', strtotime('last week')));

    $row = $this->fetchRow($select);

    return $row->number_of_active_users;
  }

  public function numberOfUsers()
  {
    $select = $this->select()
      ->from($this, array('count(*) AS number_of_users'));

    $row = $this->fetchRow($select);

    return $row->number_of_users;
  }

  public function byIdentity($identity)
  {
    $select = $this->select()
      ->where(sprintf("user_login = '%s' OR user_email = '%s'", $identity, $identity))
      ->limit(1);

    return $this->fetchRow($select);
  }

  public function isUsernameExist($username)
  {
    $select = $this->select()
      ->where('user_login = ?', $username)
      ->limit(1);

    return $this->fetchRow($select);
  }

  public function isEmailExist($email)
  {
    $select = $this->select()
      ->where('user_email = ?', $email)
      ->limit(1);

    return $this->fetchRow($select);
  }

  public function selectSearch($query)
  {
    $query = $this->getAdapter()->quote('%' . $query . '%');
    $select = $this->select()
      ->where("user_login LIKE {$query} OR user_full_name LIKE {$query}");

    return $select;
  }


}
