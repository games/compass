import 'dart:html';
import '../../lib/compass.dart';


void main() {
  CanvasElement canvas = query('#container');
  
  Director.init(canvas);
  director.background = Color.parse(Color.Green);
  director.replace(new SimpleTest());
}

class SimpleTest extends Scene {
  enter() {
    for(var i = 0; i < 5; i++) {
      var sprite = new Sprite();
      sprite.fill = Color.random();
      sprite.x = 110.0 * i + 10;
      sprite.y = 20.0;
      sprite.width = 100.0;
      sprite.height = 100.0;
      sprite.onMouseOver.listen((trigger, e) => trigger.fill = Color.parse(Color.Red));
      sprite.onMouseMove.listen((trigger, e) => print(["move", e.localX, e.localY, e.worldX, e.worldY]));
      sprite.onMouseOut.listen((trigger, e) => trigger.fill = Color.random());
      sprite.onMouseDown.listen((trigger, e) => print(["down", e.localX, e.localY, e.worldX, e.worldY]));
      sprite.onMouseUp.listen((trigger, e) => print(["up", e.localX, e.localY, e.worldX, e.worldY]));
      sprite.onMouseUpOut.listen((trigger, e) => print(["up out", e.localX, e.localY, e.worldX, e.worldY]));
      sprite.onClick.listen((trigger, e) {
        trigger.visible = !trigger.visible;
      });
      addChild(sprite);
      
      if(i == 4) {
        sprite.pivotX = 0.5;
        sprite.pivotY = 0.5;
      }
    }
  }
}