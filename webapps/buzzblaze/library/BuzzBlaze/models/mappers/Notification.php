<?php

class BuzzBlaze_Model_Mapper_Notification extends BuzzBlaze_Model_Mapper_Abstract
{

  public function fromUser($user)
  {
    return $this->convertRowset(
      $this->getDbTable()->fromUser($user->getId())
    );
  }

}

