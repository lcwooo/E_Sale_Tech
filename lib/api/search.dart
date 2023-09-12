import 'dart:convert';
import 'dart:convert' as convert;
import 'package:E_Sale_Tech/api/http.dart';

import 'package:E_Sale_Tech/model/shop/products_info.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef OnSuccess<T>(T data);

typedef OnFail(String message);

class ApiSearch {
  static const String PRODUCTS_LIST = 'products/edit/product-list';

  static Future<Map> getProductsList([Map<String, dynamic> params]) async {
    var page = (params is Map) ? params['page'] : 1;
    Map<String, dynamic> result;
    await DioUtil.instance.requestNetwork(Method.get, ApiSearch.PRODUCTS_LIST,
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
}
