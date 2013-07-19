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
      _width = image.frame.width.toDouble();
      _height = image.frame.height.toDouble();
  }
  
  render(Renderer renderer) {
    renderer.render(this);
  }
}




