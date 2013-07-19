part of compass;


class TextureAtlasFrame {

  final TextureAtlas _textureAtlas;
  final String _name;
  bool _rotated;
  Rectangle _frame;
  Rectangle _spriteSourceSize;
  Rectangle _sourceSize;

  TextureAtlasFrame.fromJson(TextureAtlas textureAtlas, String name, Map frame) :
    _textureAtlas = textureAtlas,
    _name = name,
    _rotated = frame["rotated"]{
    if(frame.containsKey("frame")) 
      _frame = _readRectangle(frame["frame"]);
    if(frame.containsKey("spriteSourceSize"))
      _spriteSourceSize = _readRectangle(frame["spriteSourceSize"]);
    if(frame.containsKey("sourceSize"))
      _sourceSize = _readRectangle(frame["sourceSize"]);
  }
  
  _readRectangle(rect) => new Rectangle(rect["x"], rect["y"], rect["w"], rect["h"]);

  TextureAtlas get textureAtlas => _textureAtlas;
  String get name => _name;
  bool get rotated => _rotated;
  
  Rectangle get frame => _frame;
  Rectangle get spriteSourceSize => _spriteSourceSize;
  Rectangle get sourceSize => _sourceSize;
}