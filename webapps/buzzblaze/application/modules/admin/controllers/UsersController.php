<?php

class Admin_UsersController extends BuzzBlaze_Controller
{

  public function indexAction()
  {
    $auth = Zend_Auth::getInstance();
    if(!($auth->hasIdentity() && 'admin' == $auth->getIdentity())) {
      $this->_redirector->gotoSimple('index', 'index', 'default');
    }

    $userMapper = new BuzzBlaze_Model_Mapper_User();

    $request = $this->getRequest();
    if($request->isPost()) {

      if(null != $request->getPost('export_csv')) {

        $output = '"username";"sign up date";"last login ip";"number of feeds";"number of likes";"following";"followers"' . "\n";

        foreach($request->getPost('users') as $uid){
          $user = $userMapper->find($uid);

          $o = '"' . $this->_q($user->getUsername()) . '";';
          $o .= '"' . $this->_q($user->getRegistered()) . '";';
          $o .= '"' . $this->_q($user->getLastIp()) . '";';
          $o .= '"' . $this->_q($user->statistic('feeds')) . '";';
          $o .= '"' . $this->_q($user->statistic('likes')) . '";';
          $o .= '"' . $this->_q($user->statistic('following')) . '";';
          $o .= '"' . $this->_q($user->statistic('followers')) . '"' . "\n";

          $output .= $o;
        }

        $this->getResponse()
          ->setHeader('Content-type', 'application/octet-stream')
          ->setHeader('Content-Disposition', 'attachment; filename=buzzblaze-users.csv')
          ->setBody($output)
          ->sendResponse();
        exit;
      }

      foreach ($request->getPost('users') as $uid){

        $user = $userMapper->find($uid);

        if(null != $request->getPost('disable')) {
          $user->disabled()->save();
        }

        if(null != $request->getPost('activated')) {
          $user->resetSecret()->activated()->save();
        }

        if(null != $request->getPost('delete')) {
          $user->delete();
        }
      }

      $messages = array('Users updated!');
    }

    $users = $userMapper->fetchAll();
    $this->view->users = $users;

    if(!isset($messages)) {
      $messages = $this->_flashMessenger->getMessages();
    }

    $this->view->messages = $messages;
  }

  public function editAction()
  {
    $auth = Zend_Auth::getInstance();
    if(!($auth->hasIdentity() && 'admin' == $auth->getIdentity())) {
      $this->_redirector->gotoSimple('index', 'index', 'default');
    }

    $request = $this->getRequest();
    if($request->isPost()) {
      if(null === $request->getPost('users')) {
        $form = new BuzzBlaze_Form_Admin_User();

        if($form->isValid($request->getPost())) {
          $userMapper = new BuzzBlaze_Model_Mapper_User();
          $user = $userMapper->find($request->getPost('user_id'));

          $user->setUsername($request->getPost('username'));
          $user->setFirstName($request->getPost('first_name'));
          $user->setLastName($request->getPost('last_name'));
          $user->setEmail($request->getPost('email'));

          if($user->save()) {
            $this->_flashMessenger->addMessage('User Updated!');
            $this->_redirector->gotoSimple('index', 'users', 'admin');
          }
        }
      }
    }

    if($request->getQuery('user_id')) {
      $userMapper = new BuzzBlaze_Model_Mapper_User();
      $user = $userMapper->find($request->getQuery('user_id'));

      $form = new BuzzBlaze_Form_Admin_User();
      $form->getElement('user_id')->setValue($user->getId());
      $form->getElement('username')->setValue($user->getUsername());
      $form->getElement('first_name')->setValue($user->getFirstName());
      $form->getElement('last_name')->setValue($user->getLastName());
      $form->getElement('email')->setValue($user->getEmail());
      $this->view->form = $form;
    }
  }

  public function statisticsAction()
  {
    $this->_helper->layout->disableLayout();
    $request = $this->getRequest();
    $userMapper = new BuzzBlaze_Model_Mapper_User();
    $user = $userMapper->find($request->getQuery('user_id'));

    $this->view->user = $user;
  }

  protected function _q($string)
  {
    return str_replace('"', '""', $string);
  }

}

