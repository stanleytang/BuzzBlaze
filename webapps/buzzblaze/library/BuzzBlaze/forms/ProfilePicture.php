<?php

class BuzzBlaze_Form_ProfilePicture extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('settings-profile-picture')
      ->setMethod('post');

    $method = $this->createElement('hidden', '_method');
    $method->setValue('PROFILE_PICTURE')
      ->setDecorators(array('ViewHelper', 'Errors'));

    $picture = $this->createElement('file', 'picture');
    $picture->setLabel('Upload Profile Picture')
      ->setAttrib('class', 'file')
      ->addValidator('Count', false, 1)
      ->addValidator('Extension', false, array('jpg', 'png', 'gif'));

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Update');

    $this->addElements(array(
      $method, $picture, $submit
    ));
  }

}
