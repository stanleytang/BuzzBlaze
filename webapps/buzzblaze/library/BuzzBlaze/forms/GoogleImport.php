<?php

class BuzzBlaze_Form_GoogleImport extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('google_import')
      ->setMethod('post');

    $method = $this->createElement('hidden', '_method');
    $method->setValue('SYNC_GA')
      ->setDecorators(array('ViewHelper', 'Errors'));

    $hash = $this->createElement('hash', '_hash_sync_ga',
      array('salt' => APPLICATION_SALT)
    );
    $hash->setDecorators(array('ViewHelper'));

    $username = $this->createElement('text', 'google_username');
    $username->setRequired(true)
      ->setLabel('Username');

    $password = $this->createElement('password', 'google_password');
    $password->setRequired(true)
      ->setLabel('Password');

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Import');

    $this->addElements(array(
      $method, $username, $password, $submit
    ));
  }

}

