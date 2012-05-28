<?php

class BuzzBlaze_View_Helper_Setting extends Zend_View_Helper_Abstract
{

  protected $_sDbTable;

  public function __construct()
  {
    $this->_sDbTable = new BuzzBlaze_Model_DbTable_Setting();
  }

  public function setting($name)
  {
    $setting = $this->_sDbTable->get($name);
   
    if($setting) {
      return $setting->setting_value;
    }

    return null;
  }

}

