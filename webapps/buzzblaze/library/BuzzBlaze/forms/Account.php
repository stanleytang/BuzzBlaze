<?php

class BuzzBlaze_Form_Account extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('settings-account')
      ->setMethod('post');

    $method = $this->createElement('hidden', '_method');
    $method->setValue('ACCOUNT_INFO')
      ->setDecorators(array('viewHelper'));

    $username = $this->createElement('text', 'username');
    $username->setLabel('Username')
      ->addValidator('alnum')
      ->addValidator('StringLength', false, array(4, 64))
      ->addFilter('StringToLower')
      ->addValidator('Username', false);

    $email = $this->createElement('text', 'email');
    $email->addFilter('StringTrim')
      ->addValidator('EmailAddress')
      ->setRequired(true)
      ->setLabel('Email Address');

    $timezones = Zend_Locale::getTranslationList('timezoneToTerritory');

    $timezone = $this->createElement('select', 'timezone');
    $timezone->setLabel('Timezone')
      ->setDecorators(array('viewHelper'))
      ->setAttrib('class', 'large')
      ->setMultiOptions($timezones);

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Save Changes');

    $this->addElements(array(
      $method, $username, $email, $timezone, $submit
    ));
  }

}
