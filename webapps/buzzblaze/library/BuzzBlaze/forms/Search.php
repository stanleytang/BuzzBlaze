<?php

class BuzzBlaze_Form_Search extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('search')
      ->setMethod('get')
      ->setAction($this->getView()->url(
        array('action' => 'index', 'controller' => 'search', 'module' => 'default'), 'default'
      ));

    $query = $this->createElement('text', 'q');
    $query->setRequired(true)
      ->setLabel('Query')
      ->setDecorators(array('ViewHelper', 'Errors'));

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Search')
      ->setIgnore(true)
      ->setDecorators(array('ViewHelper'));

    $this->addElements(array($query, $submit));
  }

}
