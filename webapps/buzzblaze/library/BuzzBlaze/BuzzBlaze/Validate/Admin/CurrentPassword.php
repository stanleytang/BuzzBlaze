<?php

class BuzzBlaze_Validate_Admin_CurrentPassword extends Zend_Validate_Abstract
{

  const INVALID = 'invalid';

  protected $_passwordHash;
  protected $_messageTemplates = array(
    self::INVALID => 'Incorrect Password'
  );

  public function isValid($value, $context = null)
  {
    $value = (string) $value;
    $this->_setValue($value);

    $admin = $this->_getAdmin();
    if($this->checkPassword($value, $admin->admin_password)) {
      return true;
    }

    $this->_error(self::INVALID);
    return false;
  }

  protected function _getAdmin()
  {
    $dbTable = new BuzzBlaze_Model_DbTable_Admin();
    $select = $dbTable->select()
      ->where('admin_login = ?', Zend_Auth::getInstance()->getIdentity())
      ->limit(1);

    return $dbTable->fetchRow($select);
  }

  public function passwordHash()
  {
    if(null === $this->_passwordHash) {
      Zend_Loader::loadClass('PasswordHash');
      $this->_passwordHash = new PasswordHash(8, false);
    }

    return $this->_passwordHash;
  }

  public function checkPassword($password, $hash)
  {
    return $this->passwordHash()->CheckPassword($password, $hash);
  }

}

