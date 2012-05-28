<?php

class BuzzBlaze_Model_Feed extends BuzzBlaze_Model_Abstract
{
  protected $_id;
  protected $_uuid;
  protected $_url;
  protected $_website;
  protected $_title;
  protected $_description = '';
  protected $_lastFetched = '0000-00-00 00:00:00';

  protected $_mapping = array(
    'id' => 'feed_ID',
    'uuid' => 'feed_uuid',
    'url' => 'feed_url',
    'website' => 'feed_website',
    'title' => 'feed_title',
    'description' => 'feed_description',
    'lastFetched' => 'feed_last_fetched'
  );

  public function fetchUpdates()
  {
    return $this->_getMapper()->fetchUpdates($this);
  }

  public function autoSetLastFetched()
  {
    return $this->setLastFetched(date('Y-m-d H:i:s', time()));
  }

  public function entries($options = array())
  {
    return $this->_getMapper('FeedEntry')->fromFeed($this, $options);
  }

  public function autoSetUuid()
  {
    $uuid = $this->_generateUuid($this->getUrl(), UUID::nsDNS);

    return $this->setUuid($uuid);
  }

  public function subscribers($options = array())
  {
    return $this->_getMapper()->subscribers($this);
  }

  public function delete($object = null)
  {
    if(parent::delete($object)) {
      $this->_getMapper('Notification')->deleteByObject($object->getId(), 'Feed');
      return true;
    }

    return false;
  }

  public function hasImage()
  {
    return ('' == $this->_image) ? false : true;
  }

}

