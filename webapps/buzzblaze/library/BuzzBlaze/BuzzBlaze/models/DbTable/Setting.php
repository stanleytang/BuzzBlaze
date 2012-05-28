<?php

class BuzzBlaze_Model_DbTable_Setting extends BuzzBlaze_Model_DbTable_Abstract
{

  protected $_name = 'settings';

  public function get($setting_name)
  {
    $select = $this->select()
      ->where('setting_name = ?', $setting_name)
      ->limit(1);

    return $this->fetchRow($select);
  }

  public function set($setting_name, $setting_value)
  {
    $setting = $this->get($setting_name);

    if(!$setting) {
      $setting = $this->createRow();
      $setting->setting_name = $setting_name;
    }

    $setting->setting_value = $setting_value;

    return $setting->save();
  }

}

