import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class Util {
  static String getTimeDuration(String comTime) {
    var nowTime = DateTime.now();
    var compareTime = DateTime.parse(comTime);
    if (nowTime.isAfter(compareTime)) {
      if (nowTime.year == compareTime.year) {
        if (nowTime.month == compareTime.month) {
          if (nowTime.day == compareTime.day) {
            if (nowTime.hour == compareTime.hour) {
              if (nowTime.minute == compareTime.minute) {
                return '片刻之间';
              }
              return (nowTime.minute - compareTime.minute).toString() + '分钟前';
            }
            return (nowTime.hour - compareTime.hour).toString() + '小时前';
          }
          return (nowTime.day - compareTime.day).toString() + '天前';
        }
        return (nowTime.month - compareTime.month).toString() + '月前';
      }
      return (nowTime.year - compareTime.year).toString() + '年前';
    }
    return 'time error';
  }

  // 数组分组
  static List listToSort({List toSort, int chunk}) {
    var newList = [];
    for (var i = 0; i < toSort.length; i += chunk) {
      var end = i + chunk > toSort.length ? toSort.length : i + chunk;
      newList.add(toSort.sublist(i, end));
    }
    return newList;
  }

  /// 调起拨号页
  static void launchTelURL(String phone) async {
    String url = 'tel:' + phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {}
  }

  static KeyboardActionsConfig getKeyboardActionsConfig(List<FocusNode> list) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: List.generate(
          list.length,
          (i) => KeyboardAction(
                focusNode: list[i],
                closeWidget: const Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: const Text("关闭"),
                ),
              )),
    );
  }

  static void showSnackBar(BuildContext context, String msg,
      [GlobalKey<ScaffoldState> _scaffoldKey]) {
    if (_scaffoldKey != null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("$msg")),
      );
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text("$msg")),
      );
    }
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIos: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Widget buildLoadingWithWiget(
      BuildContext context, Widget widget, isLoading) {
    return Stack(
      children: <Widget>[
        // 显示app
        Offstage(
          child: widget,
          offstage: false,
        ),
        // 显示广告
        Offstage(
          child: Stack(
            children: <Widget>[
              Opacity(
                opacity: 0.5,
                child: Container(color: Colors.black),
              ),
              SpinKitFoldingCube(
                color: Color(WidgetColor.themeColor),
                size: 50.0,
              )
            ],
          ),
          offstage: !isLoading,
        ),
      ],
    );
  }
}
