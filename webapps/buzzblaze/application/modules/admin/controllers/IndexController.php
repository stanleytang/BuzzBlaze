<?php

class Admin_IndexController extends BuzzBlaze_Controller
{

  public function indexAction()
  {
    $auth = Zend_Auth::getInstance();
    if(!($auth->hasIdentity() && 'admin' == $auth->getIdentity())) {
      $this->_redirector->gotoSimple('index', 'index', 'default');
    }

    $m = new BuzzBlaze_Model_Mapper_User();

    $userMapper = new BuzzBlaze_Model_Mapper_User();
    $this->view->numUsers = $userMapper->numberOfUsers();
    $this->view->numActiveUsers = $userMapper->numberOfActiveUsers();

    $feedDbTable = new BuzzBlaze_Model_DbTable_Feed();
    $this->view->numFeeds = $feedDbTable->numberOfFeeds();

    $uaTable = new BuzzBlaze_Model_DbTable_UserAction();
    $this->view->numLikes = $uaTable->likesCount();

    $entryDbTable = new BuzzBlaze_Model_DbTable_FeedEntry();
    $this->view->numEntries = $entryDbTable->numberOfEntries();
  }

  public function passwordAction()
  {
    $auth = Zend_Auth::getInstance();
    if(!($auth->hasIdentity() && 'admin' == $auth->getIdentity())) {
      $this->_redirector->gotoSimple('index', 'index', 'default');
    }

    $form = new BuzzBlaze_Form_Admin_PasswordChange();

    $request = $this->getRequest();
    if($request->isPost()) {
      if($form->isValid($request->getPost())) {
        $dbTable = new BuzzBlaze_Model_DbTable_Admin();
        $select = $dbTable->select()
          ->where('admin_login = ?', Zend_Auth::getInstance()->getIdentity())
          ->limit(1);

        $row = $dbTable->fetchRow($select);

        Zend_Loader::loadClass('PasswordHash');
        $passwordHash = new PasswordHash(8, false);

        $row->admin_password = $passwordHash->HashPassword($request->getPost('password'));

        if($row->save()) {
          $this->view->messages = array('Password Updated!');
        }
      }
    }

    $this->view->form = $form;
  }

  public function loginAction()
  {
    $auth = Zend_Auth::getInstance();

    if($auth->hasIdentity() && 'admin' == $auth->hasIdentity()) {
      $this->_redirector->gotoSimple('index', 'index', 'admin');
    }

    $form = new BuzzBlaze_Form_Admin_Login();

    $request = $this->getRequest();
    if($request->isPost()) {
      if($form->isValid($request->getPost())) {

        Zend_Loader::loadClass('BuzzBlaze_Auth_AdminAdapter');
        $authAdapter = new BuzzBlaze_Auth_AdminAdapter();
        $authAdapter->setIdentity($request->getPost('username'))
          ->setCredential($request->getPost('password'));

        $result = $auth->authenticate($authAdapter);

        if($result->isValid()) {
          $this->_redirector->gotoSimple('index', 'index', 'admin');
        }

        $this->view->messages = $result->getMessages();
      }
    }

    $this->view->form = $form;

    if(!isset($this->view->messages)) {
      $this->view->messages = $this->_flashMessenger->getMessages();
    }
  }

  public function logoutAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();

    $auth = Zend_Auth::getInstance();
    if($auth->hasIdentity()) {

      // clear identity
      $auth->clearIdentity();

      if(!$auth->hasIdentity()) {
        $this->_flashMessenger->addMessage("You've successfully log out!");
        $this->_redirector->gotoSimple('index', 'index', 'default');
      }
    }
  }

  public function filterAction()
  {
    $form = new BuzzBlaze_Form_Admin_Filter();
    $sDbTable = new BuzzBlaze_Model_DbTable_Setting();

    $form->getElement('filter_urls')->setValue($sDbTable->get('filter_urls')->setting_value);

    $request = $this->getRequest();
    if($request->isPost()) {
      if($form->isValid($request->getPost())) {
        if($sDbTable->set('filter_urls', $request->getPost('filter_urls'))) {
          $this->view->messages = array('Filter Urls saved!');
        }
      }
    }

    $this->view->form = $form;
  }

  public function optionsAction()
  {
    $form = new BuzzBlaze_Form_Admin_Option();
    $sDbTable = new BuzzBlaze_Model_DbTable_Setting();

    $form->getElement('beta_mode')->setValue($sDbTable->get('beta_mode')->setting_value);
    $form->getElement('no_ad')->setValue($sDbTable->get('no_ad')->setting_value);
    $form->getElement('ad_code')->setValue($sDbTable->get('ad_code')->setting_value);
    $form->getElement('analytic_code')->setValue($sDbTable->get('analytic_code')->setting_value);

    $messages = array();
    $request = $this->getRequest();
    if($request->isPost()) {
      if($form->isValid($request->getPost())) {
        if($sDbTable->set('beta_mode', (int) $request->getPost('beta_mode'))) {
          $messages[] = 'Beta mode updated!';
        }

        if($sDbTable->set('no_ad', (int) $request->getPost('no_ad'))) {
          $messages[] = 'Ad setting updated!';
        }

        if($sDbTable->set('ad_code', $request->getPost('ad_code'))) {
          $messages[] = 'Ad code updated!';
        }

        if($sDbTable->set('analytic_code', $request->getPost('analytic_code'))) {
          $messages[] = 'Analytic code updated!';
        }
      }
    }

    $this->view->messages = $messages;
    $this->view->form = $form;
  }

}
