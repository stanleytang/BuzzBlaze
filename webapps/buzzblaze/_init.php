<?php

if(!defined('APPLICATION_ENV')) {
  define('APPLICATION_ENV', (getenv('APPLICATION_ENV') ? getenv('APPLICATION_ENV') : 'production'));
}

if('development' == APPLICATION_ENV) {
  define('PUBLIC_PATH', ROOT_PATH . '/public');
} else {
  define('PUBLIC_PATH', ROOT_PATH . '/../../www');
}

define('LIBRARY_PATH', ROOT_PATH . '/library');
define('APPLICATION_PATH', ROOT_PATH . '/application');
define('CONFIG_PATH', APPLICATION_PATH . '/configs');

define('UPLOAD_FOLDER', 'uploads');
define('PROFILE_UPLOAD_PATH', PUBLIC_PATH . '/' . UPLOAD_FOLDER . '/profiles/');

set_include_path(implode(PATH_SEPARATOR, array(
  LIBRARY_PATH, get_include_path()
)));
