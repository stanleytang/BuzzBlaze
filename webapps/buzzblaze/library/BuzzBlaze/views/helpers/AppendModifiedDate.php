<?php

class BuzzBlaze_View_Helper_AppendModifiedDate extends Zend_View_Helper_Abstract
{

  public function appendModifiedDate($uri)
  {
    $parts = parse_url($uri);
    $root = getcwd();
    $mtime = filemtime($root . $parts['path']);
    return preg_replace(
      "/(\.[a-z0-9]+)(\?*.*)$/",
      '$1$2?' . $mtime,
      $uri
    );
  }

}

