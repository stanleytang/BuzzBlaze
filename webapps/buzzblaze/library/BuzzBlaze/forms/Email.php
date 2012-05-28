<?php

class BuzzBlaze_Form_Email extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('email-editor')
      ->setMethod('post');

    $event = $this->createElement('hidden', 'email_event');
    $event->setDecorators(array('ViewHelper', 'Errors'));

    $title = $this->createElement('text', 'email_title');
    $title->setRequired(true)
      ->setLabel('Email Title')
      ->setAttrib('style', 'width: 400px;');

    $body = $this->createElement('textarea', 'email_body');
    $body->setRequired(true)
      ->setLabel('Email Body');

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Save Changes');

    $this->addElements(array(
      $event, $title, $body, $submit
    ));
  }

}
