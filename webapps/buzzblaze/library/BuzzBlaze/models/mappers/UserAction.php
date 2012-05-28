<?php

class BuzzBlaze_Model_Mapper_UserAction extends BuzzBlaze_Model_Mapper_Abstract
{

  public function likesCount($user)
  {
    return $this->getDbTable()
      ->likesCount($user->getId());
  }

  public function isLiked($user, $feedEntry)
  {
    return $this->getDbTable()
      ->isLiked($user->getId(), $feedEntry->getId());
  }

  public function isRead($user, $feedEntry)
  {
    return $this->getDbTable()
      ->isRead($user->getId(), $feedEntry->getId());
  }

  public function whoLikes($feedEntry)
  {
    return $this->_getMapper('User')->convertRowset(
      $this->getDbTable()->whoLikes($feedEntry->getId())
    );
  }

  public function likes($user)
  {
    return $this->getDbTable()->likes($user->getId());
  }

  public function recentlyLiked()
  {
    return $this->getDbTable()->recentlyLiked();
  }

  public function likesIds($user)
  {
    $rowset = $this->getDbTable()->likesIds($user->getId());

    $entries = array();
    foreach($rowset as $row) {
      $entries[] = $row->entry_ID;
    }

    return $entries;
  }

}

