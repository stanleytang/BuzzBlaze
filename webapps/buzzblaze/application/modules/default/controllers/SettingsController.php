<?php

class SettingsController extends BuzzBlaze_Controller
{

  protected $_authUser;

  public function init()
  {
    parent::init();

    if(!Zend_Auth::getInstance()->hasIdentity()) {
      $this->_redirector->gotoSimple('index', 'index', 'default');
    }

    $this->_authUser = Zend_Registry::get('authUser');
    $this->view->authUser = $this->_authUser;

    $this->_helper->layout()->setLayout('auth');

    if('feeds' != $this->getRequest()->getParam('action')) {
      $this->view->showAccountMenu = true;
    }
  }

  public function accountAction()
  {
    $delForm = new BuzzBlaze_Form_AccountDelete();
    $form = new BuzzBlaze_Form_Account();

    $request = $this->getRequest();
    if($request->isPost()) {

      switch($request->getPost('_method')) {
        case 'DELETE_ACCOUNT':
          if($delForm->isValid($request->getPost())) {
            $auth = Zend_Auth::getInstance();
            if($auth->hasIdentity()) {
              $authUser = Zend_Registry::get('authUser');

              if($authUser->delete()) {
                $auth->clearIdentity();
                $this->getResponse()
                  ->setBody('Your account has been deleted!')
                  ->sendResponse();

                $this->_flashMessenger->addMessage('Your account has been deleted!');
                $this->_redirector->gotoSimple('index', 'index', 'default');
              }
            }
          }
          break;

        case 'ACCOUNT_INFO':
          if($form->isValid($request->getPost())) {

            $old_username = $this->_authUser->getUsername();

            $this->_authUser->setUsername($request->getPost('username'));
            $this->_authUser->setEmail($request->getPost('email'));
            $this->_authUser->saveMeta('timezone', $request->getPost('timezone'));

            if($this->_authUser->save()) {
              $this->view->messages = array('Settings Saved!');
            }

            if($old_username != $request->getPost('username')) {

              // clear identity
              $auth = Zend_Auth::getInstance();
              if($auth->hasIdentity()) {
                $auth->clearIdentity();
                Zend_Session::forgetMe();
              }

              $this->_flashMessenger->addMessage("You need to relogin (use your new username)");
              $this->_redirector->gotoUrl('/login');
              exit;
            }
          }
          break;
      }

    }

    $form->username->setValue($this->_authUser->getUsername());
    $form->email->setValue($this->_authUser->getEmail());
    $form->timezone->setValue($this->_authUser->getMeta('timezone'));

    $this->view->delForm = $delForm;
    $this->view->form = $form;
    $this->view->active = 'account';
  }

  public function passwordAction()
  {
    $form = new BuzzBlaze_Form_PasswordChange();
    $request = $this->getRequest();

    if($request->isPost()) {
      if($form->isValid($request->getPost())) {
        $authUser = Zend_Registry::get('authUser');
        $authUser->updatePassword($request->getPost('password'));

        if($authUser->save()) {
          $this->view->messages = array('Password Updated!');
        }
      }
    }

    $this->view->form = $form;
    $this->view->active = 'password';
  }

