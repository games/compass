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
    resources.addTextureAtlas("p3_walk", "p3_walk.json");
    resources.load().then((_) {
      addBird();
      addWalker();
    });
  }
  
  addWalker() {
    var atlas = resources.getTextureAtlas("p3_walk");
    var animate = new SpriteSheet(atlas.getImages("walk_"), 12);
    animate.x = 100.0;
    animate.y = 150.0;
    addChild(animate);
    director.juggler.add(animate);
  }
  
  addBird() {
    var atlas = resources.getTextureAtlas("atlas");
    var animate = new SpriteSheet(atlas.getImages("flight"), 12);
    animate.x = 300.0;
    animate.y = 150.0;
    addChild(animate);
    director.juggler.add(animate);
  }
}