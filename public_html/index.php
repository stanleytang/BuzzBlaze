<?php

define('ROOT_PATH', realpath(dirname(__FILE__) . '/../webapps/buzzblaze'));

require_once ROOT_PATH . '/_init.php';
require_once 'Zend/Cache.php';
require_once 'Zend/Application.php';
require_once 'Zend/Config/Ini.php';

$configFiles = array(
  CONFIG_PATH . '/application.ini',
  CONFIG_PATH . '/routes.ini',
  CONFIG_PATH . '/cache.ini',
  CONFIG_PATH . '/site.ini'
);

$configCache = Zend_Cache::factory(
  'File',
  'File',
  array(
    'lifetime' => null,
    'automatic_cleaning_factor' => 0,
    'automatic_serialization' => true,
    'master_files' => $configFiles
  ),
  array(
    'cache_dir' => ROOT_PATH . '/tmp/cache',
  )
);

$config = null;
if(!($config = $configCache->load('config'))) {
  $configPart = null;
  foreach($configFiles as $file) {
    if(null === $configPart) {
      $configPart = new Zend_Config_Ini($file, APPLICATION_ENV, true);
    } else {
      $configPart->merge(new Zend_Config_Ini($file, APPLICATION_ENV));
    }
  }

  $config = $configPart->toArray();
  $configCache->save($config, 'config');
}

// run application!
$application = new Zend_Application(APPLICATION_ENV, $config);
$application->bootstrap()
  ->run();

