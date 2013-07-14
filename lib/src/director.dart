part of compass;


class Director implements Dispose {
  int width, height;
  Color background;
  Juggler juggler;
  
  html.CanvasElement _canvas;
  Renderer _renderer;
  Scene _scene;
  InteractionManager _interactionManager;
  Keyboard _keyboard;
  num _lastElapsed;
  Stats _stats;
  
  static init(html.CanvasElement canvas, [bool debug = false]) {
    if(director != null) 
      director.dispose();
    director = new Director._internal(canvas, debug);
  }
  
  Director._internal(html.CanvasElement canvas, bool debug) {
    juggler = new Juggler();
    width = canvas.width;
    height = canvas.height;
    background = Color.parse(Color.White);
    _canvas = canvas;
    _lastElapsed = 0;
    _renderer = new WebGLRenderer(canvas);
    _interactionManager = new InteractionManager(canvas);
    _keyboard = new Keyboard();
    _scene = new Scene();
    if(debug) 
      _stats = new Stats();
    _run();
  }
  
  replace(Scene scene) {
    if(_scene != null){
      _scene.exit();
    }
    scene.enter();
    _scene = scene;
  }
  
  _run() {
    html.window.requestAnimationFrame(_animate);
  }
  
  _animate(num elapsed) {
    if(_stats != null) 
      _stats.begin();
    
    final interval = elapsed - _lastElapsed;
    _lastElapsed = elapsed;
    
    _scene.advanceTime(interval);
    juggler.advanceTime(interval);
    
    _renderer.nextFrame();
    _scene.render(_renderer);
    _renderer.finishBatch();
    
    if(_stats != null) 
      _stats.end();
    
    _run();
  }

  dispose() {
    // TODO implement this method
  }
  
  get keyboard => _keyboard;
  get scene => _scene;
  get stats => _stats;
}