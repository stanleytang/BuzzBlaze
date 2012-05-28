<?php

class BuzzBlaze_Form_Login extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('login')
      ->setMethod('post')
      ->setAction($this->getView()->url(array(), 'login'));

    $hash = $this->createElement('hash', '_hash',
      array('salt' => APPLICATION_SALT)
    );
    $hash->setDecorators(array('ViewHelper', 'Errors'));

    $username = $this->createElement('text', 'identity');
    $username->setRequired(true)
      ->setLabel('Username/Email Address')
      ->addValidator('StringLength', false, array(4, 64))
      ->addFilter('StringToLower');

    $password = $this->createElement('password', 'password');
    $password->setRequired(true)
      ->setLabel('Password')
      ->addValidator('StringLength', false, array(4));

    $rememberme = $this->createElement('checkbox', 'rememberme');
    $rememberme->setLabel('Remember Me')
      ->setValue(1);

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Login');

    $this->addElements(array(
      $username, $password, $rememberme, $submit
    ));
  }

}

