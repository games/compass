import 'dart:html' as html;
import 'dart:math' as math;
import '../../lib/compass.dart';

ResourceManager resources;

void main() {
  html.CanvasElement canvas = html.query('#container');
  
  Director.init(canvas, true);
  director.background = Color.parse(Color.Green);
  director.replace(new SimpleTest());
  
  html.document.body.children.add(director.stats.container);
}

class SimpleTest extends Scene {
  final num Cell = 30.0, Speed = 5.0, JumpSpeed = 15.0;
  Layer _world;
  Hero _hero;
  List<Sprite> _platforms = [];
  
  enter() {
    resources = new ResourceManager();
    resources.addTextureAtlas("tiles", "tiles.json");
    resources.addTextureAtlas("p3_walk", "p3_walk.json");
    resources.load().then((_) {
      _initLevel();
    });
  }
  
  _initLevel() {
    var tiles = resources.getTextureAtlas("tiles");
    _world = new Layer();
    addChild(_world);
    for(var i = 0; i < level.length; i++) {
      var cell = level[i];
      _makeTile(cell, tiles, (i % 44).toInt() * Cell, (i / 44).toInt() * Cell);
    }
    _world.addChild(_hero.view);
//    var walker = resources.getTextureAtlas("p3_walk");
//    _hero.view = new SpriteSheet(walker.getImages("walk_"), 12);
    director.juggler.add(_hero.view);
  }
  
  _makeTile(cell, atlas, x, y) {
    if(cell > 0) {
      var sprite = new Sprite();
      if(cell == 1) {
        sprite.fill = atlas.getImage("grassMid");
        _platforms.add(sprite);
      } else if(cell == 99) {
        _hero = new Hero();
        var walker = resources.getTextureAtlas("p3_walk");
        _hero.view = sprite = new SpriteSheet(walker.getImages("walk_"), 12);
      } else if(cell == 2) {
        sprite.fill = Color.parse(Color.LightSlateGray);
      } else if(cell == 4) {
        sprite.fill = Color.parse(Color.Beige);
      } else if(cell == 5) {
        sprite.fill = Color.parse(Color.Chartreuse);
      } else if(cell == 6) {
        sprite.fill = Color.parse(Color.Cyan);
      } else if(cell == 7) {
        sprite.fill = Color.parse(Color.DarkTurquoise);
      } else if(cell == 8) {
        sprite.fill = Color.parse(Color.DarkOrchid);
      } else if(cell == 9) {
        sprite.fill = atlas.getImage("grassLeft");
        _platforms.add(sprite);
      } else if(cell == 10) {
        sprite.fill = atlas.getImage("grassRight");
        _platforms.add(sprite);
      }
      sprite.x = x;
      sprite.y = y;
      sprite.width = sprite.height = Cell;
      _world.addChild(sprite);
    }
  }
  
  advanceTime(num time) {
    if(_hero == null)
      return;
    
    if(director.keyboard.held(html.KeyCode.LEFT)) {
      _hero.x = -Speed;
    } else if(director.keyboard.held(html.KeyCode.RIGHT)) {
      _hero.x = Speed;
    } else {
      _hero.x = 0;
    }
    
    if(_hero.isJumping)
      _hero.y += 1;
    if(_hero.y > JumpSpeed) 
      _hero.y = JumpSpeed;
    
    if(_hero.y >= 0) {
      var pos = new Point(_hero.view.x + _hero.view.width / 2, _hero.view.y + _hero.view.height + _hero.y);
      var hit = _platforms.any((Sprite platform) {
        if(platform.hitTestPoint(pos) && _hero.view.y + _hero.view.height <= platform.y) {
          _hero.y = 0;
          _hero.view.y = platform.y - platform.height;
          _hero.isJumping = false; 
          return true;
        }
        return false;
      });
      if(!_hero.isJumping && !hit) {
        _hero.y = JumpSpeed;
        _hero.isJumping = true; 
      }
    }
    
    if(director.keyboard.pressed(html.KeyCode.UP)) {
      if(!_hero.isJumping) {
        _hero.y = -JumpSpeed;
        _hero.isJumping = true;
      }
    }
    
    _hero.update();
    
    _updateWorld();
  }
  
  _updateWorld() {
    _world.x = _hero.view.x - director.width / 2;
  }
}

class Hero {
  SpriteSheet view;
  num x = 0, y = 0;
  bool isJumping = false;
  
  update() {
    view.x += x;
    view.y += y;
  }
}









final List<int> level = [
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,1,1,1,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,6,7,7,7,7,7,5,7,7,7,7,6,0,0,0,0,0,0,7,7,7,7,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,9,1,1,1,1,1,1,1,1,10,0,0,0,0,0,0,0,9,1,1,1,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,4,7,7,7,99,7,7,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,7,7,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,9,1,1,1,1,1,1,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,1,1,1,10,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
  ];






