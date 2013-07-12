part of compass;


class TextureAtlasFrame {

  final TextureAtlas _textureAtlas;
  final String _name;
  bool _rotated;
  int _frameX;
  int _frameY;
  int _frameWidth;
  int _frameHeight;

  TextureAtlasFrame.fromJson(TextureAtlas textureAtlas, String name, Map frame) :
    _textureAtlas = textureAtlas,
    _name = name,
    _rotated = _ensureBool(frame["rotated"]){
    if(frame.containsKey("frame")) {
      _frameX = _ensureInt(frame["frame"]["x"]);
      _frameY = _ensureInt(frame["frame"]["y"]);
      _frameWidth = _ensureInt(frame["frame"]["w"]);
      _frameHeight = _ensureInt(frame["frame"]["h"]);
    }else{
      _frameX = _ensureInt(frame["spriteSourceSize"]["x"]);
      _frameY = _ensureInt(frame["spriteSourceSize"]["y"]);
      _frameWidth = _ensureInt(frame["spriteSourceSize"]["w"]);
      _frameHeight = _ensureInt(frame["spriteSourceSize"]["h"]);
    }
  }

  TextureAtlas get textureAtlas => _textureAtlas;
  String get name => _name;
  bool get rotated => _rotated;
  
  int get frameX => _frameX;
  int get frameY => _frameY;
  int get frameWidth => _frameWidth;
  int get frameHeight => _frameHeight;
}