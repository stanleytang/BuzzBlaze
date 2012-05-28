<?php

class BuzzBlaze_Model_UserFeed extends BuzzBlaze_Model_Abstract
{

  const DISPLAY_IMAGE_SCROLLING = 0;
  const DISPLAY_MODULAR = 1;

  protected $_id;
  protected $_feed;
  protected $_userPage;
  protected $_display = 0;
  protected $_title = null;
  protected $_color = 'color-white';
  protected $_order = 0;

  protected $_mapping = array(
    'id' => 'ufeed_ID',
    'feed' => 'feed_ID',
    'userPage' => 'page_ID',
    'display' => 'ufeed_display',
    'title' => 'ufeed_title',
    'color' => 'ufeed_color',
    'order' => 'ufeed_order'
  );

  public function getDisplayString()
  {
    if(self::DISPLAY_IMAGE_SCROLLING == $this->getDisplay()) {
      return 'w-big';
    }

    return 'w-small';
  }

  public function getTitle()
  {
    if(null === $this->_title) {
      if(!($this->getFeed() instanceof BuzzBlaze_Model_Feed)) {
        $this->fetchObject('Feed', $this->getFeed());
      }

      return $this->getFeed()->getTitle();
    }

    return $this->_title;
  }

}

