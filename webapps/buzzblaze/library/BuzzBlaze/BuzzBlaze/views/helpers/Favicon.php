
<?php

class BuzzBlaze_View_Helper_Favicon extends Zend_View_Helper_Abstract
{

  const FAVICON_SERVER = 'http://www.google.com/s2/favicons';

  public function favicon($url)
  {
    $params = http_build_query(array(
      'domain' => parse_url($url, PHP_URL_HOST),
      'alt' => 'feed'
    ));

    return self::FAVICON_SERVER . '?' . $params;
  }

}

