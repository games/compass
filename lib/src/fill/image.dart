part of compass;


class Image extends Fill {
  int _width;
  int _height;
  int _frameX;
  int _frameY;
  int _frameWidth;
  int _frameHeight;
  
  html.ImageElement imageData;
  
  Image.fromImageElement(html.ImageElement image) {
    imageData = image;
    _width = image.naturalWidth;
    _height = image.naturalHeight;
    _frameX = 0;
    _frameY = 0;
    _frameWidth = _width;
    _frameHeight = _height;
  }
  
  Image.fromTextureAtlasFrame(TextureAtlasFrame frame) {
    imageData = frame.textureAtlas._image.imageData;
    _width = imageData.naturalWidth;
    _height = imageData.naturalHeight;
    _frameX = frame.frameX;
    _frameY = frame.frameY;
    _frameWidth = frame.frameWidth;
    _frameHeight = frame.frameHeight;
  }
  
  equals(Fill fill) {
    if(fill is Image)
      return imageData == (fill as Image).imageData;
    return false;
  }
  
  int get frameX => _frameX;
  int get frameY => _frameY;
  int get frameWidth => _frameWidth;
  int get frameHeight => _frameHeight;
  int get width => _width;
  int get height => _height;
  
  static Future<Image> load(String url) {
    Completer<Image> completer = new Completer<Image>();

    html.ImageElement imageElement = new html.ImageElement();
    StreamSubscription onLoadSubscription;
    StreamSubscription onErrorSubscription;

    onLoadSubscription = imageElement.onLoad.listen((event) {
      onLoadSubscription.cancel();
      onErrorSubscription.cancel();
      completer.complete(new Image.fromImageElement(imageElement));
    });

    onErrorSubscription = imageElement.onError.listen((event) {
      onLoadSubscription.cancel();
      onErrorSubscription.cancel();
      completer.completeError(new StateError("Error loading image."));
    });
    
    imageElement.src = url;
    
    return completer.future;
  }
}