<?php

class BuzzBlaze_Validate_Email extends Zend_Validate_EmailAddress
{

  const USED = 'used';
	const INVALID = 'invalid';

  protected $_messageTemplates = array(
		self::INVALID => 'Invalid email address',
    self::USED => 'This email is already registered'
  );

  public function isValid($value)
  {
    $value = (string) $value;
    $this->_setValue($value);

    if(!parent::isValid($value)) {

      // reset errors
      $this->_errors = array();
      $this->_messages = array();

      $this->_error(self::INVALID);
      return false;
    }

    $userMapper = new BuzzBlaze_Model_Mapper_User();
    if($userMapper->isEmailExist($value)) {
      $this->_error(self::USED);
      return false;
    }

    return true;
  }

}
