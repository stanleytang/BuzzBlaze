<?php

class BuzzBlaze_Auth_AutoLogin implements Zend_Auth_Adapter_Interface
{

  protected $_identity;
  protected $_credential;
  protected $_userMapper;
  protected $_user;

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
    $user = $this->getUser();

    if(!$user) {
      return new Zend_Auth_Result(
        Zend_Auth_Result::FAILURE_IDENTITY_NOT_FOUND,
        $this->_identity,
        array('Invalid Username/Email Address')
      );
    }

    return new Zend_Auth_Result(
      Zend_Auth_Result::SUCCESS,
      $this->_identity,
      array()
    );
  }

  public function getUser()
  {
    if(null === $this->_user) {
      $user = $this->_getUserMapper()->byIdentity($this->_identity);

      if(stripos($this->_identity, '@')) {
        $this->_identity = $user->getUsername();
      }

      $this->_user = $user;
    }

    return $this->_user;
  }

  protected function _getUserMapper()
  {
    if(null === $this->_userMapper) {
      $this->_userMapper = new BuzzBlaze_Model_Mapper_User();
    }

    return $this->_userMapper;
  }

}

