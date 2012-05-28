<?php

abstract class BuzzBlaze_Model_DbTable_Abstract extends Zend_Db_Table_Abstract
{

  protected function _setupTableName()
  {
    parent::_setupTableName();

    $this->_name = 'bb_' . $this->_name;
  }

  /**
  * Called by parent table's class during delete() method.
  * references:
  * - http://framework.zend.com/issues/browse/ZF-1103
  * - http://stackoverflow.com/questions/3023809/zend-framework-problem-with-database-table-recursive-cascading-deletes
  *
  * @param  string $parentTableClassname
  * @param  array  $primaryKey
  * @return int    Number of affected rows
  */
  public function _cascadeDelete($parentTableClassname, array $primaryKey)
  {
    $this->_setupMetadata();
    $rowsAffected = 0;
    foreach($this->_getReferenceMapNormalized() as $map) {
      if($map[self::REF_TABLE_CLASS] == $parentTableClassname && isset($map[self::ON_DELETE])) {
        switch($map[self::ON_DELETE]) {

          case self::CASCADE:
            $select = $this->select();

            for($i = 0; $i < count($map[self::COLUMNS]); ++$i) {
              $col = $this->_db->foldCase($map[self::COLUMNS][$i]);
              $refCol = $this->_db->foldCase($map[self::REF_COLUMNS][$i]);
              $type = $this->_metadata[$col]['DATA_TYPE'];
              $select->where($this->_db->quoteIdentifier($col, true) . ' = ?',
                $primaryKey[$refCol], $type);
            }

            $rows = $this->fetchAll($select);
            $rowsAffected += count($rows);

            foreach($rows as $row) {
              $row->delete();
            }

            break;

          case self::SET_NULL: {
            $update = array();
            $where = array();

            for($i = 0; $i < count($map[self::COLUMNS]); ++$i) {
              $col = $this->_db->foldCase($map[self::COLUMNS][$i]);
              $refCol = $this->_db->foldCase($map[self::REF_COLUMNS][$i]);
              $type = $this->_metadata[$col]['DATA_TYPE'];
              $update[$col] = null;
              $where[] = $this->_db->quoteInto(
                $this->_db->quoteIdentifier($col, true) . ' = ?',
                $primaryKey[$refCol], $type);
            }

            $rowsAffected += $this->update($update, $where);
            break;
          }

          default:
            // no action
            break;
        }
      }
    }

    return $rowsAffected;
  }

}

