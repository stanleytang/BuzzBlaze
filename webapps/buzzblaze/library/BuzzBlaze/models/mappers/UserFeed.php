<?php

class BuzzBlaze_Model_Mapper_UserFeed extends BuzzBlaze_Model_Mapper_Abstract
{

  public function feedsCount($user)
  {
    return $this->getDbTable()
      ->feedsCount($user->getId());
  }

  public function isSubscribed($user, $feed)
  {
    return $this->getDbTable()
      ->isSubscribed($user->getId(), $feed->getId());
  }

}

