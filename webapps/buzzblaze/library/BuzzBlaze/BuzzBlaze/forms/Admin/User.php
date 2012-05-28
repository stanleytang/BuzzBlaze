<?php

class BuzzBlaze_Form_Admin_User extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('user-edit')
      ->setMethod('post');

    $userid = $this->createElement('hidden', 'user_id');
    $userid->setDecorators(array('ViewHelper'));

    $username = $this->createElement('text', 'username');
    $username->setRequired(true)
      ->setLabel('Username')
      ->addValidator('alnum')
      ->addValidator('StringLength', false, array(4, 64))
      ->addFilter('StringToLower');

    $firstname = $this->createElement('text', 'first_name');
    $firstname->setRequired(true)
      ->setLabel('First Name')
      ->addValidator('StringLength', false, array(1, 100));

    $lastname = $this->createElement('text', 'last_name');
    $lastname->setRequired(true)
      ->setLabel('Last Name')
      ->addValidator('StringLength', false, array(1, 100));

    $email = $this->createElement('text', 'email');
    $email->addFilter('StringTrim')
      ->addValidator('EmailAddress')
      ->setRequired(true)
      ->setLabel('Email Address');

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Save Changes');

    $this->addElements(array(
      $userid, $username, $firstname, $lastname, $email, $submit
    ));
  }

}

