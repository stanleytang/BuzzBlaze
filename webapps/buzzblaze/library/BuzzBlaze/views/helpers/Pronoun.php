<?php

class BuzzBlaze_View_Helper_Pronoun extends Zend_View_Helper_Abstract
{

  public function Pronoun($gender = null)
  {
    if('male' == $gender) {
      return 'his';
    }

    if('female' == $gender) {
      return 'her';
    }

    return 'his/her';
  }

}
