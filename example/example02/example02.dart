import 'dart:html';
import 'dart:math';
import '../../lib/compass.dart';


void main() {
  CanvasElement canvas = query('#container');
  
  Director.init(canvas, true);
  director.background = Color.parse(Color.Green);
  director.replace(new SimpleTest());
  
  document.body.children.add(director.stats.container);
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
      sprite.onMouseOver.listen((trigger, e) => trigger.fill = Color.parse(Color.Red));
      sprite.onMouseOut.listen((trigger, e) => trigger.fill = Color.random());
      addChild(sprite);
    }
  }
}