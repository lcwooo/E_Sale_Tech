import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class LoginEvent{

  bool isWx;
  bool isClose;
  LoginEvent(bool isWx,bool isClose){
    this.isClose = isClose;
    this.isWx = isWx;
  }
}
