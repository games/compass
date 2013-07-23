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
  MyAnimate bird, walker, darksaber;
  
  
  enter() {
    resources = new ResourceManager();
    resources.addTextureAtlas("atlas", "atlas.json");
    resources.addTextureAtlas("p3_walk", "p3_walk.json");
    resources.addTextureAtlas("darksaber_run", "darksaber_run.json");
    resources.load().then((_) {
      addDarksaber();
//      addBird();
//      addWalker();
    });
  }
  
  addDarksaber() {
    var atlas = resources.getTextureAtlas("darksaber_run");
    darksaber = new MyAnimate(atlas.getImages("darksaber_run"));
    darksaber.x = 0.0;
    darksaber.y = 0.0;
    darksaber.scaleX = darksaber.scaleY = 0.3;
    addChild(darksaber);
  }
  
  addWalker() {
    var atlas = resources.getTextureAtlas("p3_walk");
    walker = new MyAnimate(atlas.getImages("walk_"));
    walker.x = 100.0;
    walker.y = 300.0;
    addChild(walker);
  }
  
  addBird() {
    var atlas = resources.getTextureAtlas("atlas");
    bird = new MyAnimate(atlas.getImages("flight"));
    bird.x = 500.0;
    bird.y = 300.0;
    addChild(bird);
  }
  
  advanceTime(num time) {
    if(darksaber != null)
      darksaber.update();
    if(walker != null)
      walker.update();
    if(bird != null) 
      bird.update();
    
    if(director.keyboard.pressed(KeyCode.UP)){
      if(darksaber != null){
        darksaber.scaleX += 0.1;
        darksaber.scaleY += 0.1;
      }
    }
    if(director.keyboard.pressed(KeyCode.DOWN)){
      if(darksaber != null){
        darksaber.scaleX -= 0.1;
        darksaber.scaleY -= 0.1;
      }
    }
  }
}


class MyAnimate extends Layer {
  Sprite bg;
  SpriteSheet animate;
  
  MyAnimate(images) {
    bg = new Sprite();
    bg.fill = Color.random();
    addChild(bg);
    
    animate = new SpriteSheet(images);
    addChild(animate);
    director.juggler.add(animate);
  }
  
  update(){
    bg.x = animate.x;
    bg.y = animate.y;
    bg.width = animate.width;
    bg.height = animate.height;
  }
}





