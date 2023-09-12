import 'package:E_Sale_Tech/api/http.dart';
import 'package:E_Sale_Tech/model/shop/app_start_ad_indo.dart';
import 'package:E_Sale_Tech/model/shop/brand_info.dart';
import 'package:E_Sale_Tech/model/shop/category_info.dart';
import 'package:E_Sale_Tech/model/shop/coupons_info.dart';
import 'package:E_Sale_Tech/model/shop/order_detail_tracking.dart';
import 'package:E_Sale_Tech/model/shop/orders_info.dart';
import 'package:E_Sale_Tech/model/shop/product_sort_list.dart';
import 'package:E_Sale_Tech/model/shop/products_collection_info.dart';
import 'package:E_Sale_Tech/model/shop/products_info.dart';
import 'package:E_Sale_Tech/model/shop/shop_info.dart';
import 'package:E_Sale_Tech/model/shop/shop_preferential_info.dart';
import 'package:E_Sale_Tech/model/shop/shop_template_info.dart';
import 'package:E_Sale_Tech/model/shop/statistics_sales_info.dart';
import 'package:E_Sale_Tech/model/shop/statistics_trade_info.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef OnSuccess<T>(T data);

typedef OnFail(String message);

class ApiShop {
  static const String SHOP_INFO = 'shop/info';
  static const String SHOP_QR_CODE = 'shop/qr-code';
  static const String SHOP_TEMPLATES_MINE = 'shop/templates/mine/';
  static const String SHOP_MP_QR_CODE = 'shop/mini-program-qr-code';
  static const String PRODUCTS_SORT_INDEX = 'products/sort-indexes';
  static const String PRODUCTS_COLLECTIONS = 'products/collections';
  static const String PRODUCTS_LIST = 'products/edit/product-list';
  static const String PRODUCTS_BATCH_UP_SHELF = 'products/edit/batch-up-shelf';
  static const String STATISTICS_TRADES = 'statistics/trades';
  static const String STATISTICS_SALES = 'statistics/sales';
  static const String ORDERS = 'orders';
  static const String OrdersTracking = 'orders/:id/tracking';
  static const String OrdersCheck = 'orders/check/:id';
  static const String COUPONS = 'coupons';
  static const String COUPONS_SHARE_URL = 'coupons/:id/share-url';
  static const String COUPONS_CATEGORY_DETAIL = 'coupons/:id/categories';
  static const String COUPONS_GOODS_DETAIL = 'coupons/:id/products';
  static const String COUPONS_BRAND_DETAIL = 'coupons/:id/brands';
  static const String PRODUCTS_FILTER_BRANDS = 'products/filter-brands';
  static const String PRODUCTS_FILTER_CATEGORY = 'products/filter-categories';
  static const String SHOP_PREFERENTIAL = 'preferential';
  static const String SHOP_PREFERENTIAL_RETURN_MONEY =
      'preferential/return-money';
  static const String SHOP_PREFERENTIAL_LEVEL_UP = 'preferential/level-up';
  static const String PlaceTheOrderPayment = 'orders/payment';
  static const String CancelTheOrderPayment = 'orders/:id/cancel';
  static const String DownLoadTheOrderPaymentInvoice = 'orders/:id/invoice-url';
  static const String MAIN_APP_START_IMAGE = 'app-start-image';

  static Future getAppStartImage(OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(
        Method.get, ApiShop.MAIN_APP_START_IMAGE, onSuccess: (response) {
      AppStartAd celldata = AppStartAd.fromJson(response.data);
      onSuccess(celldata);
    }, onError: (id, res) {
      onFail(res);
    });
  }

  static Future<ShopInfo> getShopInfo() async {
    ShopInfo cellData;
    await DioUtil.instance.requestNetwork(Method.get, ApiShop.SHOP_INFO,
        onSuccess: (response) {
      var responseList = response.data;
      cellData = new ShopInfo.fromJson(responseList);
    }, onError: (id, res) {
      print(res);
    });
    return cellData;
  }

  static Future getShopPreferential(OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(Method.get, ApiShop.SHOP_PREFERENTIAL,
        onSuccess: (response) {
      ShopPreferential celldata = ShopPreferential.fromJson(response.data);
      onSuccess(celldata);
    }, onError: (id, res) {
      onFail(res);
    });
  }

  static Future getOrdersDetailTracking(
      String id, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(
        Method.get, ApiShop.OrdersTracking.replaceAll(':id', id),
        onSuccess: (response) {
      var list = response.data;
      if (list.length == 0) {
        onSuccess("没有数据");
      } else {
        OrdersDetailTracking celldata =
            OrdersDetailTracking.fromJson(response.data);
        onSuccess(celldata);
      }
    }, onError: (id, res) {
      onFail(res);
    });
  }

  static Future getShopMpQrCode(OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(Method.get, ApiShop.SHOP_MP_QR_CODE,
        onSuccess: (response) {
      onSuccess(response);
    }, onError: (id, res) {
      onFail(res);
    });
  }

