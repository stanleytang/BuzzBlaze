<?php

class BuzzBlaze_Model_User extends BuzzBlaze_Model_Abstract
{
  const STATUS_PENDING = 0;
  const STATUS_ACTIVE = 1;
  const STATUS_DISABLED = 2;

  const VISIBILITY_PRIVATE = 0;
  const VISIBILITY_PUBLIC = 1;

  protected $_id;
  protected $_username;
  protected $_password;
  protected $_fullName = '';
  protected $_email;
  protected $_status = 0;
  protected $_visibility = 1;
  protected $_registered;
  protected $_secret;
  protected $_lastLogin = '0000-00-00 00:00:00';
  protected $_lastIp = 0;

  protected $_populated = false;

  protected $_userMeta = array(
    'location' => '',
    'website' => '',
    'gender' => '',
    'birthdate' => '',
    'bio' => '',
    'profile_picture' => '',
    'friend_stream' => 1,
    'email_follow' => 1,
    'email_updates' => 1,
    'status_update' => '',
    'timezone' => 0
  );

  protected $_statistics = array(
    'following' => 0,
    'followers' => 0,
    'feeds' => 0,
    'likes' => 0,
    'reads' => 0,
    'pages' => 0
  );

  protected $_mapping = array(
    'id' => 'user_ID',
    'username' => 'user_login',
    'password' => 'user_password',
    'fullName' => 'user_full_name',
    'email' => 'user_email',
    'status' => 'user_status',
    'visibility' => 'user_visibility',
    'secret' => 'user_secret',
    'lastLogin' => 'user_last_login',
    'lastIp' => 'user_last_ip'
  );

  public function updatePassword($password)
  {
    return $this->setPassword($this->_hash($password));
  }

  public function generateSecret()
  {
    return substr(sha1($this->getPassword() . APPLICATION_SALT . mt_rand()), 0, 16);
  }

  public function autoSetLastLogin()
  {
    return $this->setLastLogin($this->_currentTime());
  }

  public function autoSetLastIp()
  {
    return $this->setLastIp(ip2long($_SERVER['REMOTE_ADDR']));
  }

  public function autoSetSecret()
  {
    return $this->setSecret($this->generateSecret());
  }

  public function resetSecret()
  {
    return $this->setSecret('');
  }

  public function isPending()
  {
    if (self::STATUS_PENDING == $this->getStatus()) {
      return true;
    }

    return false;
  }

  public function isActive()
  {
    if (self::STATUS_ACTIVE == $this->getStatus()) {
      return true;
    }

    return false;
  }

  public function isDisabled()
  {
    if (self::STATUS_DISABLED == $this->getStatus()) {
      return true;
    }

    return false;
  }

  public function isNeverLogin()
  {
    if ('0000-00-00 00:00:00' == $this->getLastLogin()) {
      return true;
    }

    return false;
  }

  public function validateSecret($secret)
  {
    if($secret == $this->getSecret()) {
      return true;
    }

    return false;
  }

  public function activated()
  {
    return $this->setStatus(self::STATUS_ACTIVE);
  }

  public function disabled()
  {
    return $this->setStatus(self::STATUS_DISABLED);
  }


  public function confirm($secret = null)
  {
    if($this->isActive()) {
      return true;
    }

    if($this->isPending() && $this->validateSecret($secret)) {
      $this->resetSecret()->activated();
      return $this->save();
    }
  }

  /**
   * user notifications
   */
  public function notifications($options = array())
  {
    return $this->_getMapper('Notification')->fromUser($this);
  }

  public function getStatus($text = false)
  {
    if(!$text) {
      return $this->_status;
    }

    switch($this->_status) {
      case self::STATUS_PENDING:
        return 'pending';
        break;
      case self::STATUS_ACTIVE:
        return 'active';
        break;
      case self::STATUS_DISABLED:
        return 'disabled';
        break;
    }
  }

  protected function _isValidMeta($metaKey)
  {
    return (array_key_exists($metaKey, $this->_userMeta)) ? true : false;
  }

  public function setMeta($metaKey, $metaValue)
  {
    if($this->_isValidMeta($metaKey)) {
      $this->_userMeta[$metaKey] = $metaValue;
    }

    return $this;
  }

  public function saveMeta($metaKey, $metaValue)
  {
    if($this->_isValidMeta($metaKey)) {
      $this->_userMeta[$metaKey] = $metaValue;
      $this->_getMapper()->updateMeta($this, $metaKey, $metaValue);
    }

    return $this;
  }

