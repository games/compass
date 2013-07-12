part of compass;

class Sprite extends InteractiveObject {
  Fill _fill;
  
  Sprite() {
  }
  
  get fill => _fill;
  set fill(Fill val) {
    _fill = val;
    if(val is Image) {
      _handleImage(val);
    }
  }
  
  _handleImage(Image image) {
//    if(_width == 0.0 && _height == 0.0){
      _width = image.frameWidth.toDouble();
      _height = image.frameHeight.toDouble();
//    }
  }
  
  render(Renderer renderer) {
    renderer.render(this);
  }
}

class SpriteSheet extends Sprite implements Animatable {
  List<Image> _images;
  List<double> _durations;
  List<double> _startTimes;
  double _defaultDuration;
  double _currentTime;
  int _currentFrame;
  bool _playing;
  
  bool loop;
  EventDispatcher onCompleted;
  
  SpriteSheet(this._images, [int fps = 12]) {
    onCompleted = new EventDispatcher(this);
    fill = _images[0];
    var len = _images.length;
    _defaultDuration = 1.0 / fps * 1000;
    loop = true;
    _playing = true;
    _currentTime = 0.0;
    _currentFrame = 0;
    _durations = new List.filled(len, _defaultDuration);
    _startTimes = new List.generate(len, (i) => _defaultDuration * i);
  }
  
  play() => _playing = true;
  pause() => _playing = false;
  stop() {
    _playing = false;
    _currentFrame = 0;
  }

  advanceTime(double passedTime) {
    if(!_playing || passedTime <= 0.0) return;

    var finalFrame;
    var previousFrame = _currentFrame;
    var restTime = 0.0;
    var breakAfterFrame = false;
    var dispatchCompleteEvent = false;
    var total = totalTime;
    if(loop && _currentTime >= total){
      _currentTime = 0.0;
      _currentFrame = 0;
    }
    if(_currentTime < total){
      _currentTime += passedTime;
      finalFrame = _images.length - 1;
      while(_currentTime > _startTimes[_currentFrame] + _durations[_currentFrame]){
        if(_currentFrame == finalFrame){
          restTime = _currentTime - total;
          _currentFrame = finalFrame;
          _currentTime = total;
          dispatchCompleteEvent = true;
          break;
        }else{
          _currentFrame++;
        }
      }
      if(_currentFrame == finalFrame && _currentTime == total)
        dispatchCompleteEvent = true;
    }
    if(_currentFrame != previousFrame)
      fill = _images[_currentFrame];
    if(dispatchCompleteEvent)
      onCompleted.dispatch();
    if(loop && restTime > 0.0)
      advanceTime(restTime);
  }
  
  updateStartTimes() {
    var frames = numFrames;
    _startTimes.clear();
    _startTimes[0] = 0.0;
    for(var i = 1; i < frames; i++)
      _startTimes[i] = _startTimes[i - 1] + _durations[i - 1];
  }
  
  get totalTime => _startTimes[_images.length - 1] + _durations[_images.length - 1];
  get isComplete => !loop && _currentTime >= totalTime;
  get numFrames => _images.length;
  get currentFrame => _currentFrame;
  set currentFrame(val) {
    _currentFrame = val;
    _currentTime = 0.0;
    for(var i = 0; i < val; i++)
      _currentTime += _durations[i];
    fill = _images[_currentFrame];
  }
  get fps => 1.0 / _defaultDuration;
  set fps(val) {
    if(val <= 0) throw 'Invalid fps: $val';
    var newDuration = 1.0 / val;
    var acceleration = newDuration / _defaultDuration;
    _currentTime = acceleration;
    _defaultDuration = newDuration;
    _durations.map((d) => d * acceleration);
    updateStartTimes();
  }
  get isPlaying {
    if(_playing)
      return loop || _currentTime < totalTime;
    else 
      return false;
  }
}













