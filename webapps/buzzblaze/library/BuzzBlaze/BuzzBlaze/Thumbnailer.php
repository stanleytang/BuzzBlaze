<?php

class BuzzBlaze_Thumbnailer
{

  protected $_imagePath;
  protected $_newWidth = 32;

  public function __construct($imagePath = null, $newWidth = null)
  {
    if(null != $imagePath) {
      $this->setImagePath($imagePath);
    }

    if(null != $newWidth) {
      $this->setNewWidth($newWidth);
    }
  }

  public function setImagePath($imagePath)
  {
    $this->_imagePath = $imagePath;

    return $this;
  }

  public function setNewWidth($newWidth)
  {
    $this->_newWidth = (int) $newWidth;

    return $this;
  }

  public function resize($image_path = null, $thumb_path = null)
  {
    if((null === $image_path) && (null !== $this->_imagePath)) {
      $image_path = $this->_imagePath;
    }

    if(null === $thumb_path) {
      $thumb_path = $image_path;
    }

    $n_width = $this->_newWidth;

    list($o_width, $o_height, $image_type) = getimagesize($image_path);

    switch ($image_type) {
      case 1:
        $im = imagecreatefromgif($image_path);
        break;
      case 2:
        $im = imagecreatefromjpeg($image_path);
        break;
      case 3:
        $im = imagecreatefrompng($image_path);
        break;
    }

    $n_height = floor( $o_height * ( $n_width / $o_width ) );

    $nm = imagecreatetruecolor( $n_width, $n_height );

    imagecopyresized( $nm, $im, 0, 0, 0, 0, $n_width, $n_height, $o_width, $o_height );

    switch ($image_type) {
      case 1:
        imagegif($nm, $thumb_path);
        break;
      case 2:
        imagejpeg($nm, $thumb_path);
        break;
      case 3:
        imagepng($nm, $thumb_path);
        break;
    }

    return $thumb_path;
  }

  public function generate()
  {
    if(null === $this->_imagePath) {
      return false;
    }

    $image_path = $this->_imagePath;

    $fname = basename($image_path);
    $thumb_path = str_replace($fname, "thumbs/{$fname}", $image_path);

    return $this->resize($image_path, $thumb_path);
  }
}
