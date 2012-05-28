<?php

class BuzzBlaze_Form_Profile extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('settings-profile')
      ->setMethod('post');

    $method = $this->createElement('hidden', '_method');
    $method->setValue('PROFILE')
      ->setDecorators(array('ViewHelper', 'Errors'));

    $fullname = $this->createElement('text', 'fullname');
    $fullname->setRequired(true)
      ->setLabel('Full Name')
      ->addValidator('StringLength', false, array(1, 255));

    $location = $this->createElement('text', 'location');
    $location->setLabel('Location');

    $website = $this->createElement('text', 'website');
    $website->setLabel('Website URL');

    $gender = $this->createElement('radio', 'gender');
    $gender->setLabel('Gender')
      ->addMultiOptions(array(
        'male' => ' Male',
        'female' => ' Female',
        'none' => ' Rather not say'
      ));

    $birthdate = $this->createElement('hidden', 'birthdate');
    $birthdate->setLabel('Birth date')
      ->addValidator('Date', false, array('YYYY-MM-dd'));

    $bio = $this->createElement('textarea', 'bio');
    $bio->setLabel('Bio')
      ->setAttrib('rows', '15')
      ->setAttrib('cols', '60')
      ->addValidator('StringLength', false, array(1, 300, 'messages' => 'You have exceeded the 300-character limit'));

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Save Changes');

    $this->addElements(array(
      $method, $fullname, $location, $website, $gender, $birthdate, $bio, $submit
    ));
  }

}

