<?php

class BuzzBlaze_Plugin_AuthUser extends Zend_Controller_Plugin_Abstract
{

  public function preDispatch(Zend_Controller_Request_Abstract $request)
  {
    $auth = Zend_Auth::getInstance();
    if($auth->hasIdentity() && 'admin' != $auth->getIdentity()) {
      $userMapper = new BuzzBlaze_Model_Mapper_User();
      $authUser = $userMapper->byIdentity($auth->getIdentity());
      $authUser->populateMeta();
      Zend_Registry::set('authUser', $authUser);
    }
  }

}

