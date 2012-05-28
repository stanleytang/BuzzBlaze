<?php

class BuzzBlaze_Form_Admin_Login extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('admin-login')
      ->setMethod('post');

    $hash = $this->createElement('hash', '_hash',
      array('salt' => APPLICATION_SALT)
    );
    $hash->setDecorators(array('ViewHelper', 'Errors'));

    $username = $this->createElement('text', 'username');
    $username->setRequired(true)
      ->setLabel('Username')
      ->addValidator('alnum')
      ->addValidator('StringLength', false, array(4, 64))
      ->addFilter('StringToLower');

    $password = $this->createElement('password', 'password');
    $password->setRequired(true)
      ->setLabel('Password')
      ->addValidator('StringLength', false, array(4));

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Login');

    $this->addElements(array(
      $hash, $username, $password, $submit
    ));
  }

}

