<?php

class BuzzBlaze_Paginator_Adapter extends Zend_Paginator_Adapter_DbSelect
{

  public function getItems($offset, $itemCountPerPage)
  {
    $this->_select->limit($itemCountPerPage, $offset);
    $rowset = $this->_select->getTable()->fetchAll($this->_select);

    $userMapper = new BuzzBlaze_Model_Mapper_User();
    return $userMapper->convertRowset($rowset);
  }

}

