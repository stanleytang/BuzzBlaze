<?php

class BuzzBlaze_Plugin_OutputOptimizer extends Zend_Controller_Plugin_Abstract
{

  public function dispatchLoopShutdown()
  {
    if('production' != APPLICATION_ENV) {
      return;
    }

    $headers = $this->getResponse()->getHeaders();
    foreach($headers as $name => $value) {
      if('application/octet-stream' == $value) {
        return;
      }
    }

    // strip whitespace from output
    $buffer = trim(preg_replace('/\s+/', ' ', $this->getResponse()->getBody()));

    // check if the browser accepts gzip encoding
    if(strpos($_SERVER['HTTP_ACCEPT_ENCODING'], 'gzip') !== FALSE)
    {
      $buffer = gzencode($buffer);
      $this->getResponse()->setHeader('Content-Encoding', 'gzip');
    }

    $this->getResponse()->setBody($buffer);
  }

}