  public function profileAction()
  {
    $this->_authUser = Zend_Registry::get('authUser');
    $userMeta = array('location', 'website', 'gender', 'birthdate', 'bio');

    $profileForm = new BuzzBlaze_Form_Profile();
    $pictureForm = new BuzzBlaze_Form_ProfilePicture();

    $this->view->messages = $this->_flashMessenger->getMessages();

    $request = $this->getRequest();
    if($request->isPost()) {

      switch($request->getPost('_method')) {
        case 'PROFILE':
          if($profileForm->isValid($request->getPost())) {

            foreach($userMeta as $meta) {
              $this->_authUser->saveMeta($meta, $request->getPost($meta));
            }

            $this->_authUser->setFullName($request->getPost('fullname'))
              ->save();

            $this->view->messages = array('Settings Saved!');

            // append to notification system
            $notification = new BuzzBlaze_Model_Notification();
            $notification->setScope(BuzzBlaze_Model_Notification::SCOPE_PRIVATE)
              ->setEvent('update_profile')
              ->setUser($this->_authUser)
              ->save();
          }
          break;

        case 'PROFILE_PICTURE':
          if($pictureForm->isValid($request->getPost())) {
            $updated = false;
            $fname = '';
            $imagePath = '';

            $picture = $pictureForm->getElement('picture');
            if($picture->isUploaded()) {
              $fname = $picture->getFileName(null, false);
              $fname = strtolower(mt_rand() . '_' . $fname);
              $imagePath = PROFILE_UPLOAD_PATH . $fname;

              $picture->addFilter('Rename', $imagePath);

              if($picture->receive()) {
                $updated = true;
              }
            }

            if($updated) {
              $siteConfig = Zend_Registry::get('siteConfig');

              Zend_Loader::loadClass('BuzzBlaze_Thumbnailer');
              $thumbnailer = new BuzzBlaze_Thumbnailer($imagePath);

              // resize current image
              $thumbnailer->setNewWidth($siteConfig['profilePicture']['maxSize'])->resize();

              // create thumbnail
              $thumbnailer->setNewWidth($siteConfig['profilePicture']['thumbSize'])->generate();

              $this->_authUser->saveMeta('profile_picture', $fname);

              // append to notification system
              $notification = new BuzzBlaze_Model_Notification();
              $notification->setScope(BuzzBlaze_Model_Notification::SCOPE_PRIVATE)
                ->setEvent('update_profile_picture')
                ->setUser($this->_authUser)
                ->save();

              $this->view->messages = array('Profile picture updated!');
            }
          }
          break;
      }
    }

    if($request->isGet()) {
      switch($request->getQuery('_method')) {
        case 'DELETE_PROFILE_PICTURE':

          $this->_authUser->saveMeta('profile_picture', '');
          // append to notification system
          $notification = new BuzzBlaze_Model_Notification();
          $notification->setScope(BuzzBlaze_Model_Notification::SCOPE_PRIVATE)
            ->setEvent('update_profile_picture')
            ->setUser($this->_authUser)
            ->save();

          $this->_flashMessenger->addMessage('Profile picture updated!');
          $this->_redirector->setGotoSimple('profile', 'settings');
          break;
      }
    }

    foreach($userMeta as $meta) {
      $profileForm->getElement($meta)->setValue($this->_authUser->getMeta($meta));
    }

    $this->view->profileForm = $profileForm;
    $this->view->pictureForm = $pictureForm;
    $this->view->active = 'profile';
  }

  public function notificationsAction()
  {
    $this->_authUser = Zend_Registry::get('authUser');
    $form = new BuzzBlaze_Form_Notifications();

    $userMeta = array('email_follow', 'email_updates');

    $request = $this->getRequest();
    if($request->isPost()) {
      switch($request->getPost('_method')) {
        case 'NOTIFICATION':
        if($form->isValid($request->getPost())) {
          foreach($userMeta as $meta) {
            $this->_authUser->saveMeta($meta, $request->getPost($meta));
          }

          $this->view->messages = array('Settings Saved!');
        }
        break;
      }
    }

    foreach($userMeta as $meta) {
      $form->getElement($meta)->setValue($this->_authUser->getMeta($meta));
    }

    $this->view->form = $form;
    $this->view->active = 'notifications';
  }

