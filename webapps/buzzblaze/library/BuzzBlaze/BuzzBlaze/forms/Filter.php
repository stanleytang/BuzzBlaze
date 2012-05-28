<?php

class BuzzBlaze_Form_Filter extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('setting-filter')
      ->setMethod('post');

    $hash = $this->createElement('hash', '_hash',
      array('salt' => APPLICATION_SALT)
    );
    $hash->setDecorators(array('ViewHelper', 'Errors'));

    $filterUrls = $this->createElement('textarea', 'filter_urls');
    $filterUrls->setRequired(true)
      ->setLabel('Filter Urls');

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Save Changes');

    $this->addElements(array(
      $hash, $filterUrls, $submit
    ));
  }

}
