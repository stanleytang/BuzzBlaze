<?php

class BuzzBlaze_Validate_Uri extends Zend_Validate_Abstract
{

  const INVALID_URI = 'invalidUri';

  protected $_messageTemplates = array(
    self::INVALID_URI => "'%value%' is not valid URI"
  );

  public function isValid($value)
  {
    $value = (string) $value;
    $this->_setValue($value);

    if(!Zend_Uri::check($value)) {
      $this->_error(self::INVALID_URI);
      return false;
    }

    return true;
  }

}

