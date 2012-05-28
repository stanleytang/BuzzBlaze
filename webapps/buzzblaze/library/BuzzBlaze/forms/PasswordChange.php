<?php

class BuzzBlaze_Form_PasswordChange extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('setting-pass')
      ->setMethod('post');

    $old_password = $this->createElement('password', 'old_password');
    $old_password->setRequired(true)
      ->setLabel('Current Password')
      ->addValidator('StringLength', false, array(4))
      ->addValidator('CurrentPassword', false);

    $password = $this->createElement('password', 'password');
    $password->setRequired(true)
      ->setLabel('New Password')
      ->addValidator('StringLength', false, array(4));

    $password_confirm = $this->createElement('password', 'password_confirm');
    $password_confirm->setRequired(true)
      ->setLabel('Verify New Password')
      ->addValidator('StringLength', false, array(4))
      ->addValidator('PassConfirm', false);

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Change');

    $this->addElements(array(
      $old_password, $password, $password_confirm, $submit
    ));
  }

}

