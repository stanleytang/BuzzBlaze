<?php

class BuzzBlaze_Auth_AdminAdapter implements Zend_Auth_Adapter_Interface
{

  protected $_identity;
  protected $_credential;

  public function __construct($username = null, $password = null)
  {
    $this->setIdentity($username);
    $this->setCredential($password);
  }

  public function setIdentity($username)
  {
    if(null != $username) {
      $this->_identity = $username;
    }

    return $this;
  }

  public function setCredential($password)
  {
    if(null != $password) {
      $this->_credential = $password;
    }

    return $this;
  }

  public function authenticate()
  {

    $dbTable = new BuzzBlaze_Model_DbTable_Admin();
    $select = $dbTable->select()
      ->where('admin_login = ?', $this->_identity)
      ->limit(1);

    $row = $dbTable->fetchRow($select);

    if(!$row) {
      return new Zend_Auth_Result(
        Zend_Auth_Result::FAILURE_IDENTITY_NOT_FOUND,
        $this->_identity,
        array('Invalid Admin!')
      );
    }

    Zend_Loader::loadClass('PasswordHash');
    $passwordHash = new PasswordHash(8, false);

    if(!$passwordHash->CheckPassword($this->_credential, $row->admin_password)) {
      return new Zend_Auth_Result(
        Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID,
        $this->_identity,
        array('Incorrect Password')
      );
    }

    return new Zend_Auth_Result(
      Zend_Auth_Result::SUCCESS,
      $this->_identity,
      array()
    );
  }

}

