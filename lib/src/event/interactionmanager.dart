part of compass;

class InteractionManager {
  bool dirty;
  html.CanvasElement _canvas;
  Point _global;
  var _canvasBounding;
  num _widthScale, _heightScale;
  
  InteractionManager(html.CanvasElement canvas) {
    _canvas = canvas;
    _canvas.onMouseMove.listen(_mouseMoveHandler);
    _canvas.onMouseDown.listen(_mouseDownHandler);
    _canvas.onMouseUp.listen(_mouseUpHandler);
    _canvasBounding = _canvas.getBoundingClientRect();
    _widthScale = _canvas.width / _canvasBounding.width;
    _heightScale = _canvas.height / _canvasBounding.height;
    _global = new Point.zero();
  }
  
  _updateGlobal(html.MouseEvent e) {
    _global.setTo(
        (e.client.x - _canvasBounding.left) * _widthScale, 
        (e.client.y - _canvasBounding.top) * _heightScale);
  }
  
  _mouseMoveHandler(html.MouseEvent e) {
    _updateGlobal(e);
    _handleHitTest(director.scene, e, 
        (o) => o.onMouseMove,
        beforDispatchHandler : (o, e) {
          if(!o.isMouseOver) {
            o.onMouseOver.dispatch(e);
            o.isMouseOver = true;
          }
        },
        afterDispatchHandler : (o, e, hit) {
          if(!hit && o.isMouseOver)
            o.onMouseOut.dispatch(e);
          if(!hit)
            o.isMouseOver = false;
        });
  }
  
  _mouseDownHandler(html.MouseEvent e) {
    _updateGlobal(e);
    _handleHitTest(director.scene, e,
        (o) => o.onMouseDown,
        afterDispatchHandler : (o, e, hit) {
          o.isMouseDown = hit;
        });
  }
  
  _mouseUpHandler(html.MouseEvent e) {
    _updateGlobal(e);
    _handleHitTest(director.scene, e, 
        (o) => o.onMouseUp,
        afterDispatchHandler : (o, e, hit) {
          if(hit && o.isMouseDown)
            o.onClick.dispatch(e);
          if(!hit && o.isMouseDown)
            o.onMouseUpOut.dispatch(e);
          o.isMouseDown = false; 
        });
  }

  _handleHitTest(InteractiveObject object, html.MouseEvent e, Function getDispatcher, 
                 {Function beforDispatchHandler, Function afterDispatchHandler}) {
    if(object.interactive) {
      final EventDispatcher dispatcher = getDispatcher(object);
      final transform = object.worldTransform;
      final event = new MouseEvent(_global.x - transform[2], _global.y - transform[5], _global.x, _global.y);
      var hit = false;
      if(object.hitTest(_global)) {
        hit = true;
        if(beforDispatchHandler != null)
          beforDispatchHandler(object, event);
        if(dispatcher.hasListener)
          dispatcher.dispatch(event);
      }
      if(afterDispatchHandler != null) 
        afterDispatchHandler(object, event, hit);
    }
    if(object is Layer && object.interactiveChildren) {
      object.children.forEach((child) => 
          _handleHitTest(child, e, getDispatcher, 
            beforDispatchHandler: beforDispatchHandler, 
            afterDispatchHandler: afterDispatchHandler));
    }
  }
  
  _touchStartHandler(html.TouchEvent e) {
    
  }
}