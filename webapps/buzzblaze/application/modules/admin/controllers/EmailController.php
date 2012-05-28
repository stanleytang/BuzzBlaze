<?php

class Admin_EmailController extends BuzzBlaze_Controller
{

  public function indexAction()
  {
    $auth = Zend_Auth::getInstance();
    if(!($auth->hasIdentity() && 'admin' == $auth->getIdentity())) {
      $this->_redirector->gotoSimple('index', 'index', 'default');
    }

    $form = new BuzzBlaze_Form_Admin_EmailBroadcast();

    $request = $this->getRequest();
    if($request->isPost()) {
      if($form->isValid($request->getPost())) {
        try {
          foreach($request->getPost('recipients') as $recipient) {
            $mail = new Zend_Mail();
            $mail->addTo($recipient)
              ->setSubject($request->getPost('email_title'))
              ->setBodyHtml($request->getPost('email_body'));

            if($mail->send()) {
              $this->view->messages = array('Email has been sent!');
            }
          }
        } catch (Exception $e) {
          $this->_log()->crit($e->getMessage());
        }
      }
    }

    $this->view->form = $form;
  }

  public function editorAction()
  {
    $auth = Zend_Auth::getInstance();
    if(!($auth->hasIdentity() && 'admin' == $auth->getIdentity())) {
      $this->_redirector->gotoSimple('index', 'index', 'default');
    }

    $emailMapper = new BuzzBlaze_Model_Mapper_Email();
    $this->view->emails = $emailMapper->fetchAll();

    $form = new BuzzBlaze_Form_Admin_Email();

    $request = $this->getRequest();
    if($request->isPost()) {
      if($form->isValid($request->getPost())) {
        $email = $emailMapper->findOneBy('email_event', $request->getPost('email_event'));
        $email->setTitle($request->getPost('email_title'));
        $email->setBody($request->getPost('email_body'));
        if($email->save()) {
          $this->view->messages = array('Email updated!');
        }
      }
    }

    if($request->getQuery('event')) {
      $email = $emailMapper->findOneBy('email_event', $request->getQuery('event'));
      $form->setAction($this->view->url(
        array('action' => $this->_getParam('action'), 'controller' => $this->_getParam('controller'), 'module' => $this->_getParam('module')), 'default'
      ));
      $form->getElement('email_event')->setValue($email->getEvent());
      $form->getElement('email_title')->setValue($email->getTitle());
      $form->getElement('email_body')->setValue($email->getBody());

      $this->view->form = $form;
    }
  }

}

