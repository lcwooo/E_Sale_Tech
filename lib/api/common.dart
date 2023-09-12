import 'dart:io';

import 'package:E_Sale_Tech/model/user/login_bean.dart';
import 'package:E_Sale_Tech/utils/localstorage.dart';
import 'package:E_Sale_Tech/views/login/phone_country_code_entity.dart';
import 'package:dio/dio.dart';
import 'package:E_Sale_Tech/api/http.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSuccess<T>(T data);

typedef OnFail(String message);

class Api {
  // 上线
  // static const String BASE_URL = 'https://api.esaletech.com/v1/agent/';
  // static const String STORAGE_URL = 'https://api.esaletech.com/v1/agent/';
  // static const String DEV_STORAGE_URL = 'https://api.esaletech.com/v1/agent/';
  // static const String DEV_BASE_URL = 'https://api.esaletech.com/v1/agent/';
  // 开发
  static const String BASE_URL =
      'https://dev-onshopway-api.nle-tech.com/v1/agent/';
  static const String STORAGE_URL =
      'https://dev-onshopway-api.nle-tech.com/v1/agent/';
  static const String DEV_STORAGE_URL =
      'https://dev-onshopway-api.nle-tech.com/v1/agent/';
  static const String DEV_BASE_URL =
      'https://dev-onshopway-api.nle-tech.com/v1/agent/';

  static const bool isTest = true;
  static const String REFRESH_TOKEN = '';

  static const String UPLOAD_IMAGE = 'uploads/image';
  static const String UPLOADIDCARD_IMAGE = 'addresses/id-card';

  static const String LOGIN = 'agent/login';
  static const String PHONE_CODE = 'phone-code';

  //上传图片
  static Future<String> uploadImage(File image) async {
    EasyLoading.show(status: '上传中...');
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);

    FormData formData = new FormData.fromMap({
      "image": await MultipartFile.fromFile(path, filename: name + "." + suffix)
    });

    var result;
    await DioUtil.instance.requestNetwork(Method.post, Api.UPLOAD_IMAGE,
        params: formData, onSuccess: (response) async {
      result = response.data;
      EasyLoading.dismiss();
    }, onError: (id, error) {
      EasyLoading.showError('上传失败');
    });
    return result;
  }

  //上传身份证图片
  static Future<Map> uploadIDCardImage(File image, String side) async {
    EasyLoading.show(status: '上传中...');
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);

    FormData formData = new FormData.fromMap({
      "image":
          await MultipartFile.fromFile(path, filename: name + "." + suffix),
      'side': side
    });
    var result;
    await DioUtil.instance.requestNetwork(Method.post, Api.UPLOADIDCARD_IMAGE,
        params: formData, onSuccess: (response) async {
      result = response.data;
      EasyLoading.dismiss();
    }, onError: (id, error) {
      EasyLoading.showError('上传失败');
    });
    return result;
  }

  static Future<Map> getShipments([Map<String, dynamic> params]) async {
    Map<String, dynamic> result;
    await DioUtil.instance.requestNetwork(Method.get, Api.PHONE_CODE,
        queryParameters: params, onSuccess: (response) {
      var responseList = response.data;
      List<Country> list = [];
      for (int i = 0; i < responseList.length; i++) {
        try {
          Country cellData = new Country.fromJson(responseList[i]);
          list.add(cellData);
        } catch (e) {
          print(e);
        }
      }
      result = {
        "list": list,
      };
    }, onError: (ret, msg) {});
    return result;
  }

  static Future<Map> login([Map<String, dynamic> params]) async {
    EasyLoading.show(status: '加载中...');
    params = {
      'phone': params['phone'],
      'password': params['password'],
      'timezone': params['timezone'],
      'code': params['code'],
    };
    var result;
    await DioUtil.instance.requestNetwork(Method.post, Api.LOGIN,
        queryParameters: params, onSuccess: (response) {
      EasyLoading.dismiss();
      var responseList = response.data;
      print(response.data);
      LoginBean cellData = new LoginBean.fromJson(responseList);
      result = {
        "bean": cellData,
      };
    }, onError: (ret, msg) {
      EasyLoading.dismiss();
      result = {
        "msg": msg,
      };
    });

    return result;
  }
}
