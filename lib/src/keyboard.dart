part of compass;


class Keyboard implements Animatable {
  
  Set<int> _keysState = new Set<int>();
  Map<String, List<int>> _control = new Map();
  List<int> _pressKeys = [];
  List<int> _releaseKeys = [];

  Keyboard() {
    html.window.onKeyDown.listen(_keyDownHandler);
    html.window.onKeyUp.listen(_keyUpHandler);
  }
  
  _keyDownHandler(e) {
    if(!_keysState.contains(e.keyCode)) {
      _keysState.add(e.keyCode);
      _pressKeys.add(e.keyCode);
    }
  }
  
  _keyUpHandler(e) {
    if(_keysState.contains(e.keyCode)) {
      _keysState.remove(e.keyCode);
      _releaseKeys.add(e.keyCode);
    }
  }
  
  define(name, keys) => _control[name] = keys;

  advanceTime(double time) {
    _pressKeys.clear();
    _releaseKeys.clear();
  }
  
  bool pressed(key) => _pressKeys.contains(key);
  
  bool pressedByName(name) {
    if(!_control.containsKey(name))
      return false;
    return _control[name].any((k) => _pressKeys.contains(k));
  }
  
  bool released(key) => _releaseKeys.contains(key);
  
  bool releasedByName(name) {
    if(!_control.containsKey(name))
      return false;
    return _control[name].any((k) => _releaseKeys.contains(k));
  }
  
  bool heldByName(name) {
    if(!_control.containsKey(name))
      return false;
    return _control[name].any((k) => _keysState.contains(k));
  }
  
  bool held(key) => _keysState.contains(key);
  
  void clear() {
    _pressKeys.clear();
    _releaseKeys.clear();
    _keysState.clear();
  }
  
  bool get anyKeyDown => _keysState.length > 0;
}












