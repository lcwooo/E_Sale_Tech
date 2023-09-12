import 'package:E_Sale_Tech/api/log_util.dart';
import 'package:E_Sale_Tech/model/goods/orderPreviewDetail.dart';
import 'package:E_Sale_Tech/model/me/agent_info.dart';
import 'package:E_Sale_Tech/model/me/agent_invoice_list.dart';
import 'package:E_Sale_Tech/model/me/agent_msg_list.dart';
import 'package:E_Sale_Tech/model/me/withdraw_list.dart';
import 'package:E_Sale_Tech/api/http.dart';
import 'dart:convert' as convert;

import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef OnSuccess<T>(T data);

typedef OnFail(String message);

class ApiMe {
  static const String SHOP_INFO = 'properties/info';
  static const String APPLY_WITHFRAW = 'withdraws';
  static const String SHOP_ADDRESSES_LIST = 'addresses';
  static const String GET_AGENT_INFO = 'auth/info';
  static const String UPDATE_AGENT_INFO = 'auth/info';
  static const String UPDATE_AGENT_PWD = 'auth/change-pwd';
  static const String UPDATE_AGENT_AVATAR = 'shop/apply/avatar';
  static const String INVOICE_LIST = 'invoices';
  static const String MSG_LIST = 'messages';
  static const String CUSTOMER_SERVICE = 'customer-service';
  static const String MESSAGES_IS_READ = 'messages/:id/read';
  static const String MESSAGESOperation = 'messages/:id';
  static const String GETQAList = 'question-and-answer';

