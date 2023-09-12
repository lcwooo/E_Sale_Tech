import 'package:E_Sale_Tech/api/http.dart';
import 'package:E_Sale_Tech/model/home/homeCategories.dart';
import 'package:E_Sale_Tech/model/home/homeData.dart';
import 'package:E_Sale_Tech/model/shop/products_info.dart';
import 'dart:convert' as convert;

import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef OnSuccess<T>(T data);

typedef OnFail(String message);

class ApiHome {
  static const String HOMEDATA = 'index/products/index-list';
  static const String HOMELIST = 'index/recommend-products';
  static const String Information = 'shop/apply/apply';
  static const String ApplyIdCard = 'shop/apply/id-card';
  static const String SearchKeyWords = 'product-search/get-keywords';
  static const String SearchblurrySearch = 'product-search/blurry-search/?';
  static const String TypeListDate = 'index/special-products?';
  static const String DeleteSearchHistory = 'product-search/delete-history';
  static const String CATEGORIES = 'categories';

  static Future<Map> perfectInformation(
      Map<dynamic, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    EasyLoading.show(status: '提交中...');
    Map result;
    await DioUtil.instance.requestNetwork(Method.post, ApiHome.Information,
        params: params, onSuccess: (response) {
      EasyLoading.dismiss();
      String jsonStr = convert.jsonEncode(result);
      result = {
        "ret": response.ret,
        "msg:": response.message,
        "data": response.data
      };
      onSuccess(result);
    }, onError: (id, msg) {
      EasyLoading.dismiss();
      onFail(msg);
    });
  }

  static Future<Map> applyIDCard(
      Map<dynamic, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    EasyLoading.show(status: '提交中...');
    Map result;
    await DioUtil.instance.requestNetwork(Method.post, ApiHome.ApplyIdCard,
        params: params, onSuccess: (response) {
      EasyLoading.dismiss();
      String jsonStr = convert.jsonEncode(result);
      result = {
        "ret": response.ret,
        "msg:": response.message,
        "data": response.data
      };
      onSuccess(result);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future getCategrise(OnSuccess onSuccess, OnFail onFail) async {
    List<HomeCategories> resList = [];
    await DioUtil.instance.requestNetwork(Method.get, ApiHome.CATEGORIES,
        params: null, onSuccess: (response) {
      var responseList = response.data;
      responseList.forEach((v) {
        resList.add(new HomeCategories.fromJson(v));
      });
      onSuccess(resList);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  Future getCategrise1(OnSuccess onSuccess, OnFail onFail) async {
    EasyLoading.show(status: '获取分类列表...');
    List<HomeCategories> resList = [];
    await DioUtil.instance.requestNetwork(Method.get, ApiHome.CATEGORIES,
        params: null, onSuccess: (response) {
      var responseList = response.data;
      responseList.forEach((v) {
        resList.add(new HomeCategories.fromJson(v));
      });
      onSuccess(resList);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future home(OnSuccess onSuccess, OnFail onFail) async {
    HomeDataInfo homeInfo;
    await DioUtil.instance.requestNetwork(Method.get, ApiHome.HOMEDATA,
        params: null, onSuccess: (response) {
      var responseList = response.data;
      homeInfo = new HomeDataInfo.fromJson(responseList);
      onSuccess(homeInfo);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future<Map> getHomeProductsList([Map<String, dynamic> params]) async {
    var page = (params is Map) ? params['page'] : 1;
    Map<String, dynamic> result;
    await DioUtil.instance.requestNetwork(Method.get, ApiHome.HOMELIST,
        queryParameters: params, onSuccess: (response) {
      List<ProductsItem> cellData =
          new ProductsList.fromJson(response).productsList;
      result = {
        "list": cellData,
        'total': response.meta['last_page'],
        'pageIndex': page
      };
    }, onError: (id, res) {
      result = null;
    });
    return result;
  }

  static Future<Map> searchKeyWords(OnSuccess onSuccess, OnFail onFail) async {
    EasyLoading.show(status: '加载中...');
    await DioUtil.instance.requestNetwork(Method.get, ApiHome.SearchKeyWords,
        params: null, onSuccess: (response) {
      EasyLoading.dismiss();
      var responseList = response.data;
      // String jsonStr = convert.jsonEncode(responseList);
      // homeInfo = new HomeDataInfo.fromJson(responseList);
      onSuccess(responseList);
    }, onError: (id, msg) {
      EasyLoading.showError(msg);
      onFail(msg);
    });
  }

  static Future<Map> deleteSearchHistory(
      OnSuccess onSuccess, OnFail onFail) async {
    EasyLoading.show(status: '删除中...');
    await DioUtil.instance.requestNetwork(
        Method.delete, ApiHome.DeleteSearchHistory, params: null,
        onSuccess: (response) {
      EasyLoading.dismiss();
      onSuccess(response);
    }, onError: (id, msg) {
      EasyLoading.showError(msg);
      onFail(msg);
    });
  }

  static Future<Map> getProductsList([Map<String, dynamic> params]) async {
    var page = (params is Map) ? params['page'] : 1;
    var type = params["type"];
    // String searchStr = ApiHome.TypeListDate + "type=" + type.toString();
    Map<String, dynamic> result;
    await DioUtil.instance.requestNetwork(Method.get, ApiHome.TypeListDate,
        queryParameters: params, onSuccess: (response) {
      List<ProductsItem> cellData =
          new ProductsList.fromJson(response).productsList;
      result = {
        "list": cellData,
        'total': response.meta['last_page'],
        'pageIndex': page
      };
    }, onError: (id, res) {
      result = null;
    });
    return result;
  }

  static Future<Map> searchblurrySearch(
      Map<dynamic, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    Map result;
    String searchStr =
        ApiHome.SearchblurrySearch + "keyword=" + params["keyword"];
    // Map par = {"keyword":params["keyword"]};
    await DioUtil.instance.requestNetwork(Method.get, searchStr, params: null,
        onSuccess: (response) {
      // EasyLoading.dismiss();
      // String jsonStr = convert.jsonEncode(result);
      result = {
        "ret": response.ret,
        "msg:": response.message,
        "data": response.data
      };
      onSuccess(result);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }
}
