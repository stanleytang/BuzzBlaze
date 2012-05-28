<?php

class UsersController extends BuzzBlaze_Controller
{

  protected $_currentUser;
  protected $_authUser;

  public function init()
  {
    parent::init();

    $config = Zend_Registry::get('siteConfig');
    $noUsers = array('register', 'validate');

    if(!in_array($this->getRequest()->getActionName(), $noUsers)) {
      $this->view->user = $this->_currentUser();
      $this->view->searchForm = new BuzzBlaze_Form_Search();

      $this->view->partial()->setObjectKey('model');
      $this->view->partialLoop()->setObjectKey('model');
      $this->view->userActivities = $this->_userActivities();
    }
  }

  public function registerAction()
  {
    if(Zend_Auth::getInstance()->hasIdentity()) {
      $this->_redirector->gotoRoute(array(), 'dashboard');
    }

    $form = new BuzzBlaze_Form_Registration();
    $request = $this->getRequest();

    if(BETA_MODE && $request->isGet()) {
      if(!$this->_hasParam('invite_code')) {
        $this->_helper->viewRenderer->setNoRender();
        $this->getResponse()->setBody('You need an invite code to register!');
      }

      // inject invite code
      $form->getElement('_invite_code')->setValue($request->getQuery('invite_code'));
    }

    if($request->isPost()) {
      if($form->isValid($request->getPost())) {

        try {

          $user = $this->_registerProcess($request->getPost());

          if($user) {
            $this->view->register_success = true;
          }

        } catch (Zend_Mail_Exception $e) {
          $this->_log()->crit('Unable to send email to ' . $request->getPost('email'));
        } catch (Exception $e) {
          $this->_log()->crit("Exception catched: {$e->getMessage()}.");
        }
      }
    }

    $this->view->form = $form;
  }

  protected function _registerProcess($post)
  {
    $user = new BuzzBlaze_Model_User();
    $user->setUsername($post['username'])
      ->updatePassword($post['password'])
      ->setFullName($post['full_name'])
      ->setEmail($post['email'])
      ->autoSetSecret();

    if($user->save()) {

      // add default user page
      $userPage = new BuzzBlaze_Model_UserPage();
      $userPage->setUser($user)
        ->setTitle('Home')
        ->save();

      // add to notification system
      $notification = new BuzzBlaze_Model_Notification();
      $notification->setScope(BuzzBlaze_Model_Notification::SCOPE_PUBLIC)
        ->setEvent('join')
        ->setUser($user)
        ->save();

      // Update regCount if in Beta
      if(BETA_MODE) {
        $inviteMapper = new BuzzBlaze_Model_Mapper_Invite();
        $invite = $inviteMapper->findOneBy('invite_code', $post['_invite_code']);
        $invite->updateRegCount()->save();
      }

      $emailMapper = new BuzzBlaze_Model_Mapper_Email();
      $email = $emailMapper->findOneBy('email_event', 'user_registration');
      $email->setUser($user);
      $email->send();
    }

    return $user;
  }

  public function validateAction()
  {
    $form = new BuzzBlaze_Form_Registration();
    $request = $this->getRequest();

    if($request->isXmlHttpRequest()) {

      $post = $request->getPost();
      $output = array(
        'status' => 'valid',
        'message' => 'Ok!'
      );

      $messages = array();

      if(preg_match('/recaptcha/i', key($post))) {
        $config = Zend_Registry::get('siteConfig');
        $recaptcha = new Zend_Service_ReCaptcha(
          $config['captcha']['pubKey'],
          $config['captcha']['privKey']
        );

        $result = $recaptcha->verify(
          $request->getPost('recaptcha_challenge_field'),
          $request->getPost('recaptcha_response_field')
        );

        if(!$result->getStatus()) {
          $messages = array('Incorrect Captcha');
        }

      } else {

        $form->isValidPartial($post);
        $messages = $form->getMessages(key($post));

      }

      if(is_array($messages) && !empty($messages)) {

        $output = array(
          'status' => 'invalid',
          'message' => current($messages)
        );

      }

      $this->_helper->json($output);
      exit;
    }
  }

  public function profileAction()
  {
    $this->_helper->layout->setLayout('profile');
    $user = $this->_currentUser();

    if(!$user) {
      throw new Zend_Controller_Action_Exception(
        "User '{$this->_getParam(username)}' doesn't exist", 404
      );
    }

    // parsing _method request
    $this->_methodParser();

    $userPage = $user->getPage($this->_getParam('page_name'));

    if(!$userPage) {
      throw new Zend_Controller_Action_Exception(
        "User page '{$user->getUsername()}/{$this->_getParam(page_name)}' doesn't exist", 404
      );
    }

    $this->view->user = $user;
    $this->view->userPage = $userPage;
  }

  public function followersAction()
  {
    $this->_helper->layout->setLayout('profile');
    $user = $this->_currentUser();

    Zend_Loader::loadClass('BuzzBlaze_Paginator_Adapter');
    $dbTable = new BuzzBlaze_Model_DbTable_Relationship();
    $adapter = new BuzzBlaze_Paginator_Adapter(
      $dbTable->selectFollowers($user->getId())
    );

    $this->view->paginator = $this->_paginator($adapter);
    $this->view->active = 'followers';
  }

