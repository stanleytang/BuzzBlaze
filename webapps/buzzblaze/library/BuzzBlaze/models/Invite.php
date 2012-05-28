<?php

class BuzzBlaze_Model_Invite extends BuzzBlaze_Model_Abstract
{

  protected $_id;
  protected $_code;
  protected $_expires = '0000-00-00';
  protected $_regCount = 0;

  protected $_mapping = array(
    'id' => 'invite_ID',
    'code' => 'invite_code',
    'expires' => 'invite_expires',
    'regCount' => 'invite_reg_count'
  );

  public function updateRegCount()
  {
    return $this->setRegCount($this->getRegCount() + 1);
  }

  /**
   *
   * generate invite code
   * based on function from: http://www.php.net/manual/en/function.rand.php#96583
   *
   */
  public function generateCode($length = 5)
  {
    $string = '';

    for ($i=0; $i<6; $i++) { 
      $d = rand(1,30) % 2; 
      $string .= $d ? chr(rand(65,90)) : chr(rand(48,57)); 
    } 

    return $string;
  }

  public function autoSetCode($length = 5)
  {
    return $this->setCode($this->generateCode($length));
  }

}

