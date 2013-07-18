import 'dart:html';
import '../../lib/compass.dart';


void main() {
  CanvasElement canvas = query('#container');
  
  Director.init(canvas);
  director.background = Color.parse(Color.Green);
  director.replace(new SimpleTest());
}

class SimpleTest extends Scene {
  Layer layer;
  final num speed = 10;
  
  enter() {
      layer = new Layer();
      layer.x = 110.0;
      layer.y = 120.0;
      addChild(layer);
      
      var sprite = new Sprite();
      sprite.fill = Color.parse(Color.Black);
      sprite.x = 0.0;
      sprite.y = 0.0;
      sprite.width = 100.0;
      sprite.height = 100.0;
      layer.addChild(sprite);
      
      sprite = new Sprite();
      sprite.fill = Color.parse(Color.Blue);
      sprite.x = 0.0;
      sprite.y = 0.0;
      sprite.width = 50.0;
      sprite.height = 50.0;
      layer.addChild(sprite);
      
      sprite = new Sprite();
      sprite.fill = Color.parse(Color.Red);
      sprite.x = 50.0;
      sprite.y = 50.0;
      sprite.width = 50.0;
      sprite.height = 50.0;
      layer.addChild(sprite);
      
      director.keyboard.define("rotate", [KeyCode.SHIFT, KeyCode.R]);
  }
  
  advanceTime(num time) {
    if(director.keyboard.pressed(KeyCode.LEFT)) {
      layer.x -= speed;
    }else if(director.keyboard.pressed(KeyCode.RIGHT)) {
      layer.x += speed;
    }
    if(director.keyboard.pressed(KeyCode.UP)) {
      layer.y -= speed;
    }else if(director.keyboard.pressed(KeyCode.DOWN)) {
      layer.y += speed;
    }
    
    if(director.keyboard.held(KeyCode.LEFT)) {
      (layer.children[1] as Sprite).fill = Color.parse(Color.Red);
    }else if(director.keyboard.held(KeyCode.RIGHT)) {
      (layer.children[1] as Sprite).fill = Color.parse(Color.Yellow);
    }else if(director.keyboard.held(KeyCode.UP)) {
      (layer.children[1] as Sprite).fill = Color.parse(Color.Green);
    }else if(director.keyboard.held(KeyCode.DOWN)) {
      (layer.children[1] as Sprite).fill = Color.parse(Color.BurlyWood);
    }else{
      (layer.children[1] as Sprite).fill = Color.parse(Color.Blue);
    }
    
    if(director.keyboard.heldByName("rotate")) {
      layer.rotation += 1.0;
    }
  }
}




