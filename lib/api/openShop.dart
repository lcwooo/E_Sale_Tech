import 'dart:convert';
import 'dart:convert' as convert;
import 'package:E_Sale_Tech/api/http.dart';
import 'package:E_Sale_Tech/api/log_util.dart';
import 'package:E_Sale_Tech/model/goods/goodsDetailInfo.dart';
import 'package:E_Sale_Tech/model/goods/myGoodsInformation.dart';
import 'package:E_Sale_Tech/model/home/homeData.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef OnSuccess<T>(T data);

typedef OnFail(String message);

class ApiOpenShop {
  static const String GETOPENSHOPIMG = 'shop/apply/apply-image';
  static const String EditGoodsPrice = 'products/edit/edit-goods';
  static const String BatchEdit = 'products/edit/batch-edit';
  static const String UpOffshelf = 'products/edit/up-off-shelf';
  static const String MyProductList = "products/edit/my-product";
  static const String MyProductListDelete = "products/edit/destroy";

  static Future<Map> getOpenShopImg(OnSuccess onSuccess, OnFail onFail) async {
    Map goodsInfo;
    await DioUtil.instance.requestNetwork(
        Method.get, ApiOpenShop.GETOPENSHOPIMG, queryParameters: null,
        onSuccess: (response) {
      var responseList = response.data;
      onSuccess(responseList);
    }, onError: (ret, msg) {
      print(msg);
      onFail(msg);
    });
    return goodsInfo;
  }
}
