part of compass;

class Sprite extends InteractiveObject {
  Fill _fill;
  
  Sprite() {
  }
  
  get fill => _fill;
  set fill(Fill val) {
    _fill = val;
    if(val is Image) {
      _handleImage(val);
    }
  }
  
  _handleImage(Image image) {
    if(_width == 0.0 && _height == 0.0){
      _width = image.frameWidth.toDouble();
      _height = image.frameHeight.toDouble();
    }
  }
  
  render(Renderer renderer) {
    renderer.render(this);
  }
}




