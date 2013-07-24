part of compass;

class DisplayObject implements Dispose {
  String name;
  Layer parent;
  double _x, _y, _width, _height, _pivotX, _pivotY, _skewX, _skewY, _scaleX, _scaleY, _rotation, _alpha;
  bool _dirty, visible, interactive;
  Matrix3 _localTransform, _worldTransform;
  Rectangle _bounds;
  
  DisplayObject() {
    x = y = width = height = rotation = pivotX = pivotY = 0.0;
    scaleX = scaleY = 1.0;
    _dirty = false;
    visible = interactive = true;
    _localTransform = new Matrix3.identity();
    _worldTransform = new Matrix3.identity();
    _bounds = new Rectangle.zero();
  }
  
  removeFromParent() {
    if(parent != null) parent.removeChild(this);
  }
  
  render(Renderer renderer) {
    
  }
  
  hitTestPoint(Point point) => bounds.containsPoint(point);
  
  hitTestRect(Rectangle rect) => bounds.intersects(rect);

  dispose() {
    // TODO implement this method
  }
  
  get bounds {
    _updateTransform();
    return _bounds;
  }
  
  get worldTransform {
    _updateTransform();
    return _worldTransform;
  }
  
  _updateTransform() {
    if(_dirty) {
      _dirty = false;
      
      final sr = math.sin(_rotation);
      final cr = math.cos(_rotation);
      
      final Matrix3 parentTransform = parent != null ? parent.worldTransform : new Matrix3.identity();
      
      
      
      
      _localTransform[0] = cr * _scaleX;
      _localTransform[1] = -sr * _scaleY;
      _localTransform[3] = sr * _scaleX;
      _localTransform[4] = cr * _scaleY;
  
      _localTransform[2] = _x - _localTransform[0] * _pivotX - _pivotY * _localTransform[1];
      _localTransform[5] = _y - _localTransform[4] * _pivotY - _pivotX * _localTransform[3];
      
      final a00 = _localTransform[0], a01 = _localTransform[1], a02 = _localTransform[2],
          a10 = _localTransform[3], a11 = _localTransform[4], a12 = _localTransform[5],
          b00 = parentTransform[0], b01 = parentTransform[1], b02 = parentTransform[2],
          b10 = parentTransform[3], b11 = parentTransform[4], b12 = parentTransform[5];
  
      _worldTransform[0] = b00 * a00 + b01 * a10;
      _worldTransform[1] = b00 * a01 + b01 * a11;
      _worldTransform[2] = b00 * a02 + b01 * a12 + b02;
      _worldTransform[3] = b10 * a00 + b11 * a10;
      _worldTransform[4] = b10 * a01 + b11 * a11;
      _worldTransform[5] = b10 * a02 + b11 * a12 + b12;

      _bounds.setTo(
          _worldTransform[2] - (_width * _pivotX),
          _worldTransform[5] - (_height * _pivotY),
          _width, _height);
    }
  }
  
  get x => _x;
  set x(double val) {
    _x = val;
    invalidate();
  }
  
  get y => _y;
  set y(double val) {
    _y = val;
    invalidate();
  }
  
  get width => _width;
  set width(double val) {
    _width = val;
    invalidate();
  }
  
  get height => _height;
  set height(double val) {
    _height = val;
    invalidate();
  }
  
  get pivotX => _pivotX;
  set pivotX(double val) {
    _pivotX = val;
    invalidate();
  }
  
  get pivotY => _pivotY;
  set pivotY(double val) {
    _pivotY = val;
    invalidate();
  }
  
  get scaleX => _scaleX;
  set scaleX(double val) {
    _scaleX = val;
    invalidate();
  }
  
  get scaleY => _scaleY;
  set scaleY(double val) {
    _scaleY = val;
    invalidate();
  }
  
//  get skewX => _skewX;
//  set skewX(double val) {
//    _skewX = val;
//    invalidate();
//  }
//  
//  get skewY => _skewY;
//  set skewY(double val) {
//    _skewY = val;
//    invalidate();
//  }
  
  get rotation => _rotation;
  set rotation(double val) {
    _rotation = val;
    invalidate();
  }

  invalidate() => _dirty = true;
}








