part of compass;

class ResourceManager {

  final Map<String, Resource> _resources = new Map<String, Resource>();
  
  EventDispatcher onProgress;
  
  ResourceManager() {
    onProgress = new EventDispatcher(this);
  }

  _addResource(String kind, String name, String url, Future loader) {
    var key = "$kind.$name";
    if (_resources.containsKey(key)) {
      throw new StateError("ResourceManager already contains a resource called '$name'");
    }
    var resource = new Resource(kind, name, url, loader);
    resource.complete.then((_) {
      onProgress.dispatch();
    });
    _resources[key] = resource;
  }

  dynamic _getResource(String kind, String name) {
    var key = "$kind.$name";
    if (_resources.containsKey(key) == false) {
      throw new StateError("ResourceManager does not contains a resource called '$name'");
    }
    return _resources[key];
  }

  Future<ResourceManager> load() {
    var futures = this.pendingResources.map((r) => r.complete);
    return Future.wait(futures).then((value) {
      var errors = this.failedResources.length;
      if (errors > 0) {
        throw new StateError("Failed to load $errors resource(s).");
      } else {
        return this;
      }
    });
  }

  List<Resource> get finishedResources {
    return _resources.values.where((r) => r.resource != null).toList();
  }

  List<Resource> get pendingResources {
    return _resources.values.where((r) => r.resource == null && r.error == null).toList();
  }

  List<Resource> get failedResources {
    return _resources.values.where((r) => r.error != null).toList();
  }

  List<Resource> get resources {
    return _resources.values.toList();
  }

  void addImage(String name, String url) {
    _addResource("Image", name, url, Image.load(url));
  }

  void addTextureAtlas(String name, String url) {
    _addResource("TextureAtlas", name, url, TextureAtlas.load(url));
  }

  void addText(String name, String text) {
    _addResource("Text", name, "", new Future.value(text));
  }

  Image getImage(String name) {
    var value = _getResource("Image", name).resource;
    if (value is! Image) throw "dart2js_hint";
    return value;
  }

  TextureAtlas getTextureAtlas(String name) {
    var value = _getResource("TextureAtlas", name).resource;
    if (value is! TextureAtlas) throw "dart2js_hint";
    return value;
  }

  String getText(String name) {
    var value = _getResource("Text", name).resource;
    if (value is! String) throw "dart2js_hint";
    return value;
  }

}
