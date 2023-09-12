import 'package:E_Sale_Tech/api/http.dart';
import 'package:E_Sale_Tech/api/log_util.dart';
import 'package:E_Sale_Tech/model/goods/goodsDetailInfo.dart';
import 'package:E_Sale_Tech/model/goods/myGoodsInformation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef OnSuccess<T>(T data);

typedef OnFail(String message);

class ApiGoods {
  static const String GoodInfo = 'products/edit/product-detail/';
  static const String GetGoodsMterial = 'products/edit/material/';
  static const String EditGoodsPrice = 'products/edit/edit-goods';
  static const String BatchEdit = 'products/edit/batch-edit';
  static const String UpOffshelf = 'products/edit/up-off-shelf';
  static const String MyProductList = "products/edit/my-product";
  static const String MyProductListDelete = "products/edit/destroy/";
  static const String GetGoodsQrCodePic = "products/edit/qr-code/";
  static const String BatchOffShelf = "products/edit/batch-off-shelf/";
  static const String CopyText = "products/edit/material/copy";
  static const String ShoppingNotice = "products/shopping-notice";

  // 批量下架商品
  static Future<GoodsDetailInfo> batchOffShelf(
      String ids, OnSuccess onSuccess, OnFail onFail) async {
    EasyLoading.show(status: '下架商品...');
    String lastStr = ApiGoods.BatchOffShelf + ids;
    await DioUtil.instance.requestNetwork(Method.put, lastStr, params: null,
        onSuccess: (response) {
      EasyLoading.dismiss();
      // goodsInfo = new GoodsDetailInfo.fromJson(responseList);
      onSuccess(response);
    }, onError: (id, msg) {
      EasyLoading.dismiss();
      onFail(msg);
    });
  }

  static Future<GoodsDetailInfo> goodsDetail(
      Map<dynamic, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    GoodsDetailInfo goodsInfo;

    String lastStr = ApiGoods.GoodInfo + params["goodsId"].toString();
    await DioUtil.instance.requestNetwork(Method.get, lastStr, params: params,
        onSuccess: (response) {
      var responseList = response.data;
      goodsInfo = new GoodsDetailInfo.fromJson(responseList);
      onSuccess(goodsInfo);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  // ignore: missing_return
  static Future<Map> getShopQrCode(
      Map<dynamic, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    Map goodsQrcode;
    String lastStr = ApiGoods.GetGoodsQrCodePic + params["goodsId"].toString();
    await DioUtil.instance.requestNetwork(Method.get, lastStr, params: params,
        onSuccess: (response) {
      goodsQrcode = response.data;
      onSuccess(goodsQrcode);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future<Map> getGoodsMustKnow(
      Map<dynamic, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    Map goodsMustKnow;
    await DioUtil.instance.requestNetwork(Method.get, ApiGoods.ShoppingNotice,
        params: params, onSuccess: (response) {
      goodsMustKnow = response.data;
      onSuccess(goodsMustKnow);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future getGoodsmterial(
      String goodId, OnSuccess onSuccess, OnFail onFail) async {
    String lastStr = ApiGoods.GetGoodsMterial + goodId;
    await DioUtil.instance.requestNetwork(Method.get, lastStr, params: null,
        onSuccess: (response) {
      var responseList = response.data;
      onSuccess(responseList);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future copyAddOne(
      String textId, String goodsId, OnSuccess onSuccess, OnFail onFail) async {
    Map par = {"text_id": textId, "product_id": goodsId};
    await DioUtil.instance.requestNetwork(Method.post, ApiGoods.CopyText,
        params: par, onSuccess: (response) {
      var responseList = response.data;
      onSuccess(responseList);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future<Map> editGoodsPrice(Map<dynamic, dynamic> params) async {
    print(params);
    Map<String, dynamic> par;
    List<Map> list1 = [];
    GoodsDetailInfo detailInfo = params["goodsInfo"];
    List goodsList = detailInfo.goods;
    for (Goods item in goodsList) {
      list1.add({
        "goods_id": item.id,
        "total_price": item.totalPrice,
        "is_show": item.isShow
      });
    }
    EasyLoading.show(status: '提交信息...');
    par = {"goods_info": list1};
    Map result;
    await DioUtil.instance.requestNetwork(Method.post, ApiGoods.EditGoodsPrice,
        queryParameters: par, onSuccess: (response) {
      EasyLoading.dismiss();
      result = {
        "ret": response.ret,
        "msg": response.message,
        "data": response.data
      };
    }, onError: (ret, msg) {
      EasyLoading.dismiss();
      print(msg);
      result = {"ret": 0, "msg": msg, "data": []};
    });
    return result;
  }

  static Future setProductBatchUpShelf(
      Map params, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(Method.post, ApiGoods.BatchEdit,
        params: params, onSuccess: (response) {
      onSuccess(response);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future setProductUpOffShelf(
      Map params, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(Method.post, ApiGoods.UpOffshelf,
        params: params, onSuccess: (response) {
      onSuccess(response);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future<Map> myGoodsList([Map<String, dynamic> params]) async {
    Log.i('商品列表接口');
    var page = (params is Map) ? params['page'] : 1;
    Map result;
    await DioUtil.instance.requestNetwork(Method.get, ApiGoods.MyProductList,
        queryParameters: params, onSuccess: (response) {
      var list = response.data;
      List<MyGoodsInformation> goodsList = [];
      list.forEach((good) {
        goodsList.add(MyGoodsInformation.fromJson(good));
      });
      result = {
        "ret": 1,
        "list": goodsList,
        'total': response.meta['last_page'],
        'pageIndex': page
      };
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  static Future setProductsFavorite(
      String url, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(Method.post, url,
        onSuccess: (response) {
      onSuccess(response);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future setProductsDelete(
      Map<String, List> params, OnSuccess onSuccess, OnFail onFail) async {
    String endStr = "";
    EasyLoading.show(status: '删除商品...');
    for (MyGoodsInformation item in params["list"]) {
      if (endStr.isEmpty) {
        endStr = item.id.toString();
      } else {
        endStr = endStr + "," + item.id.toString();
      }
    }
    String urlStr = ApiGoods.MyProductListDelete + endStr;
    await DioUtil.instance.requestNetwork(Method.delete, urlStr,
        onSuccess: (response) {
      EasyLoading.showSuccess(response.message);
      onSuccess(response);
    }, onError: (id, msg) {
      EasyLoading.showError(msg);
      onFail(msg);
    });
  }
}
