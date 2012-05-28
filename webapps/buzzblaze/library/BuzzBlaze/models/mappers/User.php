<?php

class BuzzBlaze_Model_Mapper_User extends BuzzBlaze_Model_Mapper_Abstract
{

  protected $_passwordHash;

  public function passwordHash()
  {
    if(null === $this->_passwordHash) {
      Zend_Loader::loadClass('PasswordHash');
      $this->_passwordHash = new PasswordHash(8, false);
    }

    return $this->_passwordHash;
  }

  public function checkPassword($password, $hash)
  {
    return $this->passwordHash()->CheckPassword($password, $hash);
  }

  public function populateMeta($user)
  {
    $metaDbTable = $this->getDbTable('UserMeta');
    $rowset = $metaDbTable->fromUser($user->getId());

    foreach($rowset as $row) {
      $user->setMeta($row->meta_key, $row->meta_value);
    }

    return $user;
  }

  public function updateMeta($user, $key, $value)
  {
    $metaDbTable = $this->getDbTable('UserMeta');
    $meta = $metaDbTable->updateMeta($user->getId(), $key, $value);

    if($meta) {
      return $user->setMeta($meta->meta_key, $meta->meta_value);
    }
  }

  public function byIdentity($identity)
  {
    $row = $this->getDbTable()->byIdentity($identity);

    if($row) {
      return $this->toModel($row);
    }
  }

  public function isUsernameExist($username)
  {
    return $this->getDbTable()->isUsernameExist($username);
  }

  public function isEmailExist($email)
  {
    return $this->getDbTable()->isEmailExist($email);
  }

  public function feeds($user)
  {
    $feedMapper = $this->_getMapper('Feed');
    return $this->getDbTable('UserFeed')->selectFromUser($user->getId());
  }

  public function numberOfActiveUsers()
  {
    return $this->getDbTable()->numberOfActiveUsers();
  }

  public function numberOfUsers()
  {
    return $this->getDbTable()->numberOfUsers();
  }

  public function followingCount($user)
  {
    return $this->getDbTable('Relationship')
      ->followingCount($user->getId());
  }

  public function followersCount($user)
  {
    return $this->getDbTable('Relationship')
      ->followersCount($user->getId());
  }

  public function isFollowing($user, $follower)
  {
    return $this->getDbTable('Relationship')
      ->isFollowing($user->getId(), $follower->getId());
  }

  public function isMutual($user, $follower)
  {
    return $this->getDbTable('Relationship')
      ->isMutual($user->getId(), $follower->getId());
  }

  public function following($user)
  {
    return $this->convertRowset(
      $this->getDbTable('Relationship')->following($user->getId())
    );
  }

  public function followers($user)
  {
    return $this->convertRowset(
      $this->getDbTable('Relationship')->followers($user->getId())
    );
  }

  public function follow($user, $follower)
  {
    return $this->getDbTable('Relationship')
      ->follow($user->getId(), $follower->getId());
  }

  public function unfollow($user, $follower)
  {
    return $this->getDbTable('Relationship')
      ->unfollow($user->getId(), $follower->getId());
  }

}

