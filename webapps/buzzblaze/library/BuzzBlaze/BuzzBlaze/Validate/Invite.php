<?php

class BuzzBlaze_Validate_Invite extends Zend_Validate_Abstract
{

  const INVALID = 'invalid';

  protected $_messageTemplates = array(
    self::INVALID => 'Sorry, your invite code is invalid/expired'
  );

  public function isValid($value)
  {
    $value = (string) $value;
    $this->_setValue($value);

    $inviteMapper = new BuzzBlaze_Model_Mapper_Invite();
    $invite = $inviteMapper->findOneBy('invite_code', $value);

    if($invite && ('0000-00-00' == $invite->getExpires())) {
      return true;
    }

    if(!$invite || (time() > strtotime($invite->getExpires()))) {
      $this->_error(self::INVALID);
      return false;
    }

    return true;
  }

}
