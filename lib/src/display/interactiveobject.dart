part of compass;


class InteractiveObject extends DisplayObject {
  EventDispatcher<MouseEvent> onMouseOver;
  EventDispatcher<MouseEvent> onMouseMove;
  EventDispatcher<MouseEvent> onMouseOut;
  EventDispatcher<MouseEvent> onMouseDown;
  EventDispatcher<MouseEvent> onClick;
  EventDispatcher<MouseEvent> onMouseUp;
  EventDispatcher<MouseEvent> onMouseUpOut;
  bool isMouseOver = false;
  bool isMouseDown = false;
  
  InteractiveObject() {
    onMouseOver = new EventDispatcher<MouseEvent>(this);
    onMouseMove = new EventDispatcher<MouseEvent>(this);
    onMouseOut = new EventDispatcher<MouseEvent>(this);
    onMouseDown = new EventDispatcher<MouseEvent>(this);
    onClick = new EventDispatcher<MouseEvent>(this);
    onMouseUp = new EventDispatcher<MouseEvent>(this);
    onMouseUpOut = new EventDispatcher<MouseEvent>(this);
  }
}


