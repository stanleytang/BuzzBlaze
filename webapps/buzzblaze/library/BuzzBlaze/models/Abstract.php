<?php

abstract class BuzzBlaze_Model_Abstract
{

  protected $_mapping = array();
  protected $_skipped = array();
  protected $_mappers = array();

  protected static $_htmlPurifier = null;

  public function __call($name, $arguments)
  {
    $property = substr($name, 3, strlen($name));
    $property{0} = strtolower($property{0});
    $property = '_' . $property;

    foreach($this as $var => $value) {
      if(strtolower($var) == strtolower($property)) {

        if(empty($arguments)) {
          return $this->$property;
        }

        $arg = current($arguments);
        if(null !== $arg) {
          $this->$property = $arg;
        }

        return $this;
      }
    }

    return $this;
  }

  public function save()
  {
    $result = $this->_getMapper()->save($this);

    if(null === $this->_id) {
      $this->_id = (int) $result;
    }

    return $this;
  }

  public function delete($object = null)
  {
    if(null === $this->_id) {
      return false;
    }

    $result = $this->_getMapper()->delete($this);

    if($result) {
      $this->_id = null;
    }

    return $this;
  }

  function fetchObject($objectType, $id, $returnObject = false, $subModels = array())
  {
    $objectClass = $this->_generateModelClass($objectType);
    $mapperClass = $this->_generateMapperClass($objectType);

    $getObject = "get{$objectType}";
    $setObject = "set{$objectType}";

    if($this->$getObject() instanceof $objectClass) {
      return $this;
    }

    $objectMapper = new $mapperClass();
    $object = $objectMapper->find($id, $subModels);

    if($object instanceof $objectClass) {
      if($returnObject) {
        return $object;
      }

      $this->$setObject($object);
      return $this;
    }
  }

  protected function _getMapper($objectType = null)
  {
    if(!isset($this->_mappers[$objectType])) {
      $mapperClass = $this->_generateMapperClass($objectType);
      $this->_mappers[$objectType] = new $mapperClass();
    }

    return $this->_mappers[$objectType];
  }

  public function toArray()
  {
    $array = array();
    foreach($this->getMapping() as $var => $column) {
      if(in_array($var, $this->_skipped)) {
        continue;
      }

      $colValue = call_user_func(array($this, 'get' . ucfirst($var)));

      $classInfo = explode('Model_', get_class($this));
      $className = $classInfo[0] . 'Model_' . ucfirst($var);

      if($colValue instanceof $className) {
        $colValue = call_user_func(array($colValue, 'getId'));
      }

      if(is_string($colValue)) {
//        $colValue = self::getHtmlPurifier()->purify($colValue);
      }

      $array[$column] = $colValue;
    }

    return $array;
  }

  protected function _generateUuid($string, $namespace)
  {
    return UUID::mint(5, $string, $namespace);
  }

  protected function _toSlug($string)
  {
    $string = strip_tags($string);
    $string = strtolower($string);
    $string = preg_replace('/&.+?;/', '', $string);
    $string = str_replace('.', '-', $string);
    $string = preg_replace('/[^%a-z0-9 _-]/', '', $string);
    $string = preg_replace('/\s+/', '-', $string);
    $string = preg_replace('|-+|', '-', $string);
    $string = trim($string, '-');

    return $string;
  }

  protected function _generateModelClass($objectType = null)
  {
    $classInfo = explode('Model_', get_class($this));

    if(null === $objectType) {
      $objectType = $classInfo[1];
    }

    return $classInfo[0] . 'Model_' . $objectType;
  }

  protected function _generateMapperClass($objectType = null)
  {
    return str_replace('Model_', 'Model_Mapper_', $this->_generateModelClass($objectType));
  }

  public static function getHtmlPurifier($extra = array())
  {
    if(null === self::$_htmlPurifier) {

      $siteConfig = Zend_Registry::get('siteConfig');
      $config = HTMLPurifier_Config::createDefault();

      $config->set('Cache.SerializerPath', $siteConfig['htmlPurifier']['cacheLocation']);
      $config->set('HTML.Allowed', implode(',', array(
        'p', 'em', 'strong', 'small', 'h1', 'h2', 'h3', 'h4', 'h5',
        'ul', 'ol', 'li', 'code', 'pre', 'blockquote',
        'img[src|alt|height|width|style]', 'sub', 'sup', 'a[href|rel]',
        'div[style]', 'span[class|style]', 'br'
      )));

      $config->set('HTML.Doctype', 'XHTML 1.0 Strict');
      $config->set('Filter.YouTube', true);

      if(!empty($extra)) {
        foreach($extra as $key=>$value) {
          $config->set($key, $value);
        }
      }

      self::$_htmlPurifier = new HTMLPurifier($config);
    }

    return self::$_htmlPurifier;
  }

}

