import 'dart:html' as html;
import 'dart:math' as math;
import '../../lib/compass.dart';

ResourceManager resources;

void main() {
  html.CanvasElement canvas = html.query('#container');
  
  Director.init(canvas, true);
  director.background = Color.parse(Color.White);
  
  resources = new ResourceManager();
  resources.addTextureAtlas("tiles", "tiles.json");
  resources.addTextureAtlas("p3_walk", "p3_walk.json");
  resources.load().then((_) {
    director.replace(new SimpleTest());
  });
  
  
  html.document.body.children.add(director.stats.container);
}



class SimpleTest extends Scene {
  final Cell = 70.0;
  List maps;
  int currentMap = 0;
  Layer mapLayer;
  Hero hero;
  var mapW, mapH;
  Map keys;
  
  enter() {
    maps = [];
    maps.add([
              [0,0,0,0,0,0,0,0],
              [0,101,101,104,101,0,101,0],
              [0,105,0,104,103,0,101,0],
              [0,1,103,103,106,103,0,0],
              [0,104,0,104,0,0,101,102],
              [103,103,103,103,103,103,103,103]
              ]);
    maps.add([
              [0,0,0,0,0,0,0,0],
              [0,101,101,105,101,101,101,0],
              [0,101,103,104,105,101,105,0],
              [0,101,101,0,1,0,104,0],
              [102,101,101,101,104,101,104,0],
              [0,0,0,0,0,0,0,0]
              ]);
    buildMap();
    
    keys = new Map();
    keys[html.KeyCode.UP] = {'down':false, 'dirx':0, 'diry':-1, 'sprNum':1};
    keys[html.KeyCode.DOWN] = {'down':false, 'dirx':0, 'diry':1, 'sprNum':1};
    keys[html.KeyCode.LEFT] = {'down':false, 'dirx':-1, 'diry':0, 'sprNum':3};
    keys[html.KeyCode.RIGHT] = {'down':false, 'dirx':1, 'diry':0, 'sprNum':2};
    
    hero = new Hero(0, 24, 2, 1);
    hero.speed = 3;
    hero.jumpStart = -12;
    hero.gravity = 1;
    hero.view = new Sprite();
    hero.view.fill = Color.parse(Color.Red);
    hero.view.width = 24.0;
    hero.view.height = 24.0;
    moveObject(hero);
    mapLayer.addChild(hero.view);
  }
  
  advanceTime(num elapse) {
    keys.keys.any((key) {
      var obj = keys[key];
      if(director.keyboard.held(key) && obj['dirx'] != 0) {
        if(getMyCorners(hero.x, hero.y, hero) == true) {
          if(getMyCorners(hero.x + obj['dirx'] * hero.speed, hero.y, hero) == false) {
            if(obj['dirx'] < 0) {
              hero.x = hero.xtile * Cell;
            }else{
              hero.xtile = ((hero.x + hero.speed) / Cell).toInt();
              hero.x = (hero.xtile + 1) * Cell - hero.ts;
            }
            moveObject(hero, {'dirx': 0, 'diry': 0, 'sprNum': obj.sprNum});
          }else{
            hero.onLadder = false;
            moveObject(hero, obj);
          }
        }
        return true;
      }
      return false;     
    });
    
  }
  
  moveObject(Hero hero, [Map<String, dynamic> moveOb, speed]) {
    var s = hero.speed;
    if(speed != null) s = speed;
    if(moveOb != null) {
      hero.x = moveOb['dirx'] * s;
      hero.y = moveOb['diry'] * s;
      hero.sprNum = moveOb['sprNum'];
    }else{
      hero.x = hero.xtile * Cell + (Cell - hero.ts) / 2;
      hero.y = (hero.ytile + 1) * Cell - hero.ts;
    }
    hero.xtile = (hero.x / Cell).toInt();
    hero.ytile = (hero.y / Cell).toInt();
    hero.ytc = ((hero.y + hero.ts / 2) / Cell).toInt();
    hero.xtc = ((hero.x + hero.ts / 2) / Cell).toInt();
    
    hero.view.x = hero.x.toDouble();
    hero.view.y = hero.y.toDouble();
  }
  
  getMyCorners(x, y, Hero hero) {
    var upY = (y / Cell).toInt();
    var downY = ((y + hero.ts - 1) / Cell).toInt();
    var leftX = (x / Cell).toInt();
    var rightX = ((x + hero.ts - 1) / Cell).toInt();
    if(upY < 0 || downY >= mapH || leftX < 0 || rightX >= mapW) {
      return false;
    }
    var ul = isWalkable(leftX, upY);
    var dl = isWalkable(leftX, downY);
    var ur = isWalkable(rightX, upY);
    var dr = isWalkable(rightX, downY);
    if(y > hero.y) {
      if(isCloud(leftX, downY) || isCloud(rightX, downY)) {
        return false;
      }
    }
    return ul && dl && ur && dr;
  }
  
  isCloud(xt, yt) {
    return maps[currentMap][yt][xt] == 103;
  }
  
  isWalkable(xt, yt) {
    if(maps[currentMap][yt][xt] >= 100) {
      return true;
    }
    return false;
  }
  
  buildMap() {
    var map = maps[currentMap];
    mapW = map[0].length;
    mapH = map.length;
    mapLayer = new Layer();
    addChild(mapLayer);
    
    var tiles = resources.getTextureAtlas("tiles");
    
    for(var yt = 0; yt < mapH; yt++) {
      for(var xt = 0; xt < mapW; xt++) {
        var s = map[yt][xt];
        createTile(s, tiles, xt, yt);
      }
    }
  }
  
  createTile(int cell, atlas, int xt, int yt) {
    if(cell > 0) {
      var sprite = new Sprite();
      if(cell == 102) {
        sprite.fill = atlas.getImage("signExit");
      } else if(cell == 103) {
        sprite.fill = atlas.getImage("grassMid");
      } else if(cell == 104) {
        sprite.fill = atlas.getImage("ladder_mid");
      } else if(cell == 105) {
        sprite.fill = atlas.getImage("ladder_top");
      } else if(cell == 106) {
        sprite.fill = atlas.getImage("grassCenter");
      } else if(cell == 1) {
        sprite.fill = atlas.getImage("ladder_mid");
        var bg = new Sprite();
        bg.fill = atlas.getImage("grassMid");
        bg.x = xt * Cell;
        bg.y = yt * Cell;
        bg.width = bg.height = Cell;
        mapLayer.addChild(bg);
      } else {
        sprite.fill = Color.parse(Color.White);
      }
      sprite.x = xt * Cell;
      sprite.y = yt * Cell;
      sprite.width = sprite.height = Cell;
      mapLayer.addChild(sprite);
    }
  }
}


class Hero {
  var view; 
  var sprNum, ts, xtile, ytile, x, y, dist, speed = 0.0, mapy, mapx, jumSpeed, jumpStart, gravity, onLadder, xtc, ytc;
  
  Hero(this.sprNum, this.ts, this.xtile, this.ytile) {
    dist = 0;
    onLadder = false;
  }
}

















