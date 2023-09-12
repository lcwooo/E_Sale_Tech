import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/model/shop/shop_info.dart';
import 'package:flutter/material.dart';

class ShopInfoProvider extends ChangeNotifier {

  ShopInfo _shopInfo = new ShopInfo();

  ShopInfo get shopInfo => _shopInfo;
 
  void setShopInfo(ShopInfo data) {
    _shopInfo = data;
    notifyListeners();
  }

  void getShopInfo() async {
    var data = await ApiShop.getShopInfo();
    _shopInfo = data;
    notifyListeners();
  }
 
}