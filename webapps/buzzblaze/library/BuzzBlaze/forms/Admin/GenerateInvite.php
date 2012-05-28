<?php

class BuzzBlaze_Form_Admin_GenerateInvite extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('setting-generate-invite')
      ->setMethod('post')
      ->setAction('/admin/invites/bulk');

    $hash = $this->createElement('hash', '_hash',
      array('salt' => APPLICATION_SALT)
    );
    $hash->setDecorators(array('ViewHelper', 'Errors'));

    $numOfCodes = $this->createElement('text', 'number-of-codes');
    $numOfCodes->setRequired(true)
      ->setLabel('Number of codes to be generated')
      ->addValidator('Digits');

    $expires = $this->createElement('text', 'genexpires');
    $expires->setRequired(true)
      ->setValue('0000-00-00')
      ->setAttrib('class', 'datepicker')
      ->setLabel('Invite Expires');

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Add');

    $this->addElements(array(
      $hash, $numOfCodes, $expires, $submit
    ));
  }

}
 
