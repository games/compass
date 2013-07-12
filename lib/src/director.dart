part of compass;


class Director implements Dispose {
  int width, height;
  Color background;
  Juggler juggler;
  
  html.CanvasElement _canvas;
  Renderer _renderer;
  Scene _scene;
  InteractionManager _interactionManager;
  num _lastElapsed;
  
  static init(html.CanvasElement canvas) {
    if(director != null) 
      director.dispose();
    director = new Director._internal(canvas);
  }
  
  Director._internal(html.CanvasElement canvas) {
    juggler = new Juggler();
    width = canvas.width;
    height = canvas.height;
    background = Color.parse(Color.White);
    _canvas = canvas;
    _lastElapsed = 0;
    _renderer = new WebGLRenderer(canvas);
    _interactionManager = new InteractionManager(canvas);
    _scene = new Scene();
   
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
    final interval = elapsed - _lastElapsed;
    _lastElapsed = elapsed;
    
    _scene.advanceTime(interval);
    juggler.advanceTime(interval);
    
    _renderer.nextFrame();
    _scene.render(_renderer);
    _renderer.finishBatch();
    
    _run();
  }

  dispose() {
    // TODO implement this method
  }
  
  get scene => _scene;
}