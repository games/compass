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
  ResourceManager resources;
  
  enter() {
    resources = new ResourceManager();
    resources.addTextureAtlas("atlas", "atlas.json");
    resources.load().then((_) {
      addBird();
    });
  }
  
  addBird() {
    var atlas = resources.getTextureAtlas("atlas");
    var rng = new Random();
    var animate = new SpriteSheet(atlas.getImages("flight"), 12);
    animate.x = 300.0;
    animate.y = 150.0;
    addChild(animate);
    director.juggler.add(animate);
  }
}