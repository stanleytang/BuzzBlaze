<?php

abstract class BuzzBlaze_Model_Mapper_Abstract
{

  protected $_idField;
  protected $_dbTables = array();
  protected $_mappers = array();
  protected $_useJoin = false;

  public function fetchAll($options = array(), $subModels = array())
  {
    $select = $this->getDbSelect($options);

    if(!empty($subModels)) {
      $select = $this->_joinMatrix(
        $this->useJoin()->getDbSelect($options), $subModels
      );
    }

    $rowset = $this->getDbTable()->fetchAll($select);

    return $this->convertRowset($rowset, $subModels);
  }

  public function save($object, $data = null)
  {
    if(null === $data) {
      $data = $object->toArray();
    }

    $id = 0;
    if(null != $data[$this->_getIdField()]) {
      $id = (int) $data[$this->_getIdField()];
    }

    // remove ID from data
    unset($data[$this->_getIdField()]);

    if(0 == $id) {
      return $this->getDbTable()->insert($data);
    }

    return $this->getDbTable()
      ->update($data, array("{$this->_getIdField()} = ?" => $id));
  }

  public function delete($object)
  {
    $row = $this->getDbTable()
      ->fetchRow("{$this->_getIdField()} = {$object->getId()}");

    return $row->delete();
  }

  public function findBy($field, $value, $options = array(), $subModels = array())
  {
    $default = array('where' => array("{$field} = ?", $value));
    $options = $this->_mergeOptions($default, $options);

    return $this->fetchAll($options, $subModels);
  }

  public function findOneBy($field, $value, $subModels = array())
  {
    return current($this->findBy($field, $value, array('limit' => 1), $subModels));
  }

  public function find($id, $subModels = array())
  {
    $modelMapping = $this->_getModelMapping();

    return $this->findOneBy($modelMapping['id'], $id, $subModels);
  }

  public function getDbTable($objectType = null)
  {
    if(!isset($this->_dbTables[$objectType])) {
      $dbTableClass = $this->_generateDbTableClass($objectType);
      $this->_dbTables[$objectType] = new $dbTableClass();
    }

    return $this->_dbTables[$objectType];
  }

  public function convertRowset($rowset, $subModels = array())
  {
    $entries = array();
    foreach($rowset as $row) {
      $entries[] = $this->toModelRecursive($row, $subModels);
    }

    return $entries;
  }

  public function useJoin($boolean = true)
  {
    $this->_useJoin = $boolean;

    return $this;
  }

  public function getDbSelect($options = array(), $dbObjectType = null)
  {
    $dbTable = $this->getDbTable($dbObjectType);
    $select = $dbTable->select();

    if($this->_useJoin) {
      $select = $dbTable->select(Zend_Db_Table::SELECT_WITH_FROM_PART)
        ->setIntegrityCheck(false);
    }

    if(!empty($options)) {
      foreach($options as $option => $value) {
        if(is_array($value)) {
          call_user_func_array(array($select, $option), $value);
        } else {
          call_user_func(array($select, $option), $value);
        }
      }
    }

    // reset useJoin value
    $this->useJoin(false);

    return $select;
  }

  public function toModel($row, $objectType = null)
  {
    $modelClass = $this->_generateModelClass($objectType);
    $model = new $modelClass();
    $mapping = $model->getMapping();

    foreach($mapping as $var => $column) {
      call_user_func(array($model, 'set' . ucfirst($var)), $row->$column);
    }

    return $model;
  }

  public function toModelRecursive($row, $objects = array())
  {
    $model = $this->toModel($row);

    if(!empty($objects)) {
      foreach($objects as $obj) {
        $subModelMapping = $this->_getModelMapping($obj);
        foreach($subModelMapping as $var => $column) {
          call_user_func(array($model, 'set' . $obj), $this->toModel($row, $obj));
        }
      }
    }

    return $model;
  }

  protected function _getIdField()
  {
    if(null === $this->_idField) {
      $modelMapping = $this->_getModelMapping();
      $this->_idField = $modelMapping['id'];
    }

    return $this->_idField;
  }

  protected function _generateMapperClass($objectType = null)
  {
    $classInfo = explode('Mapper_', get_class($this));

    if(null === $objectType) {
      $objectType = $classInfo[1];
    }

    return $classInfo[0] . 'Mapper_' . $objectType;
  }

  protected function _generateModelClass($objectType = null)
  {
    return str_replace('Mapper_', '', $this->_generateMapperClass($objectType));
  }

  protected function _generateDbTableClass($objectType = null)
  {
    return str_replace('Mapper_', 'DbTable_', $this->_generateMapperClass($objectType));
  }

  protected function _getMapper($objectType = null)
  {
    if(!isset($this->_mappers[$objectType])) {
      $mapperClass = $this->_generateMapperClass($objectType);
      $this->_mappers[$objectType] = new $mapperClass();
    }

    return $this->_mappers[$objectType];
  }

  protected function _mergeOptions($options, $newOptions)
  {
    return array_merge($options, $newOptions);
  }

  protected function _joinMatrix($select, $subModels)
  {
    $tableInfo = $this->getDbTable()->info();
    foreach($subModels as $model) {

      $modelTableInfo = $this->getDbTable($model)->info();
      $modelMapping = $this->_getModelMapping($model);

      $params = array(
        $modelTableInfo['name'],
        "{$modelTableInfo['name']}.{$modelMapping['id']} = {$tableInfo['name']}.{$modelMapping['id']}"
      );

      call_user_func_array(array($select, 'joinLeft'), $params);
    }

    return $select;
  }

  protected function _getModelMapping($objectType = null)
  {
    $modelClass = $this->_generateModelClass($objectType);
    $modelObject = new $modelClass;

    return $modelObject->getMapping();
  }

}

