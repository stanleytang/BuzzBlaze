<?php

class BuzzBlaze_Model_UserAction extends BuzzBlaze_Model_Abstract
{

  const TYPE_LIKE = 1;

  protected $_id;
  protected $_user;
  protected $_feedEntry;
  protected $_type = 1;
  protected $_timestamp;

  protected $_skipped = array(
    'timestamp'
  );

  protected $_mapping = array(
    'id' => 'action_ID',
    'user' => 'user_ID',
    'feedEntry' => 'entry_ID',
    'type' => 'action_type',
    'timestamp' => 'action_timestamp'
  );

}

