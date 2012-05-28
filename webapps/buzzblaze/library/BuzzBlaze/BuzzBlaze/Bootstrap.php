<?php

class BuzzBlaze_Bootstrap extends Zend_Application_Bootstrap_Bootstrap
{
  protected function _initClasses()
  {
    Zend_Loader::loadClass('BuzzBlaze_Exception');
    Zend_Loader::loadClass('BuzzBlaze_Controller');
    Zend_Loader::loadClass('BuzzBlaze_Form');
    Zend_Loader::loadClass('UUID');
    Zend_Loader::loadFile('readability.php');
  }

  protected function _initDefaultConfig()
  {
    $options = $this->getOptions();
    Zend_Registry::set('siteConfig', $options['site']);

    return $options['site'];
  }

  protected function _initConstants()
  {
    $config = $this->getResource('siteConfig');

    if(!defined('APPLICATION_SALT')) {
      define('APPLICATION_SALT', $config['salt']);
    }

    if(isset($_SERVER['HTTP_HOST'])) {
      $uri = Zend_Uri::factory('http');
      $uri->setHost($_SERVER['HTTP_HOST']);

      define('SITE_URL', rtrim($uri->getUri(), '/') . '/');
    } else {
      define('SITE_URL', (getenv('SITE_URL') ? getenv('SITE_URL') : 'http://buzzblaze.com/'));
    }
  }

  protected function _initViews()
  {
    $this->bootstrap(array('view', 'frontController'));
    $view = $this->getResource('view');

    $options = $this->getOptions();

    $viewConfig = $options['resources']['view'];

    $view->doctype($viewConfig['doctype']);
    $view->headMeta()->setCharset($viewConfig['charset'], 'charset');
    $view->headMeta()->appendName('language', $viewConfig['language']);

    // set default title format
    $siteConfig = $options['site'];
    $view->headTitle()
      ->setSeparator($siteConfig['title_separator'])
      ->append($siteConfig['title_suffix']);

    $view->headLink(array('rel' => 'shortcut icon', 'href' => '/favicon.ico'), 'PREPEND');

    if('production' != APPLICATION_ENV) {
      $view->headMeta()->appendName('robots', 'noindex, nofollow');
    }
  }

  protected function _initPaginator()
  {
    $this->bootstrap(array('cacheManager'));
    $cacheManager = $this->getResource('cacheManager');
    $cache = $cacheManager->getCache('paginator');

    Zend_Paginator::setCache($cache);
  }

  protected function _initResponse()
  {
    $response = new Zend_Controller_Response_Http;
    $response->setHeader('content-type', 'text/html;charset=utf-8', true);

    $this->bootstrap('frontController');
    $this->getResource('frontController')->setResponse($response);
  }

  protected function _initHtmlPurifier()
  {
    if(!defined('HTMLPURIFIER_PREFIX')) {
      define('HTMLPURIFIER_PREFIX', LIBRARY_PATH);
    }
  }

  protected function _initPluginLoaderCache()
  {
    $pluginLoaderCache = ROOT_PATH . '/var/cache/pluginLoaderCache.php';

    if(file_exists($pluginLoaderCache)) {
      include_once $pluginLoaderCache;
    }

    $config = $this->getResource('siteConfig');
    if($config['enablePluginLoaderCache']) {
      Zend_Loader_PluginLoader::setIncludeFileCache($pluginLoaderCache);
    }
  }

  protected function _initRegistry()
  {
    $this->bootstrap(array('cacheManager', 'log'));

    $cacheManager = $this->getResource('cachemanager');
    Zend_Registry::set('cacheManager', $cacheManager);

    $log = $this->getResource('log');  
    Zend_Registry::set('log', $log);
  }

  public function _initBetaMode()
  {
    $this->bootstrap(array('db'));

    $sDbTable = new BuzzBlaze_Model_DbTable_Setting();
    define('BETA_MODE', (int) $sDbTable->get('beta_mode')->setting_value);
    define('NO_AD', (int) $sDbTable->get('no_ad')->setting_value);
  }

  public function _initResetData()
  {
    if(get_magic_quotes_gpc()) {
      $process = array(&$_GET, &$_POST, &$_COOKIE, &$_REQUEST);

      while (list($key, $val) = each($process)) {
        foreach ($val as $k => $v) {
          unset($process[$key][$k]);
          if (is_array($v)) {
            $process[$key][stripslashes($k)] = $v;
            $process[] = &$process[$key][stripslashes($k)];
          } else {
            $process[$key][stripslashes($k)] = stripslashes($v);
          }
        }
      }

      unset($process);
    }
  }

}

