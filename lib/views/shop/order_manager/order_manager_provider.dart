import 'package:flutter/material.dart';

class OrderManagerIndexProvider extends ChangeNotifier {

  /// Tab的下标
  int _index = 0;
  int get index => _index;

  /// 订单来源
  int _orderSource = 0;
  int get orderSource => _orderSource;
 
  void setIndex(int index) {
    _index = index;
    notifyListeners();
  }

  void setOrderSource(int orderSource) {
    _orderSource = orderSource;
    notifyListeners();
  }
 
}