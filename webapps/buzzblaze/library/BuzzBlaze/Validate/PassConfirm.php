<?php

class BuzzBlaze_Validate_PassConfirm extends Zend_Validate_Abstract
{

  const NOT_MATCH = 'notMatch';

  protected $_messageTemplates = array(
    self::NOT_MATCH => 'Passwords do not match'
  );

  public function isValid($value, $context = null)
  {
    $value = (string) $value;
    $this->_setValue($value);

    if((is_array($context) && isset($context['password_confirm']))
      && ($value == $context['password'])) {
        return true;
    }

    if(is_string($context) && ($value == $context)) {
      return true;
    }

    $this->_error(self::NOT_MATCH);
    return false;
  }

}

