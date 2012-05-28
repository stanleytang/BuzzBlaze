<?php

class BuzzBlaze_Form_UserPage extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('userpage')
      ->setMethod('post');

    $method = $this->createElement('hidden', '_method');
    $method->setValue('ADD_PAGE')
      ->setDecorators(array('ViewHelper', 'Errors'));

    $hash = $this->createElement('hash', '_hash_user_page',
      array('salt' => APPLICATION_SALT)
    );
    $hash->setDecorators(array('ViewHelper', 'Errors'));

    $userAction = $this->createElement('hidden', 'useraction');
    $userAction->setValue('add-page')
      ->setDecorators(array('ViewHelper'));

    $page= $this->createElement('text', 'page');
    $page->setRequired(true)
      ->setLabel('Page')
      ->setDecorators(array('ViewHelper', 'Errors'))
      ->addValidator('PageName', false);

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Add Page')
      ->setDecorators(array('ViewHelper'));

    $this->addElements(array(
      $method, $userAction, $page, $submit
    ));
  }

}
