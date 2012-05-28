<?php

class BuzzBlaze_View_Helper_IsLiked extends Zend_View_Helper_Abstract
{

  protected $_entries = array();

  public function __construct()
  {
    if(Zend_Auth::getInstance()->hasIdentity()) {
      $authUser = Zend_Registry::get('authUser');

      $this->_entries = $authUser->likesIds();
    }
  }

  public function IsLiked($entryid)
  {
    if(in_array($entryid, $this->_entries)) {
      return true;
    }

    return false;
  }

}

