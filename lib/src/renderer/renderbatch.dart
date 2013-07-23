part of compass;


class RenderBatch implements Dispose {
  
  int _numSprites;
  Fill _fill;
  Matrix3 _modelViewMatrix;
  webgl.Buffer vertexBuffer, indexBuffer, uvBuffer, colorBuffer;
  webgl.Buffer translationBuffer, rotationBuffer, scaleBuffer;
  Float32List verticies, uvs, colors;
  Float32List translations, rotations, scales;
  Uint16List indices;
  WebGLRenderer renderer;
  bool dirty;
  List<Sprite> _sprites;
  
  RenderBatch(this.renderer) {
    _numSprites = 0;
    verticies = new Float32List(0);
    uvs = new Float32List(0);
    colors = new Float32List(0);
    indices = new Uint16List(0);
    dirty = false;
    
    _sprites = [];
    
    var gl = renderer.gl;
    vertexBuffer = gl.createBuffer();
    uvBuffer = gl.createBuffer();
    colorBuffer = gl.createBuffer();
    indexBuffer = gl.createBuffer();
    
    translationBuffer = gl.createBuffer();
    rotationBuffer = gl.createBuffer();
    scaleBuffer = gl.createBuffer();
  }
  
  reset() {
    _numSprites = 0;
    _sprites.clear();
    _fill = null;
  }
  
  dispose() {
    // TODO implement this method
  }
  
  isStateChanged(Sprite sprite) {
    if(_numSprites == 0) return false;
    if(_numSprites + 1 > 8192) return true;
    if(_fill == null) return false;
    if(_fill is Color && sprite.fill is Color) return false;
    return !_fill.equals(sprite.fill);
  }
  
  add(Sprite sprite) {
    if(sprite.fill == null) return;
    if(_numSprites == 0) _fill = sprite.fill;
    _sprites.add(sprite);
    _numSprites++;
    dirty = true;
  }
  
  refresh() {
    if(_numSprites != verticies.length / 8){
      print("grow");
      growBuffer();
    }
    
    for(var i = 0; i < _numSprites; i++) {
      var sprite = _sprites[i];
      var index = i * 8;
      _replaceRange(index, 8, _positionBuffer(sprite), verticies);
      _replaceRange(index, 8, _translationBuffer(sprite), translations);
      _replaceRange(index, 8, _rotationBuffer(sprite), rotations);
      _replaceRange(index, 8, _scaleBuffer(sprite), scales);
      if(_fill is Color)
        _replaceRange(i * 16, 16, _colorBuffer(sprite), colors);
      else
        sprite.fill.updateBuffer(index, uvs);
    }
  }
  
  _positionBuffer(sprite) {
    var x1 = sprite.x;
    var x2 = sprite.x + sprite.width;
    var y1 = sprite.y;
    var y2 = sprite.y + sprite.height;
    return [x1, y2, x2, y2, x2, y1, x1, y1];
  }
  
  _translationBuffer(sprite) {
    return [sprite.x, sprite.y, sprite.x, sprite.y, sprite.x, sprite.y, sprite.x, sprite.y, sprite.x, sprite.y, sprite.x, sprite.y];
  }
  
  _rotationBuffer(sprite) {
    var radians = sprite.rotation * math.PI / 180;
    var sn = math.sin(radians);
    var cs = math.cos(radians);
    return [sn, cs, sn, cs, sn, cs, sn, cs, sn, cs, sn, cs];
  }
  
  _scaleBuffer(sprite) {
    return [sprite.scaleX, sprite.scaleY, 
            sprite.scaleX, sprite.scaleY, 
            sprite.scaleX, sprite.scaleY, 
            sprite.scaleX, sprite.scaleY, 
            sprite.scaleX, sprite.scaleY, 
            sprite.scaleX, sprite.scaleY];
  }
  
  _colorBuffer(sprite) {
    var red = sprite.fill.red / 256;
    var green = sprite.fill.green / 256;
    var blue = sprite.fill.blue / 256;
    var alpha = sprite.fill.alpha;
    var result = new List<double>(16);
    for(var i = 0; i < 16; i += 4) {
      result[i] = red;
      result[i + 1] = green;
      result[i + 2] = blue;
      result[i + 3] = alpha;
    }
    return result;
  }
  
  _replaceRange(start, length, source, target) {
    for(var i = start, j = 0; j < length; i++, j++) {
      target[i] = source[j];
    }
  }
  
