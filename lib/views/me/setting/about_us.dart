import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/model/index.dart';
import 'package:E_Sale_Tech/model/shop/shop_info.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/localstorage.dart';
import 'package:E_Sale_Tech/views/shop/shop_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutUs extends StatelessWidget {
  String version = "";

  final subtitleStyle = TextStyle(color: Color(0xff999999));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.white,
      appBar: MyAppBar(
        centerTitle: '关于',
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(height: 2),
            //标题
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                '资源整合，E路成功',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            //内容
            Container(
                width: ScreenUtil().screenWidth * 0.6,
                margin: EdgeInsets.only(top: 0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'E-sale Tech 是荷兰United Homes公司运营的一家全球进口商品供销平台。E-sale Tech为中小型商家提供优质海外正品货源，我们帮助每一位重视产品和服务的商家私有化顾客资产、拓展互联网客群、提高经营效率，全面助力商家成功。为您提供全方位的仓储、物流、供销一站式服务。',
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                      ),
                      strutStyle:
                          StrutStyle(forceStrutHeight: true, height: 1.7),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        child: Text(
                          '我们的愿景： 成为全球一流中小型最值得信任的进口商家服务平台。',
                          style: TextStyle(
                            letterSpacing: 1,
                          ),
                        )),
                    Text('欢迎提出各种建议和反馈~',
                        style: TextStyle(
                          letterSpacing: 1,
                        ))
                  ],
                )),
            Expanded(
              child: Container(),
            ),
            GestureDetector(
              onDoubleTap: () async {
                // setURLType();
                await LocalStorage.getEnvironment().then((value) {
                  // production
                  if (value == 'dev') {
                    LocalStorage.setEnvironment("production");
                  } else {
                    LocalStorage.setEnvironment("dev");
                  }
                  LocalStorage.clearToken();
                  LocalStorage.saveCompleteInfo(false);
                  Provider.of<Model>(context, listen: false).setToken('');
                  Provider.of<ShopInfoProvider>(context, listen: false)
                      .setShopInfo(new ShopInfo());
                  ApplicationEvent.event.fire(new HomeRefresh());
                  Routers.pop(context);
                  ApplicationEvent.event
                      .fire(ChangeKeepAlivePageIndex(pageName: 'home'));
                  Navigator.pop(context);
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 8),
                child: Text(
                  '版本号v1.0.6',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xffcccccc),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: Text(
                'Copyright ${DateTime.now().year} E-Sale Tech',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xffcccccc),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Text(
                'Power by EUTechne B.V. NLE-TECH',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xffcccccc),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
