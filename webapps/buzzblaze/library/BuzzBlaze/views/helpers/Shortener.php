<?php

class BuzzBlaze_View_Helper_Shortener extends Zend_View_Helper_Abstract
{

  public function shortener($content, $length = 5000, $encoding = null)
  {
    if(is_null($encoding)) {
      $encoding = $this->view->getEncoding();
    }

    $realLength = iconv_strlen($content, $encoding);

    if($realLength <= $length) {
      return $content;
    }

    $content = iconv_substr($content, 0, $length, $encoding);
    if(class_exists('tidy', false)) {
      $tidy = new tidy;
      $tidy->parseString(
        $this->_addContinuationMarker($content),
        array(
          'output-xhtml' => true,
          'show-body-only' => true
        ),
        str_replace('-','',$encoding)
      );
      $tidy->cleanRepair();
      $content = (string) $tidy;
    } else {
      $content = $this->_addContinuationMarker($content);
    }

    return $content;
  }

  protected function _addContinuationMarker($content)
  {
    $content = preg_replace("/(<a[^>]*)$/Di", '', $content);
    $content = preg_replace("/(<img[^>]*)$/Di", '', $content);

    return $content . '<span><em>...</em></span>';
  }

}

