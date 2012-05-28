<?php

class BuzzBlaze_Model_Mapper_FeedEntry extends BuzzBlaze_Model_Mapper_Abstract
{

  public function delete($object)
  {
    if(parent::delete($object)) {
      $this->_getMapper('Notification')->deleteByObject($object->getId(), 'FeedEntry');
      return true;
    }

    return false;
  }

  public function fromFeed($feed)
  {
    return $this->convertRowset(
      $this->getDbTable()->fromFeed($feed->getId())
    );
  }

}

