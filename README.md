## Introduction

A 2D rendering engine that uses WebGL

## Features

* WebGL renderer 
* Super easy to use API 
* Support for texture atlases
* Asset loader / sprite sheet loade
* Mouse interaction


### Usage ###

```dart

    CanvasElement canvas = query('#container');
    Director.init(canvas);
    director.background = Color.parse(Color.Green);
    director.replace(new SimpleTest());
    
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
