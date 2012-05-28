<?php

class BuzzBlaze_View_Helper_QueryParser extends Zend_View_Helper_Abstract
{

  public function queryParser($options = array(), $asArray = false)
  {
    $params = array();
    parse_str($_SERVER['QUERY_STRING'], $params);

    $params = array_merge($params, $options);

    if($asArray) {
      return $params;
    }

    unset($params['submit']);

    return '?' . http_build_query($params);
  }

}

