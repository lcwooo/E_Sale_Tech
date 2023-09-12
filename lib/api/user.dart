import 'package:E_Sale_Tech/api/http.dart';
import 'package:E_Sale_Tech/model/user/is_reviewing.dart';
import 'package:E_Sale_Tech/model/user/wx_bind.dart';
import 'package:E_Sale_Tech/model/user/wx_login.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef OnSuccess<T>(T data);

typedef OnFail(String message);

class ApiUser {
  static const String SEND_VERIFY = 'agent/send-verify-code';
  static const String REGISTER = 'agent/register';
  static const String INIFPWD = 'agent/init-pwd';
  static const String OPENLOGIN = "agent/open-login";
  static const String BINDLOGIN = "agent/bind-login";
  static const String ISREVIEWING = "agent/is-reviewing?version=1.0.6";

  // 发送验证码
  static Future<Map> sendVerify([Map<String, dynamic> params]) async {
    EasyLoading.show(status: '发送中...');
    params = {
      'phone': params['phone'],
      'timezone': params['timezone'],
      'flag': params['flag']
    };
    var cellData;
    await DioUtil.instance.requestNetwork(Method.post, ApiUser.SEND_VERIFY,
        queryParameters: params, onSuccess: (response) {
      EasyLoading.dismiss();
      cellData = {"msg": response.message, "ret": 1};
    }, onError: (id, res) {
      EasyLoading.dismiss();
      cellData = {"msg": res, "ret": 0};
    });
    return cellData;
  }

  // 注册
  static Future<Map> register([Map<String, dynamic> params]) async {
    EasyLoading.show(status: '提交中...');
    params = {
      'timezone': params['timezone'],
      'phone': params['phone'],
      'password': params['password'],
      'confirm_password': params['confirm_password'],
      'name': params['name'],
      'email': params['email'],
      'country': params['country'],
      'address': params['detailed_address'],
      'verify_code': params['verify_code'],
    };
    var cellData;
    await DioUtil.instance.requestNetwork(Method.post, ApiUser.REGISTER,
        queryParameters: params, onSuccess: (response) {
      EasyLoading.dismiss();
      cellData = {"msg": response.message, "ret": 1};
    }, onError: (id, res) {
      EasyLoading.dismiss();
      cellData = {"msg": res, "ret": 0};
    });
    return cellData;
  }

  // 找回密码
  static Future<Map> resetPassword([Map<String, dynamic> params]) async {
    EasyLoading.show(status: '...');
    params = {
      'phone': params['phone'],
      'newpassword': params['new_password'],
      'verify_code': params['verify_code']
    };
    var cellData;
    await DioUtil.instance.requestNetwork(Method.post, ApiUser.INIFPWD,
        queryParameters: params, onSuccess: (response) {
      EasyLoading.dismiss();
      cellData = {"msg": response.message, "ret": 1};
    }, onError: (id, res) {
      EasyLoading.dismiss();
      cellData = {"msg": res, "ret": 0};
    });
    return cellData;
  }

  // wx登录
  static Future<Map> openLogin([Map<String, dynamic> params]) async {
    EasyLoading.show(status: '加载中...');
    params = {
      'code': params['code'],
    };
    var cellData;
    await DioUtil.instance.requestNetwork(Method.post, ApiUser.OPENLOGIN,
        queryParameters: params, onSuccess: (response) {
      EasyLoading.dismiss();
      WxBean bean = new WxBean.fromJson(response.data);
      cellData = {"msg": response.message, "ret": 1, "bean": bean};
    }, onError: (id, res) {
      EasyLoading.dismiss();
      cellData = {"msg": res, "ret": 0};
    });
    return cellData;
  }

  // 微信绑定
  static Future<Map> vxBind([Map<String, dynamic> params]) async {
    EasyLoading.show(status: '发送中...');
    params = {
      'timezone': params['timezone'],
      'phone': params['phone'],
      'out_id': params['out_id'],
      'token': params['token'],
      'code': params['code']
    };
    var cellData;
    await DioUtil.instance.requestNetwork(Method.post, ApiUser.BINDLOGIN,
        queryParameters: params, onSuccess: (response) {
      EasyLoading.dismiss();
      WxBean bean = new WxBean.fromJson(response.data);
      cellData = {"msg": response.message, "ret": 1, "bean": bean};
    }, onError: (id, res) {
      EasyLoading.dismiss();
      cellData = {"msg": res, "ret": 0};
    });
    return cellData;
  }

  // 获取图片
  static Future<Map> isReviewing() async {
    Map<String, dynamic> result;
    await DioUtil.instance.requestNetwork(Method.get, ApiUser.ISREVIEWING,
        onSuccess: (response) {
      var responseList = response.data;
      IsReviewing cellData = new IsReviewing.fromJson(responseList);
      result = {"bean": cellData, "ret": 1};
    }, onError: (id, res) {
      result = {"msg": res, "ret": 0};
    });
    return result;
  }
}
