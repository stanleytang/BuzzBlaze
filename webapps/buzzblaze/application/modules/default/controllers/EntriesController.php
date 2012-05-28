<?php

class EntriesController extends BuzzBlaze_Controller
{
  protected $_currentEntry;

  public function indexAction()
  {
    $feedEntry = $this->_currentEntry();
    $this->view->feedEntry = $feedEntry;

    $request = $this->getRequest();
    if(null != $request->getQuery('_method')) {

      switch($request->getQuery('_method')) {

        case 'LIKE_ENTRY':
          $authUser = Zend_Registry::get('authUser');
          $userAction = new BuzzBlaze_Model_UserAction();
          $userAction->setUser($authUser)
            ->setFeedEntry($feedEntry)
            ->setType(BuzzBlaze_Model_UserAction::TYPE_LIKE);

          if($userAction->save()) {
            // add to notification system
            $notification = new BuzzBlaze_Model_Notification();
            $notification->setScope(BuzzBlaze_Model_Notification::SCOPE_PUBLIC)
              ->setEvent('like')
              ->setUser($authUser)
              ->setObject($feedEntry->getId())
              ->setObjectType('FeedEntry')
              ->save();

            // remove cache
            $cache = $this->_cache('fragment');
            $cache->clean(
              Zend_Cache::CLEANING_MODE_MATCHING_TAG,
              array($authUser->getUsername(), 'activities')
            );

            if($request->isXmlHttpRequest()) {
              $this->_helper->json(array('msg' => 'success'));
            }
          }
          break;

        case 'UNLIKE_ENTRY':
          $authUser = Zend_Registry::get('authUser');
          $liked = $authUser->isLiked($feedEntry);

          if($liked && $liked->delete()) {
            if($request->isXmlHttpRequest()) {
              $this->_helper->json(array('msg' => 'success'));
            }
          }
          break;

        case 'READ_ENTRY':
          // set custom layout
          $front = Zend_Controller_Front::getInstance();
          $this->_helper->layout
            ->setLayout('minimal')
            ->setLayoutPath(
              $front->getModuleDirectory($this->getRequest()->getModuleName()) . '/views/layouts'
            );

          /**
          if(Zend_Auth::getInstance()->hasIdentity()) {

            $authUser = Zend_Registry::get('authUser');
            $userAction = new BuzzBlaze_Model_UserAction();
            $userAction->setUser($authUser)
              ->setFeedEntry($feedEntry)
              ->setType(BuzzBlaze_Model_UserAction::TYPE_READ)
              ->save();
          }
          */

          $this->render('clean');
          break;
      }
    }
  }

  protected function _currentEntry()
  {
    if(null === $this->_currentEntry) {
      $feedEntryMapper = new BuzzBlaze_Model_Mapper_FeedEntry();
      $this->_currentEntry = $feedEntryMapper->findOneBy('entry_uuid', $this->_getParam('entry_uuid'), array('Feed'));
    }

    return $this->_currentEntry;
  }

}

