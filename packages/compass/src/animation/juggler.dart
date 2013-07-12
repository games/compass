part of compass;


class Juggler implements Animatable {
  
  List<Animatable> _animatables = [];
  
  add(Animatable animatable) {
    if(!_animatables.contains(animatable)){
      _animatables.add(animatable);
    }
  }
  
  contains(Animatable animatable) {
    return _animatables.contains(animatable);
  }
  
  remove(Animatable animatable) {
    var i = _animatables.indexOf(animatable);
    if(i >= 0) _animatables[i] = null;
  }
  
  purge() {
    _animatables.fillRange(0, _animatables.length, null);
  }
  
  advanceTime(double time) {
    var numObjects = _animatables.length;
    var currentIndex = 0;
    
    if(numObjects == 0) return;
    var i = 0;
    for(; i < numObjects; i++){
      var animatable = _animatables[i];
      if(animatable != null){
        if(currentIndex != 0){
          _animatables[currentIndex] = animatable;
          _animatables[i] = null;
        }
        animatable.advanceTime(time);
        currentIndex++;
      }
    }
    if(currentIndex != i){
      numObjects = _animatables.length;
      while(i < numObjects)
        _animatables[currentIndex++] = _animatables[i++];
      _animatables.length = currentIndex;
    }
  }
}






