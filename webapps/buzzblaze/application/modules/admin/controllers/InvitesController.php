<?php

class Admin_InvitesController extends BuzzBlaze_Controller
{

  public function indexAction()
  {
    $auth = Zend_Auth::getInstance();
    if(!($auth->hasIdentity() && 'admin' == $auth->getIdentity())) {
      $this->_redirector->gotoSimple('index', 'index', 'default');
    }

    $inviteMapper = new BuzzBlaze_Model_Mapper_Invite();
    $form = new BuzzBlaze_Form_Admin_Invite();
    $request = $this->getRequest();

    if($request->isPost()) {
      if($form->isValid($request->getPost())) {
        $invite = new BuzzBlaze_Model_Invite();
        $invite->setCode($request->getPost('code'));
        $invite->setExpires($request->getPost('expires'));

        if($invite->save()) {
          $this->view->messages = array('New invite code added!'); 
        }
      }
    }

    // fetch all invites
    $invites = $inviteMapper->fetchAll(); 

    $genForm = new BuzzBlaze_Form_Admin_GenerateInvite();
    $this->view->genForm = $genForm;

    $this->view->form = $form;
    $this->view->invites = $invites;

    if(empty($this->view->messages)) {
      $this->view->messages = $this->_flashMessenger->getMessages();
    }
  }

  public function deleteAction()
  {
    $auth = Zend_Auth::getInstance();
    if(!($auth->hasIdentity() && 'admin' == $auth->getIdentity())) {
      $this->_redirector->gotoSimple('index', 'index', 'default');
    }

    $inviteMapper = new BuzzBlaze_Model_Mapper_Invite();
    $invite = $inviteMapper->find($this->_getParam('invite_ID'));

    if(!$invite) {
      $this->_flashMessenger->addMessage('Invalid invite code!');
      $this->_redirector->gotoSimple('index', 'invites', 'admin');
    }

    if($invite->delete()) {
      $this->_flashMessenger->addMessage('Invite code deleted!');
      $this->_redirector->gotoSimple('index', 'invites', 'admin');
    }
  }

  public function bulkAction()
  {
    $auth = Zend_Auth::getInstance();
    if(!($auth->hasIdentity() && 'admin' == $auth->getIdentity())) {
      $this->_redirector->gotoSimple('index', 'index', 'default');
    }

    $this->_helper->viewRenderer->setNoRender();

    $form = new BuzzBlaze_Form_Admin_GenerateInvite();
    $request = $this->getRequest();

    if($request->isPost()) {
      if($form->isValid($request->getPost())) {
        $numOfCodes = (int) $request->getPost('numberofcodes');

        for($i=0; $i< $numOfCodes; $i++) {
          $invite = new BuzzBlaze_Model_Invite();
          $invite->autoSetCode()
            ->setExpires($request->getPost('genexpires'))
            ->save();
        }

        $this->_flashMessenger->addMessage("{$numOfCodes} invite codes generated!");
      }
    }

    $this->_redirector->gotoSimple('index', 'invites', 'admin');
  }

}

