<?php

class BuzzBlaze_Form_OpmlImport extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('opml_import')
      ->setMethod('post');

    $method = $this->createElement('hidden', '_method');
    $method->setValue('OPML_IMPORT')
      ->setDecorators(array('ViewHelper', 'Errors'));

    $hash = $this->createElement('hash', '_hash_opml_import',
      array('salt' => APPLICATION_SALT)
    );
    $hash->setDecorators(array('ViewHelper'));

    $opml = $this->createElement('file', 'opml');
    $opml->setLabel('OPML File')
      ->addValidator('Count', false, 1)
      ->addValidator('Extension', false, array('xml', 'opml'));

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Update');

    $this->addElements(array(
      $method, $opml, $submit
    ));
  }

}

