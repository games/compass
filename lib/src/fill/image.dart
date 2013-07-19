part of compass;


class Image extends Fill {
  int _width;
  int _height;
  
  Rectangle _frame;
  int _offsetX, _offsetY;
  
  html.ImageElement imageData;
  
  Image.fromImageElement(html.ImageElement image) {
    _initByImage(image);
  }
  
  Image.fromTextureAtlasFrame(TextureAtlasFrame frame) {
    imageData = frame.textureAtlas._image.imageData;
    _width = imageData.naturalWidth;
    _height = imageData.naturalHeight;
    
    _offsetX = frame.spriteSourceSize.x;
    _offsetY = frame.spriteSourceSize.y;
    _frame = frame.frame;
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
    _offsetX = 0;
    _offsetY = 0;
    _frame = new Rectangle(0, 0, _width, _height);
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
    final right = frame.x + frame.width;
    final bottom = frame.y + frame.height;
    
    buffer[pos + 0] = frame.x / tw;
    buffer[pos + 1] = frame.y / th;
    
    buffer[pos + 2] = right / tw;
    buffer[pos + 3] = frame.y / th;
    
    buffer[pos + 4] = right / tw;
    buffer[pos + 5] = bottom / th;
    
    buffer[pos + 6] = frame.x / tw;
    buffer[pos + 7] = bottom / th;
  }
  
  int get width => _width;
  int get height => _height;
  int get offsetX => _offsetX;
  int get offsetY => _offsetY;
  Rectangle get frame => _frame;
  
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