  public function followingAction()
  {
    $this->_helper->layout->setLayout('profile');
    $user = $this->_currentUser();

    Zend_Loader::loadClass('BuzzBlaze_Paginator_Adapter');
    $dbTable = new BuzzBlaze_Model_DbTable_Relationship();
    $adapter = new BuzzBlaze_Paginator_Adapter(
      $dbTable->selectFollowing($user->getId())
    );

    $this->view->paginator = $this->_paginator($adapter);
    $this->view->active = 'following';
  }

  public function likesAction()
  {
    $this->_helper->layout->setLayout('profile');
    $user = $this->_currentUser();

    $dbTable = new BuzzBlaze_Model_DbTable_UserAction();
    $adapter = new Zend_Paginator_Adapter_DbSelect(
      $dbTable->selectLikes($user->getId())
    );
    $this->view->paginator = $this->_paginator($adapter);
    $this->view->active = 'likes';
  }

  public function feedsAction()
  {
    $this->_helper->layout->setLayout('profile');
    $user = $this->_currentUser();

    $dbTable = new BuzzBlaze_Model_DbTable_UserFeed();
    $adapter = new Zend_Paginator_Adapter_DbSelect(
      $dbTable->selectFromUser($user->getId())
    );
    $this->view->paginator = $this->_paginator($adapter);
    $this->view->active = 'user_feeds';
  }

  public function activitiesAction()
  {
    $this->_helper->layout->setLayout('profile');
    $user = $this->_currentUser();

    $notificationTable = new BuzzBlaze_Model_DbTable_Notification();
    $adapter = new Zend_Paginator_Adapter_DbSelect(
      $notificationTable->allNotificationsSelect($user->getId())
    );

    $paginator = $this->_paginator($adapter);
    $paginator->setItemCountPerPage(20);

    $this->view->paginator = $paginator;
    $this->view->active = 'activities';
  }

  protected function _currentUser()
  {
    if(null === $this->_currentUser) {
      $userMapper = new BuzzBlaze_Model_Mapper_User();
      $this->_currentUser = $userMapper->findOneBy('user_login', $this->_getParam('username'));
    }

    return $this->_currentUser;
  }

  protected function _userActivities()
  {
    $user = $this->_currentUser();

    if($user) {
      $cache = $this->_cache('standard');
      $ctags = array($user->getUsername(), 'activities');
      $identifier = $this->view->uniqueHash($ctags);

      if(!($userActivities = $cache->load($identifier))) {
        $notificationTable = new BuzzBlaze_Model_DbTable_Notification();
        $userActivities = $notificationTable->allNotifications($user->getId());

        $cache->save($userActivities, $identifier, $ctags);
      }

      return $userActivities;
    }
  }

  protected function _methodParser()
  {
    $user = $this->_currentUser();
    $request = $this->getRequest();

    try {
      if(null != $request->getPost('_method')) {
        switch($request->getPost('_method')) {

          case 'FOLLOW':
            if(!Zend_Auth::getInstance()->hasIdentity()) {
              return;
            }

            $authUser = Zend_Registry::get('authUser');
            if($authUser->follow($user)) {

              // send email notification
              if($user->getMeta('email_follow')) {
                $emailMapper = new BuzzBlaze_Model_Mapper_Email();
                $email = $emailMapper->findOneBy('email_event', 'user_follow');
                $email->setUser($user);
                $email->setFollower($authUser);
                $email->send();
              }

              if($request->isXmlHttpRequest()) {
                $this->_helper->json(array('msg' => 'success'));
              }
            }
            break;

          case 'UNFOLLOW':
            if(!Zend_Auth::getInstance()->hasIdentity()) {
              return;
            }

            $authUser = Zend_Registry::get('authUser');
            if($authUser->unfollow($user)) {

              if($request->isXmlHttpRequest()) {
                $this->_helper->json(array('msg' => 'success'));
              }

            }

            break;
        }

        // stop script execution ;)
        exit;
      }

      if(null != $request->getQuery('_method')) {

        switch($request->getQuery('_method')) {
          case 'CONFIRM_ACCOUNT':
            if($user->isActive()) {
              $this->_redirector->gotoRoute(array('username' => $user->getUsername()), 'profile');
            }

            $auth = Zend_Auth::getInstance();

            if($user->confirm($this->getRequest()->getQuery('confirm'))) {
              $this->view->account_confirmed = true;

              Zend_Loader::loadClass('BuzzBlaze_Auth_AutoLogin');
              $authAdapter = new BuzzBlaze_Auth_AutoLogin();
              $authAdapter->setIdentity($user->getUsername());

              $result = $auth->authenticate($authAdapter);

              if($result->isValid()) {

                $user = $authAdapter->getUser();
                if($user->isActive()) {
                  $user->resetSecret();
                }

                $user->autoSetLastLogin()
                  ->autoSetLastIp()
                  ->save();

                $this->_redirector->gotoRoute(array(), 'dashboard');
              }
            }
            break;

          case 'RESET_PASSWORD':
            if($user->validateSecret($this->getRequest()->getQuery('reset'))) {
              $this->_forward('reset', 'auth', 'default');
            }
            break;
        }
      }

    } catch (Zend_Mail_Exception $e) {
      $this->_log()->crit("Unable to send email to {$user->getEmail()}.");
    } catch (Exception $e) {
      $this->_log()->crit("Exception catched: {$e->getMessage()}.");
    }
  }

}

