<?php

class BuzzBlaze_Form_AccountDelete extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('setting-account')
      ->setMethod('post');

    $method = $this->createElement('hidden', '_method');
    $method->setValue('DELETE_ACCOUNT')
      ->setDecorators(array('viewHelper'));

    $password = $this->createElement('password', 'password');
    $password->setRequired(true)
      ->setLabel('Verify Current Password')
      ->addValidator('StringLength', false, array(4))
      ->addValidator('CurrentPassword', false);

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Delete Account');

    $this->addElements(array(
      $method, $password, $submit
    ));
  }

}

