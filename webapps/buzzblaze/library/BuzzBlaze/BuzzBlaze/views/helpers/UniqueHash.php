<?php

class BuzzBlaze_View_Helper_UniqueHash extends Zend_View_Helper_Abstract
{

  protected $_salt;

  public function __construct()
  {
    if(null === $this->_salt) {
      $siteConfig = Zend_Registry::get('siteConfig');
      $this->_salt = $siteConfig['salt'];
    }
  }

  public function uniqueHash($identifier)
  {
    if(is_array($identifier)) {
      $identifier = implode('_', $identifier);
    }

    return md5($this->_salt . $identifier);
  }

}

