<?php

class BuzzBlaze_Controller extends Zend_Controller_Action
{

  protected $_flashMessenger;
  protected $_redirector;

  public function init()
  {
    $this->_flashMessenger = $this->_helper->getHelper('FlashMessenger');
    $this->_redirector = $this->_helper->getHelper('Redirector');

    $request = $this->getRequest();
    if('admin' == $request->getModuleName() && 'production' == APPLICATION_ENV) {
      $this->view->headMeta()->appendName('robots', 'noindex, nofollow');
    }

    $auth = Zend_Auth::getInstance();
    if($auth->hasIdentity()) {
      if('admin' == $auth->getIdentity() && 'admin' != $request->getModuleName()) {
        $this->_redirector->gotoSimple('index', 'index', 'admin');
      }
    }
  }

  protected function _debug($object)
  {
    Zend_Debug::dump($object);
  }

  protected function _log()
  {
    $bootstrap = $this->getInvokeArg('bootstrap');
    if(!$bootstrap->hasPluginResource('Log')) {
      return false;
    }

    return $bootstrap->getResource('Log');
  }

  protected function _cache($cache = 'standard')
  {
    $bootstrap = $this->getInvokeArg('bootstrap');
    $cachemanager = $bootstrap->getResource('cachemanager');

    return $cachemanager->getCache($cache);
  }

  protected function _paginator($adapter)
  {
    $paginator = new Zend_Paginator($adapter);

    $config = Zend_Registry::get('siteConfig');
    $paginator->setItemCountPerPage($config['itemsPerPage']);
    $paginator->setCurrentPageNumber($this->_getParam('page'));

    return $paginator;
  }

}

