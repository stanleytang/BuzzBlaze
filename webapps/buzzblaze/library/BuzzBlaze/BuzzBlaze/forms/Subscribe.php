<?php

class BuzzBlaze_Form_Subscribe extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('feedsubscribe')
      ->setMethod('post');

    $method = $this->createElement('hidden', '_method');
    $method->setValue('ADD_UFEED')
      ->setDecorators(array('ViewHelper', 'Errors'));

    $hash = $this->createElement('hash', '_hash_user_feed',
      array('salt' => APPLICATION_SALT)
    );
    $hash->setDecorators(array('ViewHelper', 'Errors'));

    $userAction = $this->createElement('hidden', 'useraction');
    $userAction->setValue('add-feed')
      ->setDecorators(array('ViewHelper'));

    $feedUrl = $this->createElement('hidden', 'feedurl');
    $feedUrl->setRequired(true)
      ->setDecorators(array('ViewHelper', 'Errors'));

    $page = $this->createElement('select', 'page');
    $page->setDecorators(array('ViewHelper'));

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Subscribe')
      ->setDecorators(array('ViewHelper'));

    $this->addElements(array(
      $method, $userAction, $feedUrl, $page, $submit
    ));
  }

}