  public function feedsAction()
  {
    $this->_authUser = Zend_Registry::get('authUser');

    $messages = array();
    $feedForm = new BuzzBlaze_Form_UserFeed();
    $pageForm = new BuzzBlaze_Form_UserPage();

    $request = $this->getRequest();
    if($request->isPost()) {
      switch($request->getPost('_method')) {
        case 'ADD_PAGE':
          if($pageForm->isValid($request->getPost())) {

            $siteConfig = Zend_Registry::get('siteConfig');

            if($this->_authUser->statistic('pages') < $siteConfig['userPagesPerAccount']) {
              $pageTitle = $request->getPost('page');

              $userPage = new BuzzBlaze_Model_UserPage();
              $userPage->setUser($this->_authUser)
                ->setTitle($pageTitle)
                ->autoSetName();

              if($userPage->save()) {
                $messages = array("New user page '{$pageTitle}' has been added!");
                $this->_flashMessenger->addMessage(current($messages));
                $this->_redirector->gotoUrl($this->view->url(array('page_name' => $userPage->getName()), 'dashboard'));
                exit;
              }
            } else {
              $messages = array('Sorry, you have reached maximum number of user pages per account!');
            }
          }
          break;

        case 'ADD_UFEED':
          if($feedForm->isValid($request->getPost())) {
            $messages = $this->_addUfeed(array(
              'page' => $request->getPost('page'),
              'feedurl' => $request->getPost('feedurl')
            ));

            if($request->isXmlHttpRequest()) {
              $this->_helper->json(array('msg' => current($message)));
              exit;
            }

            if(null !== $request->getPost('_redir')) {
              $this->_flashMessenger->addMessage(current($message));
              $this->_redirector->gotoUrlAndExit($request->getPost('_redir'));
            }

          }
          break;

        case 'UFEED_DISPLAY':
          $this->_authUser = Zend_Registry::get('authUser');
          $ufMapper = new BuzzBlaze_Model_Mapper_UserFeed();
          $ufeed = $ufMapper->find($request->getPost('ufeed_id'));
          $ufeed->setDisplay((int) $request->getPost('ufeed_display'));

          if($ufeed->save()) {
            $this->_helper->json(array('msg' => 'Display setting saved!'));
          }
          break;
      }
    }

    $userPages = $this->_authUser->pages();
    foreach($userPages as $upage) {
      $feedForm->getElement('page')->addMultiOption($upage->getId(), $upage->getTitle());
    }

    $this->view->feedForm = $feedForm;
    $this->view->pageForm = $pageForm;
    $this->view->messages = $messages;

    $adapter = new Zend_Paginator_Adapter_DbSelect(
      $this->_authUser->feeds()
    );

    $paginator = $this->_paginator($adapter);
    $this->view->paginator = $paginator;
    $this->view->active = 'feeds';

    if(empty($this->view->messages)) {
      $this->view->messages = $this->_flashMessenger->getMessages();
    }
  }

  public function feedsSearchAction()
  {
    $form = new BuzzBlaze_Form_Search();

    $hits = array();
    if($this->_hasParam('q')) {
      $dbTable = new BuzzBlaze_Model_DbTable_FeedEntry();

      if($form->isValid($this->_getAllParams())) {

        if(Zend_Uri::check($this->_getParam('q'))) {
          $messages = $this->_addUfeed(array(
            'page' => $this->_getParam('page'),
            'feedurl' => $this->_getParam('q')
          ));

          if(!empty($messages)) {
            $this->_flashMessenger->addMessage(current($messages));
            $this->_redirector->gotoUrl('/feeds');
            exit;
          }
        }

        $adapter = new Zend_Paginator_Adapter_DbSelect(
          $dbTable->selectFeedSearch($this->_getParam('q'))
        );

        $paginator = $this->_paginator($adapter);

        $params = $this->view->queryParser(array(), true);
        $page = 1;
        if(isset($params['p'])) {
          $page = $params['p'];
        }

        $paginator->setCurrentPageNumber($page);
        $config = Zend_Registry::get('siteConfig');
        $paginator->setItemCountPerPage($config['itemsPerSERP']);
        $this->view->paginator = $paginator;
      }

      if($this->getRequest()->isXmlHttpRequest()) {
        $feeds = $dbTable->feedSearch($this->_getParam('q'));
        $this->_helper->json($feeds->toArray());
        exit;
      }
    }

    $this->view->form = $form;
    $this->view->q = $this->_getParam('q');
    $this->view->active = 'feeds_search';
  }

