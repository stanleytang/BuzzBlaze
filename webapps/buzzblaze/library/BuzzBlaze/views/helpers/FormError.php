<?php

class BuzzBlaze_View_Helper_FormError extends Zend_View_Helper_Abstract
{

  public function formError($errors, $element)
  {
    if(null == $errors) {
      return null;
    }

    if(isset($errors[$element])) {

      $msg = array();
      foreach($errors[$element] as $key => $val) {
        $msg[] = '<li>' . $val . '</li>';
      }

      return '<ul class="errors">' . implode("\n", $msg) . '</ul>';
    }
  }

}

