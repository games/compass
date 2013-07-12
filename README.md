## Introduction

A 2D rendering engine that uses WebGL

## Features

* WebGL renderer 
* Super easy to use API 
* Support for texture atlases
* Asset loader / sprite sheet loade
* Mouse interaction


## Installing via Pub

[Using http://pub.dartlang.org/packages/compass](http://pub.dartlang.org/packages/compass)

	dependencies:
	  compass: any


### Usage ###

```dart

void main() {
  CanvasElement canvas = query('#container');
  
  Director.init(canvas);
  director.background = Color.parse(Color.Green);
  director.replace(new SimpleTest());
}

class SimpleTest extends Scene {
  enter() {
    var rng = new Random();
    for(var i = 0; i < 10000; i++) {
      var sprite = new Sprite();
      sprite.fill = Color.random();
      sprite.width = rng.nextDouble() * 50;
      sprite.height = rng.nextDouble() * 50;
      sprite.x = rng.nextDouble() * director.width;
      sprite.y = rng.nextDouble() * director.height;
      addChild(sprite);
    }
  }
}
    
```


### Thanks ###

* [Starling](http://gamua.com/starling/)
* [Cocos2d](http://cocos2d.org/)
* [Pixi.js](https://github.com/GoodBoyDigital/pixi.js/)
* [StageXL](http://www.stagexl.org/)


### About ###

* [Blog](http://valorzhong.blogspot.com/)
 
