part of compass;

class EventDispatcher<T> {
  dynamic _trigger;
  List<EventSubscription> _subscriptions = [];
  bool _dispatched = false;
  T _data;
  
  EventDispatcher(trigger) {
    _trigger = trigger;
  }

  EventSubscription<T> listen(handler) {
      var subscription = new EventSubscription<T>(this, handler);
      _subscriptions.add(subscription);
      return subscription;
  }
  
  EventSubscription<T> then(handler) {
    return _then(handler, false);
  }
  
  EventSubscription<T> once(handler) {
    return _then(handler, true);
  }
  
  EventSubscription<T> _then(handler, bool once) {
    var subscription = listen(handler);
    subscription._once = once;
    if(_dispatched) subscription._invoke(_trigger, _data);
    return subscription;
  }

  dispatch([T data])  {
    //TODO 这里会产生一个比较诡异的BUG，某些时候监听时并不想获取上一次的事件，所以这个还是需要在构造的时候指定一下。
    _dispatched = true;
    var subscriptions = _subscriptions;
    var subscriptionsLength = _subscriptions.length;
    for(var i = 0; i < subscriptionsLength; i++) {
      var subscription = subscriptions[i];
      if (subscription._canceled == false) {
        subscription._invoke(_trigger, data);
      }
    }
  }
  
  cancel(EventSubscription<T> eventSubscription) {
    if (eventSubscription._canceled) return;
    var subscriptions = [];
    for(var i = 0; i < _subscriptions.length; i++) {
      var subscription = _subscriptions[i];
      if (identical(subscription, eventSubscription)) {
        subscription._canceled = true;
      } else {
        subscriptions.add(subscription);
      }
    }
    _subscriptions = subscriptions;
  }
  
  clear() {
    for(var i = 0; i < _subscriptions.length; i++) {
      var subscription = _subscriptions[i];
      subscription._canceled = true;
    }
    _subscriptions = [];
  }
  
  get hasListener => _subscriptions.length > 0;
}










