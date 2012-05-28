<?php

class BuzzBlaze_Validate_CurrentPassword extends Zend_Validate_Abstract
{

  const INVALID = 'invalid';

  protected $_userMapper;
  protected $_messageTemplates = array(
    self::INVALID => 'Incorrect Password'
  );

  public function isValid($value, $context = null)
  {
    $value = (string) $value;
    $this->_setValue($value);

    $authUser = Zend_Registry::get('authUser');

    if($this->_getUserMapper()->checkPassword($value, $authUser->getPassword())) {
      return true;
    }

    $this->_error(self::INVALID);
    return false;
  }

  protected function _getUserMapper()
  {
    if(null === $this->_userMapper) {
      $this->_userMapper = new BuzzBlaze_Model_Mapper_User();
    }

    return $this->_userMapper;
  }

}

