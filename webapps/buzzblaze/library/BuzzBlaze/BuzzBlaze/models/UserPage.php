<?php

class BuzzBlaze_Model_UserPage extends BuzzBlaze_Model_Abstract
{

  protected $_id;
  protected $_user;
  protected $_name;
  protected $_title;

  protected $_mapping = array(
    'id' => 'page_ID',
    'user' => 'user_ID',
    'name' => 'page_name',
    'title' => 'page_title'
  );

  public function save()
  {
    // auto set name
    if(null === $this->getTitle()) {
      throw new BuzzBlaze_Exception('User page title is empty.');
    }

    $this->setName($this->_toSlug($this->getTitle()));

    return parent::save();
  }

  public function feeds()
  {
    return $this->_getMapper()->feeds($this);
  }

}

