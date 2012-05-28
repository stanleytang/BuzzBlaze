<?php

class BuzzBlaze_View_Helper_ActiveMenu extends Zend_View_Helper_Abstract
{

  public function activeMenu($current)
  {
    return ($this->view->active == $current) ? 'active' : '';
  }

}