  // 资产列表
  static Future<Map> getProperties([Map<String, dynamic> params]) async {
    Map<String, dynamic> result;

    await DioUtil.instance.requestNetwork(Method.get, ApiMe.SHOP_INFO,
        queryParameters: params ?? {}, onSuccess: (response) {
      result = response.data;
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  static Future sendIsMessage(
      int id, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(
        Method.put, ApiMe.MESSAGES_IS_READ.replaceAll(':id', id.toString()),
        onSuccess: (response) {
      onSuccess(response);
    }, onError: (id, res) {
      onFail(res);
    });
  }

  // 申请提现接口
  static Future<Map> applyWithdraw([Map<String, dynamic> params]) async {
    Map<String, dynamic> result;

    await DioUtil.instance.requestNetwork(Method.post, ApiMe.APPLY_WITHFRAW,
        queryParameters: params ?? {}, onSuccess: (response) {
      result = {"ret": response.ret, "msg": response.message};
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  // 提现列表接口
  static Future<Map> withdrawList([Map<String, dynamic> params]) async {
    Map result;
    var page = (params is Map) ? params['page'] : 1;
    params = {
      'page': page,
      'size': 10,
    };
    await DioUtil.instance.requestNetwork(Method.get, ApiMe.APPLY_WITHFRAW,
        queryParameters: params ?? {}, onSuccess: (response) {
      var list = response.data as List;
      List<WithdrawInfo> listData = [];
      list.forEach((item) {
        listData.add(WithdrawInfo.fromJson(item));
      });
      result = {
        "list": listData,
        'total': response.meta['last_page'],
        'pageIndex': page
      };
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  // 客服中心
  static Future<String> getCustomerService(
      [Map<String, dynamic> params]) async {
    String result;

    await DioUtil.instance.requestNetwork(Method.get, ApiMe.CUSTOMER_SERVICE,
        queryParameters: params ?? {}, onSuccess: (response) {
      result = response.data as String;
      Log.i('结果为:' + result);
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  // 地址列表
  static Future<Map> getAddresses([Map<String, dynamic> params]) async {
    var page = (params is Map) ? params['page'] : 1;
    params['page'] = page;
    Map result;

    await DioUtil.instance.requestNetwork(Method.get, ApiMe.SHOP_ADDRESSES_LIST,
        queryParameters: params ?? {}, onSuccess: (response) {
      var list = response.data as List;
      List<Address> msgList = [];
      list.forEach((msg) {
        msgList.add(Address.fromJson(msg));
      });
      result = {
        "list": msgList,
        'total': response.meta['last_page'],
        'pageIndex': page
      };
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  // 新增地址
  static Future<Map> addAddresses([Map<String, dynamic> params]) async {
    Map result;
    await DioUtil.instance.requestNetwork(
        Method.post, ApiMe.SHOP_ADDRESSES_LIST, queryParameters: params ?? {},
        onSuccess: (response) {
      result = {
        'ret': response.ret,
        'msg': response.message,
      };
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  // 修改地址
  static Future<Map> updateAddresses([Map<String, dynamic> params]) async {
    Map result;
    await DioUtil.instance.requestNetwork(
        Method.put, ApiMe.SHOP_ADDRESSES_LIST + '/' + params['id'].toString(),
        queryParameters: params ?? {}, onSuccess: (response) {
      result = {
        'ret': response.ret,
        'msg': response.message,
      };
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  // 删除地址
  static Future<Map> deleteAddresses([Map<String, dynamic> params]) async {
    Map result;

    await DioUtil.instance.requestNetwork(Method.delete,
        ApiMe.SHOP_ADDRESSES_LIST + '/' + params['id'].toString(),
        queryParameters: params ?? {}, onSuccess: (response) {
      result = {
        'ret': response.ret,
        'msg': response.message,
      };
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  // 代购信息
  static Future<AgentInfo> getAgentInfo([Map<String, dynamic> params]) async {
    AgentInfo result;

    await DioUtil.instance.requestNetwork(Method.get, ApiMe.GET_AGENT_INFO,
        queryParameters: params ?? {}, onSuccess: (response) {
      result = AgentInfo.fromJson(response.data);
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  // 更新代购信息
  static Future<int> updateAgentInfo([Map<String, dynamic> params]) async {
    int result;

    await DioUtil.instance.requestNetwork(Method.put, ApiMe.UPDATE_AGENT_INFO,
        queryParameters: params ?? {}, onSuccess: (response) {
      result = response.ret;
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  // 更改密码
  static Future<int> updatePwd([Map<String, dynamic> params]) async {
    int result;
    await DioUtil.instance.requestNetwork(Method.post, ApiMe.UPDATE_AGENT_PWD,
        queryParameters: params ?? {}, onSuccess: (response) {
      result = response.ret;
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  // 更改头像
  static Future updateAvatar(
      Map<String, dynamic> params, OnSuccess onSuccess) async {
    await DioUtil.instance.requestNetwork(
        Method.post, ApiMe.UPDATE_AGENT_AVATAR, queryParameters: params ?? {},
        onSuccess: (response) {
      onSuccess(response.data);
    }, onError: (id, res) {
      print(res);
    });
  }

  // 发票列表
  static Future<Map> invoiceList([Map<String, dynamic> params]) async {
    var page = (params is Map) ? params['page'] : 1;
    params = {
      'page': page,
      'size': 10,
    };
    Map result;
    await DioUtil.instance.requestNetwork(Method.get, ApiMe.INVOICE_LIST,
        queryParameters: params ?? {}, onSuccess: (response) {
      var list = response.data as List;
      List<AgentInvoiceList> invoiceList = [];
      list.forEach((invoice) {
        invoiceList.add(AgentInvoiceList.fromJson(invoice));
      });

      result = {
        "list": invoiceList,
        'total': response.meta['last_page'],
        'pageIndex': page
      };
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  // 消息列表
  static Future<Map> msgList([Map<String, dynamic> params]) async {
    var page = (params is Map) ? params['page'] : 1;
    int read = params['read'];
    params = {
      'page': page,
      'size': 10,
      'read': read,
    };
    Map result;
    await DioUtil.instance.requestNetwork(Method.get, ApiMe.MSG_LIST,
        queryParameters: params ?? {}, onSuccess: (response) {
      var list = response.data as List;
      // String jsonStr = convert.jsonEncode(list.first);
      List<AgentMsgList> msgList = [];
      list.forEach((msg) {
        msgList.add(AgentMsgList.fromJson(msg));
      });
      result = {
        "list": msgList,
        'total': response.meta['last_page'],
        'pageIndex': page
      };
    }, onError: (id, res) {
      print(res);
    });
    return result;
  }

  static Future getQAList(OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(Method.get, ApiMe.GETQAList,
        params: null, onSuccess: (response) {
      var responseList = response.data;
      onSuccess(responseList);
    }, onError: (id, msg) {
      onFail(msg);
    });
  }

  static Future deleteMessage(
      int id, OnSuccess onSuccess, OnFail onFail) async {
    EasyLoading.show(status: '正在删除');
    await DioUtil.instance.requestNetwork(
        Method.delete, ApiMe.MESSAGESOperation.replaceAll(':id', id.toString()),
        params: null, onSuccess: (response) {
      EasyLoading.dismiss();
      var map = {
        'ret': response.ret,
        'msg': response.message,
        'data': response.data,
      };
      onSuccess(map);
    }, onError: (id, msg) {
      EasyLoading.dismiss();
      onFail(msg);
    });
  }
}
