<?php

class BuzzBlaze_Model_Email extends BuzzBlaze_Model_Abstract
{
  protected $_id;
  protected $_event;
  protected $_title;
  protected $_body;
  protected $_user;
  protected $_follower;

  protected $_mapping = array(
    'id' => 'email_ID',
    'event' => 'email_event',
    'title' => 'email_title',
    'body' => 'email_body'
  );

  public function formatText($text)
  {
    $profileUrl = SITE_URL . $this->getUser()->getUsername();

    $stacks = array(
      '%username%' => $this->getUser()->getUsername(),
      '%fullname%' => $this->getUser()->getFullName(),
      '%profile_url%' => $profileUrl,
      '%confirm_url%' => $profileUrl . '?_method=CONFIRM_ACCOUNT&confirm=' . $this->getUser()->getSecret(),
      '%reset_url%' => $profileUrl . '?_method=RESET_PASSWORD&reset=' . $this->getUser()->getSecret()
    );

    if($this->getFollower() instanceof BuzzBlaze_Model_User) {
      $stacks['%follower_username%'] = $this->getFollower()->getUsername();
      $stacks['%follower_fullname%'] = $this->getFollower()->getFullName();
      $stacks['%follower_profile_url%'] = SITE_URL . $this->getFollower()->getUsername();
    }

    foreach($stacks as $key => $val) {
      $text = str_replace($key, $val, $text);
    }

    return $text;
  }

  public function getFormattedBody()
  {
    return $this->formatText($this->getBody());
  }

  public function getFormattedTitle()
  {
    return $this->formatText($this->getTitle());
  }

  public function send()
  {
    $mail = new Zend_Mail();
    $mail->addTo($this->getUser()->getEmail(), $this->getUser()->getFullName())
      ->setSubject($this->getFormattedTitle())
      ->setBodyHtml($this->getFormattedBody());

    return $mail->send();
  }
}

