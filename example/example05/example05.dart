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
      sprite.y = 120.0;
      sprite.width = 100.0;
      sprite.height = 100.0;
      addChild(sprite);
      
      director.keyboard.define("rotate", [KeyCode.SHIFT, KeyCode.R]);
  }
  
  advanceTime(num time) {
    if(director.keyboard.pressed(KeyCode.LEFT)) {
      sprite.x -= speed;
    }else if(director.keyboard.pressed(KeyCode.RIGHT)) {
      sprite.x += speed;
    }
    if(director.keyboard.pressed(KeyCode.UP)) {
      sprite.y -= speed;
    }else if(director.keyboard.pressed(KeyCode.DOWN)) {
      sprite.y += speed;
    }
    
    if(director.keyboard.held(KeyCode.LEFT)) {
      sprite.fill = Color.parse(Color.Red);
    }else if(director.keyboard.held(KeyCode.RIGHT)) {
      sprite.fill = Color.parse(Color.Yellow);
    }else if(director.keyboard.held(KeyCode.UP)) {
      sprite.fill = Color.parse(Color.Green);
    }else if(director.keyboard.held(KeyCode.DOWN)) {
      sprite.fill = Color.parse(Color.BurlyWood);
    }else{
      sprite.fill = Color.parse(Color.Blue);
    }
    
    if(director.keyboard.heldByName("rotate")) {
      sprite.rotation += 1.0;
    }
  }
}




