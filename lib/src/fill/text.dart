part of compass;

class Text extends Fill {
  html.CanvasElement _canvas;
  html.CanvasRenderingContext2D _context;
  
  String _text;
  String _font;
  num _size;
  String _align;
  String _baseline;
  String _color;
  
  Text(this._text, {font: "helvetiker", size: 12, color: "black", align: "start", baseline: "middle", multiline, maxWidth}) {
    _canvas = new html.CanvasElement();
    _context = _canvas.context2D;

    _font = font;
    _size = size;
    _color = color;
    _align = align;
    _baseline = baseline;
    
    _update();
  }
  
  _update() {
    _context.fillStyle = _color;
    _context.font = "${_size}px $_font";
    _context.textAlign = _align;
    _context.textBaseline = _baseline;
    _canvas.width = _powerOfTwo(_context.measureText(_text).width);
    _canvas.height = _powerOfTwo(2 * _size);
    _context.fillText(_text, 0, _canvas.height / 2);
  }
  
  _powerOfTwo(val, [pow = 1]) {
    while(pow < val)
      pow *= 2;
    return pow;
  }
  
  equals(Fill fill) {
    if(fill is Text)
      return _text == (fill as Text)._text;
    return false;
  }
  
  updateTexture(renderer) {
    if(renderer.findTexture(this) == null)
      renderer.cacheTexture(this, renderer.createCanvasTexure(_canvas));
  }
  
  findTexture(renderer) => renderer.findTexture(this);
  
  updateBuffer(pos, buffer) {
    buffer[pos + 0] = 0.0;
    buffer[pos + 1] = 0.0;
    
    buffer[pos + 2] = 1.0;
    buffer[pos + 3] = 0.0;
    
    buffer[pos + 4] = 1.0;
    buffer[pos + 5] = 1.0;
    
    buffer[pos + 6] = 0.0;
    buffer[pos + 7] = 1.0;
  }
  
  get text => _text;
  get width => _canvas.width;
  get height => _canvas.height;
}