<?php

class BuzzBlaze_View_Helper_Cache extends Zend_View_Helper_Abstract
{

  protected $_cacheManager = null;

  public function __construct()
  {
    if(null === $this->_cacheManager) {
      $this->_cacheManager = Zend_Controller_Front::getInstance()
        ->getParam('bootstrap')
        ->getResource('cachemanager');
    }
  }

  public function cache($identifier = 'fragment')
  {
    return $this->_cacheManager->getCache($identifier);
  }

}

