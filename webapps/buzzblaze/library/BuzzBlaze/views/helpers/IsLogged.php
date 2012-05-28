<?php

class BuzzBlaze_View_Helper_IsLogged extends Zend_View_Helper_Abstract
{
  public function IsLogged()
  {
    if(Zend_Auth::getInstance()->hasIdentity()) {
      return true;
    }

    return false;
  }

}