  static Future setOrdersCheck(
      int id, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(
        Method.post, ApiShop.OrdersCheck.replaceAll(':id', id.toString()),
        onSuccess: (response) {
      onSuccess(response);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future getShopTemplate(OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(
        Method.get, ApiShop.SHOP_TEMPLATES_MINE, onSuccess: (response) {
      ShopTemplateInfo celldata = ShopTemplateInfo.fromJson(response.data);
      onSuccess(celldata);
    }, onError: (id, res) {
      onFail(res);
    });
  }

  static Future setShopTemplate(
      Map<String, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance
        .requestNetwork(Method.put, ApiShop.SHOP_TEMPLATES_MINE, params: params,
            onSuccess: (response) {
      onSuccess(response);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future getShopPreferentialStatus(
      int type, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(
        Method.post,
        type == 1
            ? ApiShop.SHOP_PREFERENTIAL_LEVEL_UP
            : ApiShop.SHOP_PREFERENTIAL_RETURN_MONEY, onSuccess: (response) {
      onSuccess(response);
    }, onError: (id, res) {
      onFail(res);
    });
  }

  static Future getStatisticsTrades(
      params, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(Method.get, ApiShop.STATISTICS_TRADES,
        queryParameters: params, onSuccess: (response) {
      print(response);
      StatisticTradeData cellData =
          new StatisticsTrade.fromJson(response).statisticTradeData;
      onSuccess(cellData);
    }, onError: (id, res) {
      onFail(res);
    });
  }

  static Future getStatisticsSales(
      params, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(Method.get, ApiShop.STATISTICS_SALES,
        queryParameters: params, onSuccess: (response) {
      print(response);
      StatisticsSalesData cellData =
          new StatisticsSales.fromJson(response).statisticsSalesData;
      onSuccess(cellData);
    }, onError: (id, res) {
      onFail(res);
    });
  }

  static Future<ShopQrCode> getShopQRcode() async {
    ShopQrCode cellData;
    await DioUtil.instance.requestNetwork(Method.get, ApiShop.SHOP_QR_CODE,
        onSuccess: (response) {
      var responseList = response.data;
      cellData = new ShopQrCode.fromJson(responseList);
    }, onError: (id, res) {
      print(res);
    });
    return cellData;
  }

  static Future setShopQRcode(
      Map<String, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(Method.put, ApiShop.SHOP_QR_CODE,
        params: params, onSuccess: (response) {
      onSuccess(response);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future getProductsSortList(OnSuccess onSuccess, OnFail onFail) async {
    ProductsSortList cellData;
    await DioUtil.instance.requestNetwork(
        Method.get, ApiShop.PRODUCTS_SORT_INDEX, onSuccess: (response) {
      cellData = new ProductsSortList.fromJson(response.data);
      onSuccess(cellData);
    }, onError: (id, res) {
      onFail(res);
    });
  }

  static Future getBrands(OnSuccess onSuccess, OnFail onFail) async {
    List<BrandList> cellData;
    await DioUtil.instance.requestNetwork(
        Method.get, ApiShop.PRODUCTS_FILTER_BRANDS, onSuccess: (response) {
      cellData = new BrandDataInfo.fromJson(response).brandList;
      onSuccess(cellData);
    }, onError: (id, res) {
      onFail(res);
    });
  }

  static Future getCategory(OnSuccess onSuccess, OnFail onFail) async {
    List<CategoryList> cellData;
    await DioUtil.instance.requestNetwork(
        Method.get, ApiShop.PRODUCTS_FILTER_CATEGORY, onSuccess: (response) {
      cellData = new CategoryDataInfo.fromJson(response).categoryList;
      onSuccess(cellData);
    }, onError: (id, res) {
      onFail(res);
    });
  }

  static Future<Map> getProductsList([Map<String, dynamic> params]) async {
    var page = (params is Map) ? params['page'] : 1;
    Map<String, dynamic> result;
    await DioUtil.instance.requestNetwork(Method.get, ApiShop.PRODUCTS_LIST,
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
      EasyLoading.dismiss();
    });
    return result;
  }

  static Future<Map> getOrdersList([Map<String, dynamic> params]) async {
    var page = (params is Map) ? params['page'] : 1;
    Map<String, dynamic> result;
    await DioUtil.instance.requestNetwork(Method.get, ApiShop.ORDERS,
        queryParameters: params, onSuccess: (response) {
      List<OrdersListInfo> cellData =
          new OrdersInfo.fromJson(response).ordersList;
      result = {
        "list": cellData,
        'total': response.meta['last_page'],
        'pageIndex': page
      };
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  static Future getOrderDetail(
      int id, OnSuccess onSuccess, OnFail onFail) async {
    OrdersListInfo cellData;
    await DioUtil.instance.requestNetwork(Method.get, ApiShop.ORDERS + '/$id',
        onSuccess: (response) {
      var responseList = response.data;
      cellData = new OrdersListInfo.fromJson(responseList);
      onSuccess(cellData);
    }, onError: (id, res) {
      onFail(res);
    });
  }

  static Future getCouponShareUrl(
      int id, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(
        Method.get, ApiShop.COUPONS_SHARE_URL.replaceAll(':id', id.toString()),
        onSuccess: (response) {
      onSuccess(response);
    }, onError: (id, res) {
      onFail(res);
    });
  }

  static Future getCouponCategoryDetail(
      int id, OnSuccess onSuccess, OnFail onFail) async {
    List<CategoryList> cellData;
    await DioUtil.instance.requestNetwork(Method.get,
        ApiShop.COUPONS_CATEGORY_DETAIL.replaceAll(':id', id.toString()),
        onSuccess: (response) {
      cellData = new CategoryDataInfo.fromJson(response).categoryList;
      onSuccess(cellData);
    }, onError: (id, res) {
      onFail(res);
    });
  }

  static Future getCouponGoodsDetail(int id) async {
    Map result;
    List<ProductsItem> cellData;
    await DioUtil.instance.requestNetwork(Method.get,
        ApiShop.COUPONS_GOODS_DETAIL.replaceAll(':id', id.toString()),
        onSuccess: (response) {
      cellData = new ProductsList.fromJson(response).productsList;
      result = {
        "list": cellData,
      };
    }, onError: (id, res) {});
    return result;
  }

  static Future getCouponBrandDetail(
      int id, OnSuccess onSuccess, OnFail onFail) async {
    List<BrandList> cellData;
    await DioUtil.instance.requestNetwork(Method.get,
        ApiShop.COUPONS_BRAND_DETAIL.replaceAll(':id', id.toString()),
        onSuccess: (response) {
      cellData = new BrandDataInfo.fromJson(response).brandList;
      onSuccess(cellData);
    }, onError: (id, res) {
      onFail(res);
    });
  }

  static Future<Map> getProductsCollectionList(
      [Map<String, dynamic> params]) async {
    var page = (params is Map) ? params['page'] : 1;
    Map<String, dynamic> result;
    await DioUtil.instance.requestNetwork(
        Method.get, ApiShop.PRODUCTS_COLLECTIONS, queryParameters: params,
        onSuccess: (response) {
      List<ProductsCollection> cellData =
          new ProductsCollectionList.fromJson(response).productsCollection;
      result = {
        "list": cellData,
        'total': response.meta['last_page'],
        'pageIndex': page
      };
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  static Future setProductsSortList(
      List params, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance
        .requestNetwork(Method.put, ApiShop.PRODUCTS_SORT_INDEX, params: params,
            onSuccess: (response) {
      onSuccess(response);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future cancelOrderPayment(
      int id, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(Method.put,
        ApiShop.CancelTheOrderPayment.replaceAll(':id', id.toString()),
        onSuccess: (response) {
      onSuccess(response);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future getOrderPaymentParams(
      Map params, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(
        Method.post, ApiShop.PlaceTheOrderPayment, params: params,
        onSuccess: (response) {
      onSuccess(response.data);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future newCoupons(
      Map params, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(Method.post, ApiShop.COUPONS,
        params: params, onSuccess: (response) {
      EasyLoading.dismiss();
      onSuccess(response);
    }, onError: (id, msg) {
      EasyLoading.dismiss();
      onFail(msg);
    });
  }

  static Future<Map> getCouponsList([Map<String, dynamic> params]) async {
    var page = (params is Map) ? params['page'] : 1;
    Map<String, dynamic> result;
    await DioUtil.instance.requestNetwork(Method.get, ApiShop.COUPONS,
        queryParameters: params, onSuccess: (response) {
      List<CouponsList> cellData =
          new CouponsDataInfo.fromJson(response).couponsList;
      result = {
        "list": cellData,
        'total': response.meta['last_page'],
        'pageIndex': page
      };
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  static Future setProductsBatchUpShelf(
      Map params, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(
        Method.post, ApiShop.PRODUCTS_BATCH_UP_SHELF, params: params,
        onSuccess: (response) {
      onSuccess(response);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future setProductsFavorite(
      String url, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(Method.post, url,
        onSuccess: (response) {}, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future setShopInfo(
      Map<String, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(Method.put, ApiShop.SHOP_INFO,
        params: params, onSuccess: (response) {
      onSuccess(response.message);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future getOrderInfoWithInvoice(
      int id, OnSuccess onSuccess, OnFail onFail) async {
    EasyLoading.show(status: '获取发票信息...');
    await DioUtil.instance.requestNetwork(Method.get,
        ApiShop.DownLoadTheOrderPaymentInvoice.replaceAll(':id', id.toString()),
        onSuccess: (response) {
      EasyLoading.dismiss();
      onSuccess(response);
    }, onError: (id, msg) {
      EasyLoading.dismiss();
      onFail(msg);
    });
  }
}
