<?php

class AuthController extends BuzzBlaze_Controller
{

  public function loginAction()
  {
    $auth = Zend_Auth::getInstance();

    if($auth->hasIdentity()) {
      $this->_redirector->gotoRoute(array(), 'dashboard');
    }

    $form = new BuzzBlaze_Form_Login();

    $request = $this->getRequest();
    if($request->isPost()) {
      if($form->isValid($request->getPost())) {

        Zend_Loader::loadClass('BuzzBlaze_Auth_Adapter');
        $authAdapter = new BuzzBlaze_Auth_Adapter();
        $authAdapter->setIdentity($request->getPost('identity'))
          ->setCredential($request->getPost('password'));

        $result = $auth->authenticate($authAdapter);

        if($result->isValid()) {

          $user = $authAdapter->getUser();
          if($user->isActive()) {
            $user->resetSecret();
          }

          $user->autoSetLastLogin()
            ->autoSetLastIp()
            ->save();

          if(1 == $request->getPost('rememberme')) {
            // remember me
            $config = Zend_Registry::get('siteConfig');
            Zend_Session::rememberMe((int) $config['rememberMe']);
          }

          $this->_redirector->gotoRoute(array(), 'dashboard');
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
      Zend_Session::forgetMe();

      if(!$auth->hasIdentity()) {
        $this->_flashMessenger->addMessage("You've successfully log out!");
        $this->_redirector->gotoSimple('index', 'index', 'default');
      }
    }
  }

  public function forgotAction()
  {
    $form = new BuzzBlaze_Form_Forgot();

    $request = $this->getRequest();
    if($request->isPost()) {
      if($form->isValid($request->getPost())) {
        $userMapper = new BuzzBlaze_Model_Mapper_User();

        $user = $userMapper->byIdentity($request->getPost('identity'));

        if($user) {

          // auto generate secret key
          $user->autoSetSecret()->save();

          try {
            $emailMapper = new BuzzBlaze_Model_Mapper_Email();
            $email = $emailMapper->findOneBy('email_event', 'forgot_password');
            $email->setUser($user);
            $email->send();
          } catch(Zend_Mail_Exception $e) {
            $this->_log()->crit("Unable to send email to {$user->getEmail()}.");
          }

          $this->_flashMessenger->addMessage(
            'Please check your inbox and follow the instruction to reset your password'
          );

          $this->_redirector->gotoSimple('index', 'index', 'default');
        }

        $this->view->messages = array('Username or email address is not registered with us!');
      }
    }

    $this->view->form = $form;
  }

  public function resetAction()
  {
    if(!$this->_hasParam('username') && !$this->_hasParam('reset')) {
      $this->_redirector->gotoSimple('index', 'index', 'default');
    }

    $form = new BuzzBlaze_Form_Reset();

    $request = $this->getRequest();
    if($request->isPost()) {
      if($form->isValid($request->getPost())) {
        $userMapper = new BuzzBlaze_Model_Mapper_User();
        $user = $userMapper->findOneBy('user_login', $request->getPost('username'));

        $message = 'Invalid parameters, possibly attacking attempt!';
        if($user && $user->validateSecret($request->getPost('secret'))) {
          $user->updatePassword($request->getPost('password'))
            ->resetSecret();

          if($user->save()) {
            $message = 'Password has been reset!';
          }
        }

        $this->_flashMessenger->addMessage($message);
        $this->_redirector->gotoSimple('index', 'index', 'default');
      }
    }

    $form->username->setValue($this->_getParam('username'));
    $form->secret->setValue($this->_getParam('reset'));

    $this->view->form = $form;
  }

}

