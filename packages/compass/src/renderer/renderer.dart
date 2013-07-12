part of compass;


abstract class Renderer implements Dispose{
  html.CanvasElement canvas;
  
  Renderer(this.canvas);
  nextFrame();
  render(Sprite sprite);
  finishBatch();
  dispose();
}

class WebGLRenderer extends Renderer {
  final Map<html.ImageElement, webgl.Texture> _texturesCache = new Map<html.ImageElement, webgl.Texture>();
  final Map<String, ShaderProgram> _programsCache = new Map<String, ShaderProgram>();
  webgl.RenderingContext gl;
  List<RenderBatch> _batchs;
  int _currentBatchIndex;
  
  WebGLRenderer(html.CanvasElement canvas) : super(canvas) {
    gl = canvas.getContext3d(preserveDrawingBuffer: true);
    gl.disable(webgl.DEPTH_TEST);
    gl.disable(webgl.CULL_FACE);
    gl.enable(webgl.BLEND);
//    gl.blendFunc(SRC_ALPHA, ONE);
//    gl.blendFunc(ONE, ONE_MINUS_SRC_ALPHA);
    _initShader();
    
    _batchs = [new RenderBatch(this)];
    _currentBatchIndex = 0;
  }
  
  _initShader() {
    _programsCache["color"] = new ShaderProgram(VERTEX_SHADER_COLOR, FRAGMENT_SHADER_COLOR, gl);
    _programsCache["texture"] = new ShaderProgram(VERTEX_SHADER_TEXTURE, FRAGMENT_SHADER_TEXTURE, gl);
  }

  getShaderProgram(String name) {
    return _programsCache[name];
  }
  
  nextFrame() {
    _currentBatchIndex = 0;
    
    gl.viewport(0, 0, director.width, director.height);
    gl.clearColor(director.background.red, 
        director.background.green, 
        director.background.blue, 
        director.background.alpha);
    gl.clear(webgl.COLOR_BUFFER_BIT);
  }
  
  render(Sprite sprite) {
    if(sprite.fill is Image){
      loadTexture(sprite.fill as Image);
    }
    if(_batchs[_currentBatchIndex].isStateChanged(sprite)){
      finishBatch();
    }
    _batchs[_currentBatchIndex].add(sprite);
  }
  
  loadTexture(Image fill) {
    if(!_texturesCache.containsKey(fill.imageData)){
      _handleTexture(fill);
    }
  }
  
  findTexture(Image fill) {
    return _texturesCache[fill.imageData];
  }

  _handleTexture(Image fill) {
    print('upload texture $fill');
    webgl.Texture texture = gl.createTexture();
    gl.bindTexture(webgl.TEXTURE_2D, texture);
    gl.pixelStorei(webgl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
    gl.texImage2D(webgl.TEXTURE_2D, 0, webgl.RGBA, webgl.RGBA, webgl.UNSIGNED_BYTE, fill.imageData);
    gl.texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_MAG_FILTER, webgl.LINEAR);
    gl.texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_MIN_FILTER, webgl.LINEAR);
    gl.texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_WRAP_S, webgl.REPEAT);
    gl.texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_WRAP_T, webgl.REPEAT);
    gl.bindTexture(webgl.TEXTURE_2D, null);
    _texturesCache[fill.imageData] = texture;
  }
  
  finishBatch() {
    _batchs[_currentBatchIndex].render();
    _batchs[_currentBatchIndex].reset();
    _currentBatchIndex++;
    if(_batchs.length <= _currentBatchIndex)
      _batchs.add(new RenderBatch(this));
  }

  dispose() {
    _batchs.forEach((batch) => batch.dispose());
    _batchs.clear();
  }
}

class ShaderProgram {
  webgl.Program program;
  int vertexPositionAttribute, textureCoordAttribute, colorAttribute;
  webgl.UniformLocation samplerUniform;
  
  ShaderProgram(String vertextShaderSource, String fragmentShaderSource, webgl.RenderingContext gl) {
    webgl.Shader vertexShader = gl.createShader(webgl.VERTEX_SHADER);
    gl.shaderSource(vertexShader, vertextShaderSource);
    gl.compileShader(vertexShader);
    if (!gl.getShaderParameter(vertexShader, webgl.COMPILE_STATUS)) {
      throw "vertex shader error: "+ gl.getShaderInfoLog(vertexShader);
    }
    
    webgl.Shader fragmentShader = gl.createShader(webgl.FRAGMENT_SHADER);
    gl.shaderSource(fragmentShader, fragmentShaderSource);
    gl.compileShader(fragmentShader);
    if (!gl.getShaderParameter(fragmentShader, webgl.COMPILE_STATUS)) {
      throw "fragment shader error: "+ gl.getShaderInfoLog(fragmentShader);
    }
    
    program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    if (!gl.getProgramParameter(program, webgl.LINK_STATUS)) {
      throw "Could not initialise shaders.";
    }

    vertexPositionAttribute = gl.getAttribLocation(program, "aVertexPosition");
    gl.enableVertexAttribArray(vertexPositionAttribute);
    
    colorAttribute = gl.getAttribLocation(program, "aColor");
    if(colorAttribute >= 0)
      gl.enableVertexAttribArray(colorAttribute);
    
    textureCoordAttribute = gl.getAttribLocation(program, "aTextureCoord");
    if(textureCoordAttribute >= 0)
      gl.enableVertexAttribArray(textureCoordAttribute);
    
    samplerUniform = gl.getUniformLocation(program, "uSampler");
  }
}