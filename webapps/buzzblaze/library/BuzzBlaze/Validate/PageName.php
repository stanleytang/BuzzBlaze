<?php

class BuzzBlaze_Validate_PageName extends Zend_Validate_Abstract
{

  const USED = 'used';

  protected $_messageTemplates = array(
    self::USED => 'Page title had been reserved, please use another title'
  );

  public function isValid($value)
  {
    $value = (string) $value;
    $this->_setValue($value);

    $config = Zend_Registry::get('siteConfig');
    $preservedNames = explode(',', $config['preservedPageNames']);
    if(in_array($value, $preservedNames)) {
      $this->_error(self::USED);
      return false;
    }

    return true;
  }

}

