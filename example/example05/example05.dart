import 'dart:html';
import '../../lib/compass.dart';


void main() {
  CanvasElement canvas = query('#container');
  
  Director.init(canvas);
  director.background = Color.parse(Color.Green);
  director.replace(new SimpleTest());
}

class SimpleTest extends Scene {
  Sprite sprite;
  final num speed = 10;
  
  enter() {
      sprite = new Sprite();
      sprite.fill = Color.parse(Color.Blue);
      sprite.x = 110.0;
      sprite.y = 20.0;
      sprite.width = 100.0;
      sprite.height = 100.0;
      addChild(sprite);
  }
  
  advanceTime(num time) {
    if(director.keyboard.isDown(KeyCode.LEFT)) {
      sprite.x -= speed;
    }else if(director.keyboard.isDown(KeyCode.RIGHT)) {
      sprite.x += speed;
    }
    if(director.keyboard.isDown(KeyCode.UP)) {
      sprite.y -= speed;
    }else if(director.keyboard.isDown(KeyCode.DOWN)) {
      sprite.y += speed;
    }
    if(director.keyboard.anyKeyDown)
      sprite.fill = Color.parse(Color.Red);
    else
      sprite.fill = Color.parse(Color.Blue);
  }
}




