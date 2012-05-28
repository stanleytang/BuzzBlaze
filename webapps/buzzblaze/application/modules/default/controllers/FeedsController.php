<?php

class FeedsController extends BuzzBlaze_Controller
{

  public function indexAction()
  {
    $feedMapper = new BuzzBlaze_Model_Mapper_Feed();
    $feed = $feedMapper->findOneBy('feed_uuid', $this->_getParam('feed_uuid'));

    $request = $this->getRequest();
    if($request->isPost()) {
      switch($request->getPost('_method')) {
        case 'FETCH_UPDATES':
          if($feed->fetchUpdates()) {

            $feedEntries = $feed->entries(array('limit' => 10, 'order' => 'entry_ID DESC'));
            $this->view->partialLoop()->setObjectKey('model');
            $output = $this->view->partialLoop('_partial/entry.phtml', $feedEntries);

            if($request->isXmlHttpRequest()) {
             $this->getResponse()
                ->setBody($output)
                ->sendResponse();
            }
          }
          break;
      }
      exit;
    }

    $dbTable = new BuzzBlaze_Model_DbTable_FeedEntry();
    $adapter = new Zend_Paginator_Adapter_DbSelect(
      $dbTable->selectFromFeed($feed->getId())
    );

    $count = 10;
    if(null !== $request->getQuery('count')) {
      $count = $request->getQuery('count');
    }

    $paginator = $this->_paginator($adapter);
    $paginator->setItemCountPerPage($count);
    $this->view->feed = $feed;
    $this->view->paginator = $paginator;

    if($request->isXmlHttpRequest()) {
      $this->render('ajax');
      $this->_helper->layout->disableLayout();
    }
  }

}

