<?php

class BuzzBlaze_Form_Notifications extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('settings-notifications')
      ->setMethod('post');

    $method = $this->createElement('hidden', '_method');
    $method->setValue('NOTIFICATION')
      ->setDecorators(array('ViewHelper', 'Errors'));

    $follow = $this->createElement('checkbox', 'email_follow');
    $follow->setlabel('Receive email when someone follows you');

    $updates = $this->createElement('checkbox', 'email_updates');
    $updates->setlabel('Receive important email updates and news from BuzzBlaze');

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Save Changes');

    $this->addElements(array(
      $method, $follow, $updates, $submit
    ));
  }

}

