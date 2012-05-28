<?php

class DashboardController extends BuzzBlaze_Controller
{

  protected $_authUser;

  public function init()
  {
    parent::init();

    if(!Zend_Auth::getInstance()->hasIdentity()) {
      $this->_redirector->gotoSimple('index', 'index', 'default');
    }

    // authUser
    $this->_authUser = Zend_Registry::get('authUser');
    $this->view->authUser = $this->_authUser;

    $this->view->partial()->setObjectKey('model');
    $this->view->partialLoop()->setObjectKey('model');

    // friendStreams
    $notificationTable = new BuzzBlaze_Model_DbTable_Notification();
    $this->view->friendStreams = $notificationTable->friendNotifications($this->_authUser->getId());

    // set layout
    $this->_helper->layout->setLayout('dashboard');
  }

  public function indexAction()
  {
    $userPage = $this->_authUser->getPage($this->_getParam('page_name'));

    if(!$userPage) {
      throw new Zend_Controller_Action_Exception(
        "User page '{$this->_authUser->getUsername()}/{$this->_getParam(page_name)}' doesn't exist", 404
      );
    }

    // parsing _method params
    $this->_methodParser();

    $feedForm = new BuzzBlaze_Form_UserFeedHiddenPage();
    $feedForm->populate($this->_getAllParams());
    $feedForm->getElement('page')->setValue($userPage->getId());
    $this->view->feedForm = $feedForm;

    $pageForm = new BuzzBlaze_Form_UserPage();
    $pageForm->setAction('/feeds');
    $this->view->pageForm = $pageForm;
    $this->view->userPage = $userPage;
    $this->view->messages = $this->_flashMessenger->getMessages();
  }

  public function streamsAction()
  {
    $notificationTable = new BuzzBlaze_Model_DbTable_Notification();
    $adapter = new Zend_Paginator_Adapter_DbSelect(
      $notificationTable->friendNotificationsSelect($this->_authUser->getId())
    );

    $paginator = $this->_paginator($adapter);
    $paginator->setItemCountPerPage(20);

    $this->view->userActivities = $this->_userActivities();
    $this->view->paginator = $paginator;
  }

  protected function _userActivities()
  {
    $user = $this->_authUser;

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
    $authUser = $this->_authUser;
    $request = $this->getRequest();

    if($request->isPost()) {

      if($request->isXmlHttpRequest()) {
        $this->_helper->layout->disableLayout();
        $this->_helper->viewRenderer->setNoRender();
      }

      switch($request->getPost('_method')) {
        case 'UPDATE_PAGE':
          $userPage = $authUser->getPage((int) $request->getPost('page_id'));

          if($userPage) {
            $userPage->setTitle($request->getPost('page_title'))
              ->autoSetName();

            if($userPage->save()) {
              $this->getResponse()
                ->setBody($userPage->getTitle())
                ->sendResponse();
            }
          }
          break;

        case 'DELETE_PAGE':
          $userPage = $authUser->getPage((int) $request->getPost('page_id'));

          if($userPage && $userPage->delete()) {
            $this->getResponse()
              ->setBody($userPage->getTitle() . ' has been deleted!')
              ->sendResponse();
          }
          break;

        case 'SORT_UFEEDS':
          $feeds = array();
          parse_str($request->getPost('feeds'), $feeds);

          $ufeeds = current($feeds);
          $pageId = $request->getPost('page_id');

          $userFeedMapper = new BuzzBlaze_Model_Mapper_UserFeed();
          $userPageMapper = new BuzzBlaze_Model_Mapper_UserPage();

          foreach($ufeeds as $key => $val) {

            $userFeed = $userFeedMapper->find($val);

            if(!$userFeed) {
              continue;
            }

            $userFeed->setOrder($key);

            if($userFeed->getUserPage() != $pageId) {
              $userPage = $userPageMapper->find($pageId);
              $userFeed->setUserPage($userPage);
            }

            $userFeed->save();
          }
          break;

        case 'ADD_UFEED':
          $messages = array();
          $feedForm = new BuzzBlaze_Form_UserFeedHiddenPage();

          if($feedForm->isValid($request->getPost())) {

            $messages = $this->_addUfeed();
            $this->view->messages = $messages;
          }

          if($request->isXmlHttpRequest()) {
            $this->getResponse()
              ->setBody(current($messages))
              ->sendResponse();
            exit;
          }
          break;

        case 'SUBSCRIBE_UFEED':
          $messages = $this->_addUfeed();
          $this->view->messages = $messages;
          break;

        case 'RESEND_CONFIRM_EMAIL':
          try {
            $emailMapper = new BuzzBlaze_Model_Mapper_Email();
            $email = $emailMapper->findOneBy('email_event', 'user_registration');
            $email->setUser($authUser);

            if($email->send()) {
              if($request->isXmlHttpRequest()) {
                $this->_helper->json(array('msg' => 'Email confirmation sent to: ' . $authUser->getEmail()));
              }
            }
          } catch (Exception $e) {
            $this->_log()->info($e->getMessage());
          }
          break;

        case 'UPDATE_STATUS':
          $status = strip_tags($request->getPost('status'));
          $authUser->saveMeta('status_update', $status);

          $this->_helper->json(array(
            'msg' => 'Status Updated!',
            'status' => $status
          ));
          break;

        case 'DELETE_UFEED':
          $ufeed = $this->_getUfeed();

          if($ufeed) {
            if($ufeed->delete()) {
              $this->getResponse()
                ->setBody('Feed has been deleted!')
                ->sendResponse();
            }
          }
          break;

        case 'UFEED_TITLE':
          $title = strip_tags($request->getPost('title'));
          $ufeed = $this->_getUfeed();

          if($ufeed) {
            $ufeed->setTitle($title)
              ->save();

            $this->getResponse()
              ->setBody($title)
              ->sendResponse();
          }
          break;

        case 'UFEED_COLOR':
          $color = strip_tags($request->getPost('color'));
          $colorClasses = array('color-white', 'color-yellow', 'color-red', 'color-blue', 'color-orange', 'color-green');

          if(in_array($color, $colorClasses)) {
            $ufeed = $this->_getUfeed();

            if($ufeed) {
              $ufeed->setColor($color)
                ->save();

              $this->getResponse()
                ->setBody($color)
                ->sendResponse();
            }
          }
          break;

        case 'UPDATE_UFEED':
          $ufeed = $this->_getUfeed();

          if($ufeed) {
            $ufeed->setUserPage($request->getPost('new_page_id'));

            if($ufeed->save()) {
              if($request->isXmlHttpRequest()) {
                $this->getResponse()
                  ->setBody('User feed updated!')
                  ->sendResponse();
                exit;
              }
            }
          }
          break;
      }

      // stop script execution ;)
      if($request->isXmlHttpRequest()) {
        exit;
      }
    }
  }

