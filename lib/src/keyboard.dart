part of compass;


class Keyboard {
  
  final Set<int> _keysState = new Set<int>();
  
  Keyboard() {
    html.window.onKeyDown.listen(_keyDownHandler);
    html.window.onKeyUp.listen(_keyUpHandler);
  }
  
  _keyDownHandler(e) => _keysState.add(e.keyCode);
  _keyUpHandler(e) => _keysState.remove(e.keyCode);
      
  bool isDown(keyCode) => _keysState.contains(keyCode);
  bool get anyKeyDown => _keysState.length > 0;
}