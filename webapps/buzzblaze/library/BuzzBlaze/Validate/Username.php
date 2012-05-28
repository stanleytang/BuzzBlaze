<?php

class BuzzBlaze_Validate_Username extends Zend_Validate_Abstract
{

  const USED = 'used';

  protected $_messageTemplates = array(
    self::USED => 'Sorry! Username already taken :('
  );

  public function isValid($value)
  {
    $value = (string) $value;
    $this->_setValue($value);

    $config = Zend_Registry::get('siteConfig');
    $preservedNames = explode(',', $config['preservedNames']);
    if(in_array($value, $preservedNames)) {
      $this->_error(self::USED);
      return false;
    }

    if(Zend_Auth::getInstance()->hasIdentity()) {
      $authUser = Zend_Registry::get('authUser');

      if($authUser->getUsername() == $value) {
        return true;
      }
    }

    $userMapper = new BuzzBlaze_Model_Mapper_User();
    if($userMapper->isUsernameExist($value)) {
      $this->_error(self::USED);
      return false;
    }

    return true;
  }

}

