part of compass;

class TextureAtlas {
  Image _image;
  final List<TextureAtlasFrame> _frames = new List<TextureAtlasFrame>();
  
  static Future<TextureAtlas> load(String url) {
    Completer<TextureAtlas> completer = new Completer<TextureAtlas>();
    TextureAtlas textureAtlas = new TextureAtlas();
    html.HttpRequest.getString(url).then((textureAtlasJson) {
      var data = json.parse(textureAtlasJson);
      var frames = data["frames"];
      var meta = data["meta"];
      var imageUrl = _replaceFilename(url, meta["image"]);

      if (frames is List) {
        for(var frame in frames) {
          var frameMap = frame as Map;
          var fileName = frameMap["filename"] as String;
          var frameName = _getFilenameWithoutExtension(fileName);
          var taf = new TextureAtlasFrame.fromJson(textureAtlas, frameName, frameMap);
          textureAtlas._frames.add(taf);
        }
      }

      if (frames is Map) {
        for(String fileName in frames.keys) {
          var frameMap = frames[fileName] as Map;
          var frameName = _getFilenameWithoutExtension(fileName);
          var taf = new TextureAtlasFrame.fromJson(textureAtlas, frameName, frameMap);
          textureAtlas._frames.add(taf);
        }
      }

      Image.load(imageUrl).then((Image image) {
        textureAtlas._image = image;
        completer.complete(textureAtlas);
      }).catchError((error) {
        completer.completeError(new StateError("Failed to load image."));
      });

    }).catchError((error) {
      completer.completeError(new StateError("Failed to load json file."));
    });
    
    return completer.future;
  }

  Image getImage(String name) {
    for(int i = 0; i < _frames.length; i++) {
      var frame = _frames[i];
      if (frame.name == name) {
        return new Image.fromTextureAtlasFrame(frame);
      }
    }
    throw new ArgumentError("TextureAtlasFrame not found: '$name'");
  }

  List<Image> getImages(String namePrefix) {
    var imageList = new List<Image>();
    for(int i = 0; i < _frames.length; i++) {
      var frame = _frames[i];
      if (frame.name.startsWith(namePrefix)) {
        imageList.add(new Image.fromTextureAtlasFrame(frame));
      }
    }
    return imageList;
  }

  List<String> get frameNames {
    return _frames.map((f) => f.name).toList(growable: false);
  }
}