import 'dart:html' as html;
import '../../lib/compass.dart';


void main() {
  html.CanvasElement canvas = html.query('#container');
  
  Director.init(canvas);
  director.background = Color.parse(Color.Green);
  director.replace(new SimpleTest());
}

class SimpleTest extends Scene {
  Sprite sprite;
  
  enter() {
    var bg = new Sprite();
    bg.fill = Color.parse(Color.Red);
    bg.x = 110.0;
    bg.y = 120.0;
//    bg.width = 100.0;
//    bg.height = 100.0;
    addChild(bg);

    var text = new Text("我是一个文本贴图 I am a text 1234u09887887800");
    sprite = new Sprite();
    sprite.fill = text;
    sprite.x = 110.0;
    sprite.y = 120.0;
//    sprite.width = text.width.toDouble();
//    sprite.height = text.height.toDouble();
    addChild(sprite);
    
    bg.width = text.width.toDouble();
    bg.height = text.height.toDouble();
  }
}




