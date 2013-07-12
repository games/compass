part of compass;


class RenderBatch implements Dispose {
  
  int _numSprites;
  Fill _fill;
  Matrix3 _modelViewMatrix;
  webgl.Buffer vertexBuffer, indexBuffer, uvBuffer, colorBuffer;
  Float32List verticies, uvs, colors;
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
    
    for(var i = 0; i < _numSprites; i++){
      updateBuffer(i, _sprites[i]);
    }
  }
  
  updateBuffer(int no, Sprite sprite) {
    var worldTransform, width, height, aX, aY, w0, w1, h0, h1, index, index2, index3;
    var a, b, c, d, tx, ty;
    
    index = no * 8;
    
    width = sprite.width;
    height = sprite.height;
    
    aX = sprite.pivotX;
    aY = sprite.pivotY;
    w0 = width * (1 - aX);
    w1 = width * -aX;
    
    h0 = height * (1 - aY);
    h1 = height * -aY;
    
    worldTransform = sprite.worldTransform;
    
    a = worldTransform[0];
    b = worldTransform[3];
    c = worldTransform[1];
    d = worldTransform[4];
    tx = worldTransform[2];
    ty = worldTransform[5];
    
    verticies[index + 0 ] = (a * w1 + c * h1 + tx) * 2 / director.width - 1.0; 
    verticies[index + 1 ] = -(d * h1 + b * w1 + ty) * 2 / director.height + 1;
    
    verticies[index + 2 ] = (a * w0 + c * h1 + tx) * 2 / director.width - 1.0; 
    verticies[index + 3 ] = -(d * h1 + b * w0 + ty) * 2 / director.height + 1.0; 
    
    verticies[index + 4 ] = (a * w0 + c * h0 + tx) * 2 / director.width - 1.0; 
    verticies[index + 5 ] = -(d * h0 + b * w0 + ty) * 2 / director.height + 1.0; 
    
    verticies[index + 6] =  (a * w1 + c * h0 + tx) * 2 / director.width - 1.0; 
    verticies[index + 7] =  -(d * h0 + b * w1 + ty) * 2 / director.height + 1.0; 
    
    if(sprite.fill is Color) {
      var color = sprite.fill as Color;
      var colorIndex = no * 16;
      for(var i = 0; i < 4; i++){
        colors[colorIndex + i] = color.red / 255.0;
        colors[colorIndex + i + 1] = color.green / 255.0;
        colors[colorIndex + i + 2] = color.blue / 255.0;
        colors[colorIndex + i + 3] = color.alpha;
        colorIndex += 3;
      }
    } else if(_fill is Image) {
      var img = _fill as Image;
      var tw = img.width;
      var th = img.height;
      var right = img.frameX + img.frameWidth;
      var bottom = img.frameY + img.frameHeight;
      
      uvs[index + 0] = img.frameX / tw;
      uvs[index + 1] = img.frameY / th;
      
      uvs[index + 2] = right / tw;
      uvs[index + 3] = img.frameY / th;
     
      uvs[index + 4] = right / tw;
      uvs[index + 5] = bottom / th;
      
      uvs[index + 6] = img.frameX / tw;
      uvs[index + 7] = bottom / th;
      
//      print(uvs);
    }
  }
  
  growBuffer() {
    final webgl.RenderingContext gl = renderer.gl;
    verticies = new Float32List(_numSprites * 8);
    gl.bindBuffer(webgl.ARRAY_BUFFER, vertexBuffer);
    gl.bufferData(webgl.ARRAY_BUFFER, verticies, webgl.DYNAMIC_DRAW);
    
    if(_fill is Color){
      colors = new Float32List(_numSprites * 16);
      gl.bindBuffer(webgl.ARRAY_BUFFER, colorBuffer);
      gl.bufferData(webgl.ARRAY_BUFFER, colors, webgl.DYNAMIC_DRAW);
    }else if(_fill is Image){
      uvs  = new Float32List(_numSprites * 8);  
      gl.bindBuffer(webgl.ARRAY_BUFFER, uvBuffer);
      gl.bufferData(webgl.ARRAY_BUFFER, uvs, webgl.DYNAMIC_DRAW);
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
    gl.bufferData(webgl.ELEMENT_ARRAY_BUFFER, indices, webgl.STATIC_DRAW);
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
      gl.bufferSubData(webgl.ARRAY_BUFFER, 0, colors);
      gl.vertexAttribPointer(program.colorAttribute, 4, webgl.FLOAT, false, 0, 0);
    }else if(_fill is Image){
      program = renderer.getShaderProgram("texture");
      gl.useProgram(program.program);
      gl.bindBuffer(webgl.ARRAY_BUFFER, uvBuffer);
      gl.bufferSubData(webgl.ARRAY_BUFFER, 0, uvs);
      gl.vertexAttribPointer(program.textureCoordAttribute, 2, webgl.FLOAT, false, 0, 0);
      gl.activeTexture(webgl.TEXTURE0);
      gl.bindTexture(webgl.TEXTURE_2D, renderer.findTexture(_fill as Image));
      gl.uniform1i(program.samplerUniform, 0);
    }

    gl.bindBuffer(webgl.ARRAY_BUFFER, vertexBuffer);
    gl.bufferSubData(webgl.ARRAY_BUFFER, 0, verticies);
    gl.vertexAttribPointer(program.vertexPositionAttribute, 2, webgl.FLOAT, false, 0, 0);
    
    gl.bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.drawElements(webgl.TRIANGLES, _numSprites * 6, webgl.UNSIGNED_SHORT, 0);
  }
}








