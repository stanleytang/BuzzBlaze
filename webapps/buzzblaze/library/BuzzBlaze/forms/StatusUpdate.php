<?php

class BuzzBlaze_Form_StatusUpdate extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('statusupdate')
      ->setMethod('post')
      ->setAction($this->getView()->url(array(), 'dashboard'))
      ->setAttrib('style', 'display: none');

    $hash = $this->createElement('hash', '_hash',
      array('salt' => APPLICATION_SALT)
    );
    $hash->setDecorators(array('ViewHelper', 'Errors'));

    $status = $this->createElement('textarea', 'status');
    $status->setRequired(true)
      ->setAttrib('rows', 10)
      ->setAttrib('cols', 25);

    $submit = $this->createElement('submit', 'update');
    $submit->setLabel('Update');

    $this->addElements(array(
      $status, $submit
    ));
  }

}
