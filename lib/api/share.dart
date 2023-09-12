import 'package:E_Sale_Tech/api/http.dart';
import 'package:E_Sale_Tech/api/user.dart';
import 'package:E_Sale_Tech/model/Share/articles_bean.dart';
import 'package:E_Sale_Tech/model/Share/pictures.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef OnSuccess<T>(T data);

typedef OnFail(String message);

class ApiShare {
  static const String ARTICLES = 'articles';
  static const String PICTURES = 'index/pictures';

  // 发送验证码
  static Future<Map> getArticles([Map<String, dynamic> params]) async {
    params = {'keyword': params['keyword'],'page': params['page'],};
    List<ArticlesBean> list = [];
    Map<String, dynamic> result;
    await DioUtil.instance.requestNetwork(Method.get, ApiShare.ARTICLES,
        queryParameters: params, onSuccess: (response) {
      var responseList = response.data;
      for (int i = 0; i < responseList.length; i++) {
        try {
          ArticlesBean cellData = new ArticlesBean.fromJson(responseList[i]);
          list.add(cellData);
        } catch (e) {
          print(e);
        }
      }
      result = {"list": list, "ret": 1};
    }, onError: (id, res) {
      result = {"msg": res, "ret": 0};
    });
    return result;
  }


  // 分享统计
  static Future<Map> share(String id) async {
    List<ArticlesBean> list = [];
    String url = 'articles/$id/share';
    Map<String, dynamic> result;
    await DioUtil.instance.requestNetwork(Method.post, url, onSuccess: (response) {
          var responseList = response.data;
          for (int i = 0; i < responseList.length; i++) {
            try {
              ArticlesBean cellData = new ArticlesBean.fromJson(responseList[i]);
              list.add(cellData);
            } catch (e) {
              print(e);
            }
          }
          result = {"list": list, "ret": 1};
        }, onError: (id, res) {
          result = {"msg": res, "ret": 0};
        });
    return result;
  }

  // 获取图片
  static Future<Map> pictures() async {
    List<ArticlesBean> list = [];
    Map<String, dynamic> result;
    await DioUtil.instance.requestNetwork(Method.get, ApiShare.PICTURES, onSuccess: (response) {
      var responseList = response.data;
      Pictures cellData = new Pictures.fromJson(responseList);
      result = {"bean": cellData, "ret": 1};
    }, onError: (id, res) {
      result = {"msg": res, "ret": 0};
    });
    return result;
  }
}