  public function getMeta($metaKey)
  {
    if(!$this->isPopulated()) {
      $this->populateMeta();
    }

    if($this->_isValidMeta($metaKey)) {
      return $this->_userMeta[$metaKey];
    }
  }

  public function isPopulated()
  {
    return ($this->_populated) ? true : false;
  }

  public function populateMeta()
  {
    $this->setPopulated(true);
    return $this->_getMapper()->populateMeta($this);
  }

  public function profilePicture($thumb = false)
  {
    if(!$this->isPopulated()) {
      $this->populateMeta();
    }

    if(!$this->hasPicture()) {
      if($thumb) {
        return '/images/thumb-small.gif';
      }

      return '/images/thumb.gif';
    }

    $fname = $this->getMeta('profile_picture');
    $path = '/' . UPLOAD_FOLDER . '/profiles/';

    if($thumb) {
      $path .= 'thumbs/';
    }

    return $path . $fname;
  }

  public function hasPicture()
  {
    if('' == $this->getMeta('profile_picture')) {
      return false;
    }

    return true;
  }

  public function isFollowing($user)
  {
    return $this->_getMapper()->isFollowing($this, $user);
  }

  public function isMutual($user)
  {
    return $this->_getMapper()->isMutual($this, $user);
  }

  public function followers($options = array())
  {
    return $this->_getMapper()->followers($this, $options);
  }

  public function following($options = array())
  {
    return $this->_getMapper()->following($this, $options);
  }

  public function follow($user)
  {
    return $this->_getMapper()->follow($this, $user);
  }

  public function unfollow($user)
  {
    return $this->_getMapper()->unfollow($this, $user);
  }

  public function pages()
  {
    return $this->_getMapper('UserPage')->pages($this);
  }

  public function pagesJson()
  {
    $userPages = $this->pages();

    $jpages = array();
    foreach($userPages as $page) {
      $jpages[] = array(
        'ID' => $page->getId(),
        'title' => $page->getTitle(),
        'name' => $page->getName()
      );
    }

    return json_encode($jpages);
  }

  public function getPage($page)
  {
    if(is_int($page)) {
      return $this->_getMapper('UserPage')->find($page);
    }

    return $this->_getMapper('UserPage')->getPage($page, $this);
  }

  public function getSelectiveFeed($pageId, $feedId)
  {
    return $this->_getMapper('UserFeed')->selectiveFeed($this->getId(), $pageId, $feedId);
  }

  public function getDefaultPage()
  {
    return $this->getPage('home');
  }

  public function likes()
  {
    return $this->_getMapper('UserAction')->likes($this);
  }

  public function reads()
  {
    return $this->_getMapper('UserAction')->reads($this);
  }

  public function feeds($format = null)
  {
    if(null !== $format) {
      return $this->_getMapper('UserPage')->export($this, $format);
    }

     return $this->_getMapper()->feeds($this);
  }

  public function statistic($stat)
  {
    if(0 != $this->_statistics[$stat]) {
      return (int) $this->_statistics[$stat];
    }

    $value = 0;
    switch($stat) {
      case 'followers':
        $value = $this->_getMapper()->followersCount($this);
        break;

      case 'following':
        $value = $this->_getMapper()->followingCount($this);
        break;

      case 'feeds':
        $value = $this->_getMapper('UserFeed')->feedsCount($this);
        break;

      case 'likes':
        $value = $this->_getMapper('UserAction')->likesCount($this);
        break;

      //case 'reads':
      //  $value = $this->_getMapper('UserAction')->readsCount($this);
      //  break;

      case 'pages':
        $value = $this->_getMapper('UserPage')->pagesCount($this);
        break;
    }

    $this->_statistics[$stat] = $value;

    return (int) $this->_statistics[$stat];
  }

  public function statistics()
  {
    foreach($this->_statistics as $stat => $val) {
      $this->statistic($stat);
    }

    return $this->_statistics;
  }

  public function isLiked($feedEntry)
  {
    return $this->_getMapper('UserAction')->isLiked($this, $feedEntry);
  }

  public function likesIds()
  {
    return $this->_getMapper('UserAction')->likesIds($this);
  }

  public function isRead($feedEntry)
  {
    return $this->_getMapper('UserAction')->isRead($this, $feedEntry);
  }

  public function isSubscribed($feed)
  {
    return $this->_getMapper('UserFeed')->isSubscribed($this, $feed);
  }

  protected function _hash($string)
  {
    return $this->_getMapper()->passwordHash()->HashPassword($string);
  }

  protected function _currentTime()
  {
    return date('Y-m-d H:i:s', time());
  }

}

