<?php

class BuzzBlaze_View_Helper_ContentThumb extends Zend_View_Helper_Abstract
{

  public function contentThumb($content)
  {
    $matches = array();
    preg_match_all('|<img.*?src=[\'"](.*?)[\'"].*?>|i', $content, $matches);

    $valid = array();

    if(isset($matches[1][0])) {

      foreach($matches[1] as $url) {
        // select valid images only; remove ads and also social media button
        if(!(preg_match('/(api.tweetmeme.com|doubleclick.net|feeds.feedburner.com|.gif)/i', $url))) {
          if(preg_match('/(.png|.jpe?g)/i', $url)) {
            $valid[] = $url;
          }
        }
      }

      return current($valid);
    }

    return false;
  }

}

