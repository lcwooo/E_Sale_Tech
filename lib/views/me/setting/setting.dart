import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/model/index.dart';
import 'package:E_Sale_Tech/model/shop/shop_info.dart';
import 'package:E_Sale_Tech/utils/click_upload_image.dart';
import 'package:E_Sale_Tech/utils/localstorage.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/shop/shop_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

import 'package:E_Sale_Tech/components/click_item.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'android_intent.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String version = "";

  final subtitleStyle = TextStyle(color: Color(0xff999999));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffF8F8F8),
      appBar: MyAppBar(
        centerTitle: '设置',
      ),
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Gaps.vGap5,
                    ClickItem(
                      onTap: () {
                        Routers.push('/me/setting/changePwd', context);
                      },
                      title: '修改密码',
                    ),
                    ClickItem(
                      onTap: () {},
                      hideArrow: true,
                      title: '消息通知',
                      rightWidget: Text('请前往设置中操作', style: subtitleStyle),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (Platform.isAndroid) {
                    print("isAndroid");
                    AndroidIntent intent = AndroidIntent(
                      action: 'android.settings.SETTINGS',
                    );
                    await intent.launch();
                  } else {
                    print("isIos");
                  }
                },
                child: Container(
                  height: 100,
                  padding: EdgeInsets.only(top: 30),
                  color: Colors.transparent,
                  width: ScreenUtil().screenWidth * 0.8,
                  child: Text(
                    '关闭或开启消息通知功能，请在手机的“设置”-“通知” 功能中，找到应用程序“E Sale Tech”更改',
                    style: TextStyle(
                      fontSize: 12,
                      height: 2,
                      color: Color(0xff999999),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Gaps.vGap5,
                    ClickItem(
                      onTap: () {
                        showClearCacheSheet(context);
                      },
                      title: '清除缓存',
                      // rightWidget: Text('0M', style: subtitleStyle)
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Container(
            width: 187,
            padding: EdgeInsets.only(bottom: 39),
            child: RaisedButtonCustom(
              shape: Border.all(
                // 设置边框样式
                color: AppColor.themeRed,
                width: 1.0,
                style: BorderStyle.solid,
              ),
              textColor: AppColor.themeRed,
              color: AppColor.white,
              txt: '退出登录',
              onPressed: () {
                showActionSheet(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void showActionSheet(context) {
    showCupertinoDialog<int>(
        context: context,
        builder: (cxt) {
          return CupertinoAlertDialog(
            title: Text("提示"),
            content: Text('确认退出登录吗？'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(cxt, 2);
                },
              ),
              CupertinoDialogAction(
                child: Text("确认"),
                onPressed: () {
                  Navigator.pop(cxt, 1);
                },
              ),
            ],
          );
        }).then((value) {
      if (value == 1) {
        LocalStorage.clearToken();
        LocalStorage.saveCompleteInfo(false);
        Provider.of<Model>(context, listen: false).setToken('');
        Provider.of<ShopInfoProvider>(context, listen: false)
            .setShopInfo(new ShopInfo());
        ApplicationEvent.event.fire(new HomeRefresh());
        Routers.pop(context);
        ApplicationEvent.event.fire(ChangeKeepAlivePageIndex(pageName: 'home'));
      }
    });
  }

  void showClearCacheSheet(context) {
    showCupertinoDialog<int>(
        context: context,
        builder: (cxt) {
          return CupertinoAlertDialog(
            title: Text("提示"),
            content: Text('确认清除吗？'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(cxt, 2);
                },
              ),
              CupertinoDialogAction(
                child: Text("确认"),
                onPressed: () {
                  DefaultCacheManager().emptyCache();
                  Navigator.pop(cxt, 1);
                },
              ),
            ],
          );
        }).then((value) async {
      if (value == 1) {
        Util.showToast('清除成功');
      }
    });
  }
}
