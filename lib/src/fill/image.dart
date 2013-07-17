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
    _initByImage(image);
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
  
//  Image.fromText(text, {font: "sans-serif", size: 12, color: "black", align: "start", baseline: "middle"}) {
//    html.CanvasElement canvas = new html.CanvasElement();
//    var context = canvas.context2D;
//    context.fillStyle = color;
//    context.font = "${size}px $font";
//    context.textAlign = align;
//    context.textBaseline = baseline;
//    canvas.width = _powerOfTwo(context.measureText(text).width);
//    canvas.height = _powerOfTwo(2 * size);
//    context.fillText(text, canvas.width / 2, canvas.height / 2);
//    var dataUrl = canvas.toDataUrl("image/jpeg", 0.95);
//    var img = new html.ImageElement();
//    img.src = dataUrl;
//    _initByImage(img);
//  }
  
  _initByImage(html.ImageElement image) {
    imageData = image;
    _width = image.naturalWidth;
    _height = image.naturalHeight;
    _frameX = 0;
    _frameY = 0;
    _frameWidth = _width;
    _frameHeight = _height;
  }
  
  _powerOfTwo(val, [pow = 1]) {
    while(pow < val)
      pow *= 2;
    return pow;
  }
  
  equals(Fill fill) {
    if(fill is Image)
      return imageData == (fill as Image).imageData;
    return false;
  }
  
  updateTexture(renderer) {
    if(renderer.findTexture(imageData) == null)
      renderer.cacheTexture(imageData, renderer.createImageTexure(imageData));
  }
  
  findTexture(renderer) => renderer.findTexture(imageData);

  updateBuffer(pos, buffer) {
    final tw = _width;
    final th = _height;
    final right = _frameX + _frameWidth;
    final bottom = _frameY + _frameHeight;
    
    buffer[pos + 0] = _frameX / tw;
    buffer[pos + 1] = _frameY / th;
    
    buffer[pos + 2] = right / tw;
    buffer[pos + 3] = _frameY / th;
    
    buffer[pos + 4] = right / tw;
    buffer[pos + 5] = bottom / th;
    
    buffer[pos + 6] = _frameX / tw;
    buffer[pos + 7] = bottom / th;
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