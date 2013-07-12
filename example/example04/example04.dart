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
  num speed = 200;
  
  enter() {
    resources = new ResourceManager();
    resources.addImage("bunny", "bunny.png");
    resources.load().then((_) {
      newChild(10000, true, resources.getImage("bunny"));
    });
  }
  
  advanceTime(num interval) {
    children.forEach((DisplayObject child) {
      move(interval / 1000, child);
      rotate(interval / 1000, child);
    });
  }
  
  rotate(num s, DisplayObject child) {
    child.rotation += 0.1;
  }
  
  move(num s, child) {
    var dx = s * child.sx;
    var dy = s * child.sy;
    if(child.x + child.width + dx > director.width.toDouble()){ 
      child.sx = -speed;
      child.x = director.width.toDouble() - child.width;
    }else if(child.x + dx < 0){
      child.sx = speed;
      child.x = 0.0;
    }else{
      child.x += dx;
    }
    if(child.y + child.height + dy > director.height.toDouble()){ 
      child.sy = -speed;
      child.y = director.height.toDouble() - child.height;
    }else if(child.y + dy < 0){
      child.sy = speed;
      child.y = 0.0;
    }else{
      child.y += dy;
    }
  }
  
  newChild(int count, bool useImage, [Image image]) {
    var rng = new Random();
    for(var i = 0; i < count; i++){
        var sprite = new Bunny();
        if(useImage){
          sprite.fill = image;
          sprite.width = 26.0;
          sprite.height = 37.0;
        }else {
          sprite.fill = new Color(rng.nextInt(256), rng.nextInt(256), rng.nextInt(256));
          sprite.width = rng.nextDouble() * 50;
          sprite.height = rng.nextDouble() * 50;
        }
        sprite.x = rng.nextDouble() * director.width;
        sprite.y = rng.nextDouble() * director.height;
        sprite.pivotX = 0.5;
        sprite.pivotY = 1.0;
        sprite.sx = sprite.sy = rng.nextDouble() * speed;
        addChild(sprite);
    }
  }
}

class Bunny extends Sprite {
  num sx, sy;
}