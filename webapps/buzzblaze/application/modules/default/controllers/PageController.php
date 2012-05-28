<?php

class PageController extends BuzzBlaze_Controller
{
  
  protected $_authUser;

  public function init()
  {
    parent::init();

    $this->_helper->layout->setLayout('home');

    if(Zend_Auth::getInstance()->hasIdentity()){
      
      // authUser
      $this->_authUser = Zend_Registry::get('authUser');
      $this->view->authUser = $this->_authUser;

      $userPage = $this->_authUser->getPage('home');
      $this->view->userPage = $userPage;

      $this->view->partial()->setObjectKey('model');
      $this->view->partialLoop()->setObjectKey('model');

      // friendStreams
      $notificationTable = new BuzzBlaze_Model_DbTable_Notification();
      $this->view->friendStreams = $notificationTable->friendNotifications($this->_authUser->getId());

      // set layout
      $this->_helper->layout->setLayout('dashboard');
    }

    $this->view->isStatic = true;  
  }

  public function indexAction()
  {
    $static = strtolower($this->_getParam('static'));
    $viewPath = $this->view->getScriptPath(null);
    $viewScript = $viewPath . 'page/' . $static . '.phtml';

    if(file_exists($viewScript)) {
      $this->render($static); 
    }
  }
  
}

