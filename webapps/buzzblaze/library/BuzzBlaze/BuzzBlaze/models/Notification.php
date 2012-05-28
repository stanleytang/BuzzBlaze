<?php

class BuzzBlaze_Model_Notification extends BuzzBlaze_Model_Abstract
{
  const SCOPE_PRIVATE = 0;
  const SCOPE_PUBLIC = 1;

  protected $_id;
  protected $_scope;
  protected $_event;
  protected $_user;
  protected $_object = 0;
  protected $_objectType = '';
  protected $_created;

  protected $_mapping = array(
    'id' => 'notification_ID',
    'scope' => 'notification_scope',
    'event' => 'notification_event',
    'user' => 'user_ID',
    'object' => 'object_ID',
    'objectType' => 'object_type',
    'created' => 'notification_created'
  );

  protected $_skipped = array('created');

}
