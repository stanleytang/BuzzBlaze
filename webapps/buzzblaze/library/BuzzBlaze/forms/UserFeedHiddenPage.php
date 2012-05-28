<?php

class BuzzBlaze_Form_UserFeedHiddenPage extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('feed')
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

    $feedUrl = $this->createElement('text', 'feedurl');
    $feedUrl->setRequired(true)
      ->setLabel('Feed Url')
      ->setDecorators(array('ViewHelper', 'Errors'));

    $page = $this->createElement('hidden', 'page');
    $page->setDecorators(array('ViewHelper'));

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Add Feed')
      ->setDecorators(array('ViewHelper'));

    $this->addElements(array(
      $method, $userAction, $feedUrl, $page, $submit
    ));
  }

}