  growBuffer() {
    final webgl.RenderingContext gl = renderer.gl;
    verticies = new Float32List(_numSprites * 8);
    gl.bindBuffer(webgl.ARRAY_BUFFER, vertexBuffer);
    gl.bufferDataTyped(webgl.ARRAY_BUFFER, verticies, webgl.DYNAMIC_DRAW);
    
    translations = new Float32List(_numSprites * 8);
    gl.bindBuffer(webgl.ARRAY_BUFFER, translationBuffer);
    gl.bufferDataTyped(webgl.ARRAY_BUFFER, translations, webgl.DYNAMIC_DRAW);
    
    rotations = new Float32List(_numSprites * 8);
    gl.bindBuffer(webgl.ARRAY_BUFFER, rotationBuffer);
    gl.bufferDataTyped(webgl.ARRAY_BUFFER, rotations, webgl.DYNAMIC_DRAW);

    scales = new Float32List(_numSprites * 8);
    gl.bindBuffer(webgl.ARRAY_BUFFER, scaleBuffer);
    gl.bufferDataTyped(webgl.ARRAY_BUFFER, scales, webgl.DYNAMIC_DRAW);
    
    if(_fill is Color){
      colors = new Float32List(_numSprites * 16);
      gl.bindBuffer(webgl.ARRAY_BUFFER, colorBuffer);
      gl.bufferDataTyped(webgl.ARRAY_BUFFER, colors, webgl.DYNAMIC_DRAW);
    }else {
      uvs  = new Float32List(_numSprites * 8);
      gl.bindBuffer(webgl.ARRAY_BUFFER, uvBuffer);
      gl.bufferDataTyped(webgl.ARRAY_BUFFER, uvs, webgl.DYNAMIC_DRAW);
    }
    
    indices = new Uint16List(_numSprites * 6); 
    for (var i = 0; i < _numSprites; i++){
      var index2 = i * 6;
      var index3 = i * 4;
      indices[index2 + 0] = index3 + 0;
      indices[index2 + 1] = index3 + 1;
      indices[index2 + 2] = index3 + 2;
      indices[index2 + 3] = index3 + 0;
      indices[index2 + 4] = index3 + 2;
      indices[index2 + 5] = index3 + 3;
    };
    gl.bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.bufferDataTyped(webgl.ELEMENT_ARRAY_BUFFER, indices, webgl.STATIC_DRAW);
  }
  
  render() {
    if(_numSprites == 0) return;

    if(dirty){
      dirty = false;
      refresh();
    }
    
    webgl.RenderingContext gl = renderer.gl;
    gl.blendFunc(webgl.ONE, webgl.ONE_MINUS_SRC_ALPHA);
    
    ShaderProgram program;
    if(_fill is Color){
      program = renderer.getShaderProgram("color");
      gl.useProgram(program.program);
      gl.bindBuffer(webgl.ARRAY_BUFFER, colorBuffer);
      gl.bufferSubDataTyped(webgl.ARRAY_BUFFER, 0, colors);
      gl.vertexAttribPointer(program.colorAttribute, 4, webgl.FLOAT, false, 0, 0);
    } else {
      program = renderer.getShaderProgram("texture");
      gl.useProgram(program.program);
      gl.bindBuffer(webgl.ARRAY_BUFFER, uvBuffer);
      gl.bufferSubDataTyped(webgl.ARRAY_BUFFER, 0, uvs);
      gl.vertexAttribPointer(program.textureCoordAttribute, 2, webgl.FLOAT, false, 0, 0);
      gl.activeTexture(webgl.TEXTURE0);
      gl.bindTexture(webgl.TEXTURE_2D, _fill.findTexture(renderer));
      gl.uniform1i(program.samplerUniform, 0);
    }
    
    gl.bindBuffer(webgl.ARRAY_BUFFER, translationBuffer);
    gl.bufferSubDataTyped(webgl.ARRAY_BUFFER, 0, translations);
    gl.vertexAttribPointer(program.translationAttri, 2, webgl.FLOAT, false, 0, 0);
 
    gl.bindBuffer(webgl.ARRAY_BUFFER, rotationBuffer);
    gl.bufferSubDataTyped(webgl.ARRAY_BUFFER, 0, rotations);
    gl.vertexAttribPointer(program.rotationAttri, 2, webgl.FLOAT, false, 0, 0);
 
    gl.bindBuffer(webgl.ARRAY_BUFFER, scaleBuffer);
    gl.bufferSubDataTyped(webgl.ARRAY_BUFFER, 0, scales);
    gl.vertexAttribPointer(program.scaleAttri, 2, webgl.FLOAT, false, 0, 0);
    
    gl.uniform2f(program.resolutionUniform, director.width, director.height);
    
    gl.bindBuffer(webgl.ARRAY_BUFFER, vertexBuffer);
    gl.bufferSubDataTyped(webgl.ARRAY_BUFFER, 0, verticies);
    gl.vertexAttribPointer(program.positionAttribute, 2, webgl.FLOAT, false, 0, 0);
    
    gl.bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.drawElements(webgl.TRIANGLES, _numSprites * 6, webgl.UNSIGNED_SHORT, 0);
  }
}








