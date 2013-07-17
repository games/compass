library compass;

import 'dart:html' as html;
import 'dart:json' as json;
import 'dart:web_gl' as webgl;
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:stats/stats.dart';


part 'src/geom/circle.dart';
part 'src/geom/point.dart';
part 'src/geom/rectangle.dart';
part 'src/geom/vector.dart';

part 'src/display/displayobject.dart';
part 'src/display/sprite.dart';
part 'src/display/layer.dart';
part 'src/display/scene.dart';

part 'src/fill/fill.dart';
part 'src/fill/color.dart';
part 'src/fill/image.dart';
part 'src/fill/text.dart';
part 'src/fill/textureatlas.dart';
part 'src/fill/textureatlasframe.dart';

part 'src/event/eventdispatcher.dart';
part 'src/event/events.dart';
part 'src/event/eventsubscription.dart';

part 'src/renderer/renderbatch.dart';
part 'src/renderer/renderer.dart';

part 'src/resource/resourcemanager.dart';
part 'src/resource/resource.dart';

part 'src/animation/animatable.dart';
part 'src/animation/juggler.dart';

part 'src/director.dart';
part 'src/dispose.dart';
part 'src/state.dart';
part 'src/interactionmanager.dart';
part 'src/keyboard.dart';


Director director;

const double PI2 = math.PI * 2;



const VERTEX_SHADER_COLOR =  """
attribute vec2 aVertexPosition;
attribute vec4 aColor;

varying vec4 vColor;

void main(void) {
    gl_Position = vec4(aVertexPosition, 1.0, 1.0);
    vColor = aColor;
}
""";

const FRAGMENT_SHADER_COLOR  = """
precision mediump float;

uniform sampler2D uSampler;

varying vec4 vColor;

void main(void) {
    gl_FragColor = vColor;
}
""";



const VERTEX_SHADER_TEXTURE =  """
attribute vec2 aVertexPosition;
attribute vec2 aTextureCoord;

varying vec2 vTextureCoord;

void main(void) {
    gl_Position = vec4(aVertexPosition, 1.0, 1.0);
    vTextureCoord = aTextureCoord;
}
""";

const FRAGMENT_SHADER_TEXTURE  = """
precision mediump float;

uniform sampler2D uSampler;

varying vec2 vTextureCoord;

void main(void) {
    gl_FragColor = texture2D(uSampler, vec2(vTextureCoord.s, vTextureCoord.t));
}
""";


String _replaceFilename(String url, String filename) {
  RegExp regex = new RegExp(r"^(.*/)?(?:$|(.+?)(?:(\.[^.]*$)|$))", multiLine:false, caseSensitive:false);
  Match match = regex.firstMatch(url);
  String path = match.group(1);
  return (path == null) ? filename : "$path$filename";
}

String _getFilenameWithoutExtension(String filename) {
  RegExp regex = new RegExp(r"(.+?)(\.[^.]*$|$)", multiLine:false, caseSensitive:false);
  Match match = regex.firstMatch(filename);
  return match.group(1);
}

bool _ensureBool(bool value) {
  if (value is bool) {
    return value;
  } else {
    throw new ArgumentError("The supplied value ($value) is not a bool.");
  }
}

int _ensureInt(int value) {
  if (value is int) {
    return value;
  } else {
    throw new ArgumentError("The supplied value ($value) is not an int.");
  }
}

num _ensureNum(num value) {
  if (value is num) {
    return value;
  } else {
    throw new ArgumentError("The supplied value ($value) is not a number.");
  }
}

String _ensureString(String value) {
  if (value is String) {
    return value;
  } else {
    throw new ArgumentError("The supplied value ($value) is not a string.");
  }
}


var callerStatsMap = new Map<String, CallerStats>();
class CallerStats {
  String name;
  int count = 0;
  int total = 0;
  Stopwatch watch;
  CallerStats(this.name) {
    if(callerStatsMap.containsKey(name)){
      callerStatsMap[name].count += 1;
    }else{
      callerStatsMap[name] = this;
    }
    watch = new Stopwatch();
    watch.start();
  }
  
  stop(){
    watch.stop();
    callerStatsMap[name].total += watch.elapsedMilliseconds;
  }
}







