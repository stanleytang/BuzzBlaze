<?php

class BuzzBlaze_Form_EmailBroadcast extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('email-broadcast')
      ->setMethod('post');

    $recipients = $this->createElement('MultiCheckbox', 'recipients');
    $recipients->setLabel('Recipients');

    $userMapper = new BuzzBlaze_Model_Mapper_User();
    foreach($userMapper->fetchAll() as $user) {
      $recipients->addMultiOption($user->getEmail(), $user->getUsername());
    }
    
    $title = $this->createElement('text', 'email_title');
    $title->setRequired(true)
      ->setLabel('Email Title')
      ->setAttrib('style', 'width: 400px;');

    $body = $this->createElement('textarea', 'email_body');
    $body->setRequired(true)
      ->setLabel('Email Body');

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Send');

    $this->addElements(array(
      $recipients, $title, $body, $submit
    ));
  }

}