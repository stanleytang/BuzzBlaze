<?php

class BuzzBlaze_Form_Admin_Invite extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('setting-invite')
      ->setMethod('post');

    $hash = $this->createElement('hash', '_invite_hash',
      array('salt' => APPLICATION_SALT)
    );
    $hash->setDecorators(array('ViewHelper', 'Errors'));

    $code = $this->createElement('text', 'code');
    $code->setRequired(true)
      ->setLabel('Invite Code')
      ->addValidator('alnum')
      ->addValidator('StringLength', false, array(4, 6))
      ->addFilter('StringToUpper')
      ->addValidator('Admin_Invite');

    $expires = $this->createElement('text', 'expires');
    $expires->setRequired(true)
      ->setValue('0000-00-00')
      ->setAttrib('class', 'datepicker')
      ->setLabel('Invite Expires');

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Add');

    $this->addElements(array(
      $hash, $code, $expires, $submit
    ));
  }

}
