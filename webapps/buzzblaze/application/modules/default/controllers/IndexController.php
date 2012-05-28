<?php

class IndexController extends BuzzBlaze_Controller
{

  protected $_filterUrls;

  public function init()
  {
    parent::init();

    $auth = Zend_Auth::getInstance();
    if($auth->hasIdentity()) {
      $this->_redirector->gotoRoute(array(), 'dashboard');
    }
  }

  public function indexAction()
  {
    $this->_helper->layout->setLayout('home');
    $this->view->messages = $this->_flashMessenger->getMessages();

    if(BETA_MODE) {
      $this->render('home-beta');

      $request = $this->getRequest();
      if($request->isPost()) {
        $userEmail = $request->getPost('email');

        if('' != $userEmail) {
          $mail = new Zend_Mail();
          $mail->addTo('invite@buzzblaze.com', 'BuzzBlaze')
            ->setSubject('Invitation Request')
            ->setBodyText('email: ' . $request->getPost('email'));

          $mail->send();

          $msg = 'Invitation sent to ' . $userEmail;

          if($request->isXmlHttpRequest()) {
             $this->getResponse()
                ->setBody($msg)
                ->sendResponse();            
            exit;
          }

          $this->view->messages = array($msg);
        }
      }
    }

    /**
    $userActionMapper = new BuzzBlaze_Model_Mapper_UserAction();
    $this->view->recentlyLiked = $this->_filter($userActionMapper->recentlyLiked());

    $feedMapper = new BuzzBlaze_Model_Mapper_Feed();
    $this->view->recentFeeds= $this->_filter($feedMapper->recentFeeds());
     */
  }

  public function popularAction()
  {
    $request = $this->getRequest();
    if($request->isXmlHttpRequest()) {

      $uaTable = new BuzzBlaze_Model_DbTable_UserAction();
      $adapter = new Zend_Paginator_Adapter_DbSelect(
        $uaTable->selectPopularEntries()
      );

      $paginator = $this->_paginator($adapter);
      $paginator->setItemCountPerPage($request->getQuery('count'));

      $this->view->paginator = $paginator;
      $this->_helper->layout->disableLayout();
    }
  }

  protected function _filterUrls()
  {
    if(null === $this->_filterUrls) {
      $sDbTable = new BuzzBlaze_Model_DbTable_Setting();
      $urls = explode("\n", $sDbTable->get('filter_urls')->setting_value);

      $this->_filterUrls = array();
      foreach($urls as $u) {
        $host = parse_url($u, PHP_URL_HOST);

        if(null !== $host) {
          $this->_filterUrls[] = $host;
        }
      }
    }

    return $this->_filterUrls;
  }

  protected function _filter($items)
  {
    $filtered = array();
    foreach($items as $item) {

      $eu = null;

      if($item instanceof BuzzBlaze_Model_FeedEntry) {
        $eu = parse_url($item->getGuid(), PHP_URL_HOST);
      }

      if($item instanceof Zend_Db_Table_Row) {
        $eu = parse_url($item->entry_guid, PHP_URL_HOST);
      }

      if($item instanceof BuzzBlaze_Model_Feed) {
        $eu = parse_url($item->getWebsite(), PHP_URL_HOST);
      }

      if(null === $eu || in_array($eu, $this->_filterUrls())) {
        continue;
      }

      $filtered[] = $item;
    }

    return $filtered;
  }

}