  public function feedsImporterAction()
  {
    $this->_authUser = Zend_Registry::get('authUser');

    $messages = array();
    $googleForm = new BuzzBlaze_Form_GoogleImport();
    $opmlForm = new BuzzBlaze_Form_OpmlImport();

    $request = $this->getRequest();
    if($request->isPost()) {
      switch($request->getPost('_method')) {
        case 'SYNC_GA':
          if($googleForm->isValid($request->getPost())) {
            Zend_Loader::loadClass('BuzzBlaze_GoogleReader');
            $go = new BuzzBlaze_GoogleReader($request->getPost('google_username'), $request->getPost('google_password'));
            $opml = $go->authenticate()->exportOpml();

            if($this->_parseOpml($opml)) {
              $messages = array("Google Reader subscription has been imported!");
            }
          }
          break;

        case 'OPML_IMPORT':
          if($opmlForm->isValid($request->getPost())) {

            $opmlFile = $opmlForm->getElement('opml');
            if($opmlFile->isUploaded()) {
              if($opmlFile->receive()) {
                if($this->_parseOpml(file_get_contents($opmlFile->getFileName()))) {
                  $messages = array("OPML has been imported!");
                }
              }
            }
          }
          break;

      }
    }

    if($request->isGet()) {
      switch($request->getQuery('_method')) {
        case 'OPML_EXPORT':
          $this->_helper->layout->disableLayout();
          $this->_helper->viewRenderer->setNoRender();
          $dom = $this->_authUser->feeds('opml');

          $fname = $this->_authUser->getUsername() . '-subscriptions.xml';
          $this->getResponse()
            ->setHeader('Content-Disposition', 'attachment; filename=' . $fname)
            ->setHeader('Content-type', 'application/xml; charset=UTF-8')
            ->setBody($dom->saveXML())
            ->sendResponse();
          exit;
          break;
      }
    }

    $this->view->opmlForm = $opmlForm;
    $this->view->googleForm = $googleForm;
    $this->view->messages = $messages;
    $this->view->active = 'feeds_importer';
  }

  protected function _parseOpml($opml)
  {
    Zend_Loader::loadClass('OPMLParser');
    $opml = new OPMLParser($opml);

    // set maximum user pages; @todo limit import by siteConfig
    $siteConfig = Zend_Registry::get('siteConfig');
    $userPagesCount = $this->_authUser->statistic('pages');
    $userPageMapper = new BuzzBlaze_Model_Mapper_UserPage();

    foreach($opml->data as $key => $val) {

      $userPage = $userPageMapper->findOneBy('page_title', $key);

      if(!$userPage) {
        $userPage = new BuzzBlaze_Model_UserPage();
        $userPage->setUser($this->_authUser)
          ->setTitle($key)
          ->autoSetName()
          ->save();
      }

      foreach($val as $k => $v) {
        try {
          $feedMapper = new BuzzBlaze_Model_Mapper_Feed();
          $feed = $feedMapper->manualAddFeed($v);

          $userFeed = new BuzzBlaze_Model_UserFeed();
          $userFeed->setUser($this->_authUser)
            ->setUserPage($userPage)
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
          }
        } catch(Exception $e) {
          $this->_log()->info($e->getMessage());
        }
      }
    }

    // remove cache
    $cache = $this->_cache('fragment');
    $cache->clean(
      Zend_Cache::CLEANING_MODE_MATCHING_TAG,
      array($this->_authUser->getUsername(), 'activities')
    );

    return true;
  }

  protected function _addUfeed($params)
  {
    $this->_authUser = Zend_Registry::get('authUser');
    $siteConfig = Zend_Registry::get('siteConfig');

    if($this->_authUser->statistic('pages') > $siteConfig['feedsPerUserPage']) {
      return array("Sorry, you've reached maximum number of feeds for this page!");
    } elseif($this->_authUser->statistic('feeds') > $siteConfig['feedsPerAccount']) {
      return array("Sorry, your account has been reached maximum number of feeds that allowed!");
    } else {
      $feedUrl = $params['feedurl'];
      $feedMapper = new BuzzBlaze_Model_Mapper_Feed();
      $feed = $feedMapper->autoAddFeed($feedUrl);

      $userFeed = new BuzzBlaze_Model_UserFeed();
      $userFeed->setUser($this->_authUser)
        ->setUserPage($params['page'])
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

        $message = "New feed '{$feedUrl}' has been added!";

        return array($message);
      }

      return array();
    }
  }

}

