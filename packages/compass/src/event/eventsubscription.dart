part of compass;

class EventSubscription<T> {
  bool _canceled = false;
  bool _once = false;
  EventDispatcher<T> _eventDispatcher;
  Function _handler;
  EventSubscription(this._eventDispatcher, this._handler);

  void _invoke(trigger, T data) {
    if(data != null)
      _handler(trigger, data);
    else
      _handler(trigger);
    if(_once){
      _canceled = true;
      cancel();
    }
  }

  void cancel() {
    _eventDispatcher.cancel(this);
  }
}