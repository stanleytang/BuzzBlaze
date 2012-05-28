<?php

class BuzzBlaze_Form_Registration extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('registration')
      ->setMethod('post')
      ->setAction($this->getView()->url(array(), 'register'));

    $hash = $this->createElement('hash', '_hash',
      array('salt' => APPLICATION_SALT)
    );
    $hash->setDecorators(array('ViewHelper', 'Errors'));

    if(BETA_MODE) {
      $inviteCode = $this->createElement('hidden', '_invite_code');
      $inviteCode->setDecorators(array('ViewHelper', 'Errors'))
        ->addValidator('Invite');
    }

    $username = $this->createElement('text', 'username');
    $username->setRequired(true)
      ->setLabel('Username')
      ->addValidator('NotEmpty', true, array('messages' => array(
         Zend_Validate_NotEmpty::IS_EMPTY => 'This cannot be empty!'
        )))
        ->addValidator('alnum', false, array('messages' => array(
          Zend_Validate_Alnum::NOT_ALNUM => 'Contains invalid characters'
        )))
      ->addValidator('StringLength', false, array(4, 64, 'messages' => array(
         Zend_Validate_StringLength::TOO_SHORT => 'Must be at least 4 characters'
        )))
      ->addFilter('StringToLower')
      ->addValidator('Username', false);

    $fullname = $this->createElement('text', 'full_name');
    $fullname->setRequired(true)
      ->setLabel('Full Name')
      ->addValidator('NotEmpty', true, array('messages' => array(
         Zend_Validate_NotEmpty::IS_EMPTY => 'This cannot be empty!'
        )))
      ->addValidator('StringLength', false, array(1, 255));


    $password = $this->createElement('password', 'password');
    $password->setRequired(true)
      ->setLabel('Password')
      ->addValidator('NotEmpty', true, array('messages' => array(
         Zend_Validate_NotEmpty::IS_EMPTY => 'This cannot be empty!'
        )))
      ->addValidator('StringLength', false, array(6, 255, 'messages' => array(
         Zend_Validate_StringLength::TOO_SHORT => 'Too short'
        )));

    $password_confirm = $this->createElement('password', 'password_confirm');
    $password_confirm->setRequired(true)
      ->setLabel('Password Confirmation')
      ->addValidator('NotEmpty', true, array('messages' => array(
         Zend_Validate_NotEmpty::IS_EMPTY => 'This cannot be empty!'
        )))
      ->addValidator('StringLength', false, array(6, 255, 'messages' => array(
         Zend_Validate_StringLength::TOO_SHORT => 'Too short'
        )))
      ->addValidator('PassConfirm', false);

    $email = $this->createElement('text', 'email');
    $email->addFilter('StringTrim')
      ->setRequired(true)
      ->addValidator('NotEmpty', true, array('messages' => array(
         Zend_Validate_NotEmpty::IS_EMPTY => 'This cannot be empty!'
        )))
      ->setLabel('Email Address')
      ->addValidator('Email', false);

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Register')
      ->setIgnore(true);

    if(BETA_MODE) {
      $this->addElements(array($inviteCode));
    }

    $this->addElements(array(
      $username, $password, $password_confirm, $fullname, $email, $submit
    ));
  }

}

