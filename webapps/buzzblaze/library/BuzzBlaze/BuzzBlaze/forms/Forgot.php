<?php

class BuzzBlaze_Form_Forgot extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('login')
      ->setMethod('post')
      ->setAction($this->getView()->url(array(), 'forgot'));

    $hash = $this->createElement('hash', '_hash',
      array('salt' => APPLICATION_SALT)
    );
    $hash->setDecorators(array('ViewHelper'));

    $identity = $this->createElement('text', 'identity');
    $identity->setRequired(true)
      ->setLabel('Username / Email Address');

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Reset');

    $this->addElements(array($identity, $submit));
  }

}
