import 'package:event_bus/event_bus.dart';
// import 'package:E_Sale_Tech/model/token_info.dart';
import 'package:flutter/cupertino.dart';

class ApplicationEvent {
  static EventBus event;
}

//Loading
class ShowLoadingEvent {
  ShowLoadingEvent();
}

// //登录后
// class UserLoggedInEvent {
//   TokenInfo token;

//   UserLoggedInEvent(this.token);
// }

//未验证
class UnAuthenticateEvent {
  UnAuthenticateEvent();
}

//Change Language
class ChangeLanguage {
  Locale local;
  ChangeLanguage(this.local);
}

class ChangeKeepAlivePageIndex {
  String pageName;
  ChangeKeepAlivePageIndex({this.pageName});
}

//登录失败
class UserLoggedFailedEvent {
  UserLoggedFailedEvent();
}

//添加购物车后
class CartAddedEvent {
  CartAddedEvent();
}

//订单提交后
class OrderAddedEvent {
  OrderAddedEvent();
}

//商品分类页面切换
class DataListPagerRefreshEvent {
  DataListPagerRefreshEvent();
}

//是否刷新列表
class ListRefreshEvent {
  String type;
  String field;
  dynamic value;
  int index;
  ListRefreshEvent([this.type, this.index, this.field, this.value]);
}

//显示上传图片选择框
class PhotoPickerEvent {
  BuildContext context;
  PhotoPickerEvent([this.context]);
}

class HomeRefresh {
  HomeRefresh();
}

class UpOrOffGoodsShelf {
  UpOrOffGoodsShelf();
}

class RefreshGoodDetailAfterEditPrice {
  RefreshGoodDetailAfterEditPrice();
}
