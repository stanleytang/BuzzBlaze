<?php

class BuzzBlaze_Validate_Admin_Invite extends Zend_Validate_Abstract
{

  const USED = 'used';

  protected $_messageTemplates = array(
    self::USED => 'Invite code had already registered'
  );

  public function isValid($value)
  {
    $value = (string) $value;
    $this->_setValue($value);

    $inviteMapper = new BuzzBlaze_Model_Mapper_Invite();
    $invite = $inviteMapper->findOneBy('invite_code', $value);

    if($invite) {
      $this->_error(self::USED);
      return false;
    }

    return true;
  }

}

