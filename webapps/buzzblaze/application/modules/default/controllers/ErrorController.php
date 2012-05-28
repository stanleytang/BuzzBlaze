<?php

class ErrorController extends BuzzBlaze_Controller
{
  public function errorAction()
  {
    // set custom layout
    $front = Zend_Controller_Front::getInstance();
    $this->_helper->layout
      ->setLayout('minimal')
      ->setLayoutPath(
        $front->getModuleDirectory($this->getRequest()->getModuleName()) . '/views/layouts'
      );

    $errors = $this->_getParam('error_handler');
    $message = '';

    switch($errors->type) {
      case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ROUTE:
      case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_CONTROLLER:
      case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ACTION:
        $this->getResponse()->setHttpResponseCode(404);
        $message = 'Ooppsss!!! 404, Page not found';
        break;

      default:
        $this->getResponse()->setHttpResponseCode(500);
        $message = 'Oh no... Something went wrong :(';
        break;
    }

    if($this->getInvokeArg('displayExceptions') == true) {
      $this->view->exception = $errors->exception;
    }

    $this->view->headTitle($message);
    $this->view->message = $message;
    $this->view->request = $errors->request;

    $logMessage = $errors->exception->getMessage() . "\n" . $errors->exception;
    $this->_log()->crit($logMessage);
  }
}

