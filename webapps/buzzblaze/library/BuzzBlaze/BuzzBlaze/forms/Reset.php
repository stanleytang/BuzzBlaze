<?php

class BuzzBlaze_Form_Reset extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('reset')
      ->setMethod('post')
      ->setAction($this->getView()->url(
        array('controller' => 'auth', 'action' => 'reset'), 'default'
      ));

    $hash = $this->createElement('hash', '_hash',
      array('salt' => APPLICATION_SALT)
    );
    $hash->setDecorators(array('ViewHelper', 'Errors'));

    $username = $this->createElement('hidden', 'username');
    $username->setDecorators(array('ViewHelper', 'Errors'));

    $secret = $this->createElement('hidden', 'secret');
    $secret->setDecorators(array('ViewHelper', 'Errors'));

    $password = $this->createElement('password', 'password');
    $password->setRequired(true)
      ->setLabel('Password')
      ->addValidator('StringLength', false, array(4));

    $password_confirm = $this->createElement('password', 'password_confirm');
    $password_confirm->setRequired(true)
      ->setLabel('Password Confirmation')
      ->addValidator('StringLength', false, array(4))
      ->addValidator('PassConfirm', false);

    $config = Zend_Registry::get('siteConfig');
    $captcha = $this->createElement('captcha', 'captcha', array(
      'captcha' => $config['captcha']
    ));
    $captcha->setLabel('Verification');

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Reset');

    $this->addElements(array(
      $username, $secret, $password, $password_confirm, $captcha, $submit
    ));
  }

}

