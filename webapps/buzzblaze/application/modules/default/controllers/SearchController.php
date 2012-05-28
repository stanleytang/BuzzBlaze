<?php

class SearchController extends BuzzBlaze_Controller
{

  public function init()
  {
    parent::init();

    if(!Zend_Auth::getInstance()->hasIdentity()) {
      $this->_redirector->gotoSimple('index', 'index', 'default');
    }

    // authUser
    $this->view->authUser = Zend_Registry::get('authUser');

    $this->view->partial()->setObjectKey('model');
    $this->view->partialLoop()->setObjectKey('model');

    // set layout
    $this->_helper->layout->setLayout('auth');
    $this->view->q = $this->_getParam('q');
  }

  public function indexAction()
  {
    $form = new BuzzBlaze_Form_Search();

    $hits = array();
    if($this->_hasParam('q')) {
      if($form->isValid($this->_getAllParams())) {
        $dbTable = new BuzzBlaze_Model_DbTable_FeedEntry();

        $adapter = new Zend_Paginator_Adapter_DbSelect(
          $dbTable->selectSearch($this->_getParam('q'))
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
    }

    $this->view->form = $form;
    $this->view->active = 'articles';
  }

  public function feedsAction()
  {
    $form = new BuzzBlaze_Form_Search();

    $hits = array();
    if($this->_hasParam('q')) {
      $dbTable = new BuzzBlaze_Model_DbTable_FeedEntry();

      if($form->isValid($this->_getAllParams())) {
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
    $this->view->active = 'feeds';
  }

  public function peopleAction()
  {
    $form = new BuzzBlaze_Form_Search();

    $hits = array();
    if($this->_hasParam('q')) {
      $dbTable = new BuzzBlaze_Model_DbTable_User();

      if($form->isValid($this->_getAllParams())) {
        Zend_Loader::loadClass('BuzzBlaze_Paginator_Adapter');

        $adapter = new BuzzBlaze_Paginator_Adapter(
          $dbTable->selectSearch($this->_getParam('q'))
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
    $this->view->active = 'people';
  }

}