  protected function _getUfeed()
  {
    $authUser = Zend_Registry::get('authUser');
    $request = $this->getRequest();

    $dbTable = new BuzzBlaze_Model_DbTable_UserFeed();

    $row = $dbTable->validateUserFeed(
      $authUser->getId(),
      $request->getPost('page_id'),
      $request->getPost('ufeed_id')
    );

    if($row) {
      $userFeedMapper = new BuzzBlaze_Model_Mapper_UserFeed();
      $userFeed = $userFeedMapper->find($request->getPost('ufeed_id'));

      return $userFeed;
    }

    return false;
  }

  protected function _addUfeed()
  {
    $request = $this->getRequest();
    $this->_authUser = Zend_Registry::get('authUser');
    $siteConfig = Zend_Registry::get('siteConfig');

    if($this->_authUser->statistic('pages') > $siteConfig['feedsPerUserPage']) {
      $messages = array("Sorry, you've reached maximum number of feeds for this page!");

    } elseif($this->_authUser->statistic('feeds') > $siteConfig['feedsPerAccount']) {
      $messages = array("Sorry, your account has been reached maximum number of feeds that allowed!");

    } else {

      $feedUrl = $request->getPost('feedurl');
      if(Zend_Uri::check($feedUrl)) {

        $feedMapper = new BuzzBlaze_Model_Mapper_Feed();
        $feed = $feedMapper->autoAddFeed($feedUrl);

        if(!$feed) {
          return array('Invalid feed!');
        }

        $userFeed = new BuzzBlaze_Model_UserFeed();
        $userFeed->setUser($this->_authUser)
          ->setUserPage($request->getPost('page'))
          ->setFeed($feed);

        if($userFeed->save()) {

          // add to notification system
          $notification = new BuzzBlaze_Model_Notification();
          $notification->setScope(BuzzBlaze_Model_Notification::SCOPE_PUBLIC)
            ->setEvent('add_feed')
            ->setUser($this->_authUser)
            ->setObject($feed->getId())
            ->setObjectType('Feed')
            ->save();

          // remove cache
          $cache = $this->_cache('fragment');
          $cache->clean(
            Zend_Cache::CLEANING_MODE_MATCHING_TAG,
            array($this->_authUser->getUsername(), 'activities')
          );

          $messages = array("New feed '{$feedUrl}' has been added!");
        }

      } else {

        // search feeds
        $this->_helper->redirector->gotoUrl('/search/feeds?q=' . $feedUrl);

      }

      return $messages;
    }
  }

}
