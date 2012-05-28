<?php

class BuzzBlaze_GoogleReader
{

  const AUTH = 'https://www.google.com/accounts/ClientLogin';
  const EXPORT = 'http://www.google.com/reader/subscriptions/export';

  protected $_username;
  protected $_password;
  protected $_httpClient;
  protected $_authToken;

  public function __construct($username, $password)
  {
    $this->_username = $username;
    $this->_password = $password;

    $this->_httpClient = new Zend_Http_Client();
    $this->_httpClient->setCookieJar();
  }

  public function authenticate()
  {
    $data = array(
      'service' => 'reader',
      'accountType' => 'GOOGLE',
      'Email' => $this->_username,
      'Passwd' => $this->_password
    );

    $curl = curl_init();
    curl_setopt($curl, CURLOPT_URL, self::AUTH); 
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($curl, CURLOPT_POST, true);
    curl_setopt($curl, CURLOPT_POSTFIELDS, $data);

    $response = curl_exec($curl);
    curl_close($curl);

    $this->_parseAuthToken($response);

    return $this;
  }

  public function exportOpml()
  {
    $header = array('Authorization:GoogleLogin auth=' . $this->_authToken);

    $curl = curl_init();
    curl_setopt($curl, CURLOPT_URL, self::EXPORT); 
    curl_setopt($curl, CURLOPT_HTTPHEADER, $header); 
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true); 

    $response = curl_exec($curl);
    curl_close($curl);

    return $response;
  }

  protected function _parseAuthToken($response)
  {
    $match = array();
    preg_match('/Auth=(.*)/i', $response, $match);

    if(isset($match[1])) {
      $this->_authToken = $match[1];
    }

    return $this->_authToken;
  }

}
