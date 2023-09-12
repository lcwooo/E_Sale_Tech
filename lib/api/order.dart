import 'dart:convert' as convert;
import 'package:E_Sale_Tech/api/http.dart';
import 'package:E_Sale_Tech/api/log_util.dart';
import 'package:E_Sale_Tech/model/goods/orderPreviewDetail.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef OnSuccess<T>(T data);

typedef OnFail(String message);

class ApiOrder {
  static const String OrderPreview = 'orders/preview';
  static const String PlaceTheOrder = 'orders';

  static Future<OrderPreviewDetail> orderPreview(
      Map<String, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    OrderPreviewDetail previewDetail;
    List list = [params];
    Map<String, dynamic> par;
    par = {"info": list};
    await DioUtil.instance.requestNetwork(Method.post, ApiOrder.OrderPreview,
        params: par, onSuccess: (response) {
      var responseMap = response.data;
      String jsonStr = convert.jsonEncode(responseMap);
      // if (responseMap["address"] == null) {
      //   responseMap["address"] = "";
      // }
      previewDetail = new OrderPreviewDetail.fromJson(responseMap);
      onSuccess(previewDetail);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future<Map> placeTheOrder(
      Map<dynamic, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    Map placeOrder;
    Map par;
    par = new Map<String, dynamic>.from(params);
    EasyLoading.show(status: '加载订单...');
    await DioUtil.instance.requestNetwork(Method.post, ApiOrder.PlaceTheOrder,
        params: par, onSuccess: (response) {
       var responseMap = response.data;
      String jsonStr = convert.jsonEncode(responseMap);
      placeOrder = {"ret": response.ret, "data": responseMap, "msg": response.message};
      EasyLoading.dismiss();
      onSuccess(placeOrder);
    }, onError: (id, msg) {
      EasyLoading.dismiss();
      onFail(msg);
    });
  }
}
