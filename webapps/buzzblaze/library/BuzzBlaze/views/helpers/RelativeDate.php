<?php

class BuzzBlaze_View_Helper_RelativeDate extends Zend_View_Helper_Abstract
{

  public function RelativeDate($time)
  {
    $today = time();
    $reldays = ($time - $today) / 86400;

    if($reldays >= 0 && $reldays < 1) {
      return 'today';
    } elseif($reldays >= 1 && $reldays < 2) {
      return 'tomorrow';
    } elseif($reldays >= -1 && $reldays < 0) {
      return 'yesterday';
    }

    if(abs($reldays) < 30) {
      if($reldays > 0) {
        $reldays = floor($reldays);
        return 'in ' . $reldays . ' day' . ($reldays != 1 ? 's' : '');
      } else {
        $reldays = abs(floor($reldays));
        return $reldays . ' day'  . ($reldays != 1 ? 's' : '') . ' ago';
      }
    }

    if(abs($reldays) < 182) {
      return date('l, F j',$time ? $time : time());
    } else {
      return date('l, F j, Y',$time ? $time : time());
    }
  }

}

