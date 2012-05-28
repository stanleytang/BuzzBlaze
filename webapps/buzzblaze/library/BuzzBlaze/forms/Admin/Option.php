<?php

class BuzzBlaze_Form_Admin_Option extends BuzzBlaze_Form
{

  public function init()
  {
    parent::init();

    $this->setName('setting-adcode')
      ->setMethod('post');

    $hash = $this->createElement('hash', '_hash',
      array('salt' => APPLICATION_SALT)
    );
    $hash->setDecorators(array('ViewHelper', 'Errors'));

    $betaMode = $this->createElement('checkbox', 'beta_mode');
    $betaMode->setlabel('Beta Mode?')
      ->setRequired(true);

    $noAd = $this->createElement('checkbox', 'no_ad');
    $noAd->setlabel('Disable Ad?')
      ->setRequired(true);

    $adCode = $this->createElement('textarea', 'ad_code');
    $adCode->setRequired(true)
      ->setLabel('Ad Code');

    $analyticCode = $this->createElement('textarea', 'analytic_code');
    $analyticCode->setRequired(true)
      ->setLabel('Analytic Code');

    $submit = $this->createElement('submit', 'submit');
    $submit->setLabel('Save Changes');

    $this->addElements(array(
      $hash, $betaMode, $noAd, $adCode, $analyticCode, $submit
    ));
  }

}
