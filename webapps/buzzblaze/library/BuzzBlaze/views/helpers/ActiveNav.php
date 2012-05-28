<?php

class BuzzBlaze_View_Helper_ActiveNav extends Zend_View_Helper_Abstract
{

  public function activeNav($current)
  {
    $frontController = Zend_Controller_Front::getInstance();
    $requestUri = $frontController->getRequest()->getRequestUri();

    if($current == $requestUri) {
      return 'active';
    }
  }

}

