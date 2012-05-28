<?php

class BuzzBlaze_Form extends Zend_Form
{
  public function init()
  {
    $this->addElementPrefixPath('BuzzBlaze_Validate', 'BuzzBlaze/Validate/', 'Validate');
  }
}
