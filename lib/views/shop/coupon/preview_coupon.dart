import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/shop/coupon/coupon_status_util.dart';
import 'package:E_Sale_Tech/views/shop/shop_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:fluwx/fluwx.dart';
import 'package:provider/provider.dart';
import 'package:E_Sale_Tech/utils/style.dart';

class PreviewCoupon extends StatefulWidget {
  final Map arguments;
  PreviewCoupon({this.arguments});
  @override
  _PreviewCouponState createState() => _PreviewCouponState();
}

class _PreviewCouponState extends State<PreviewCoupon> {
  Map info;
  @override
  void initState() {
    super.initState();
    info = widget.arguments;
  }

  @override
  void dispose() {
    super.dispose();
  }

  String discount(threshold) {
    if (int.parse(threshold) < 1) {
      return '满任意金额';
    } else {
      return '满$threshold';
    }
  }

  immediateRelease() {
    EasyLoading.show(status: '加载中');
    ApiShop.newCoupons(info, (data) {
      if (data.ret == 1) {
        ApiShop.getCouponShareUrl(data.data['id'], (data) {
          EasyLoading.dismiss();
          if (data?.data['share_url'] != null) {
            // isWeChatInstalled.then((installed) {
            //   if (installed) {
            //     String shopName =
            //         Provider?.of<ShopInfoProvider>(context, listen: false)
            //             ?.shopInfo
            //             ?.name;
            //     shareToWeChat(WeChatShareWebPageModel(data.data['share_url'],
            //         title: '${shopName}分享给你一张优惠券，正品好货等你买，超值划算，快来选购吧',
            //         thumbnail:
            //             WeChatImage.asset('assets/images/common/user_logo.png'),
            //         scene: WeChatScene.SESSION));
            //   } else {
            //     Util.showToast("请先安装微信");
            //   }
            // });
            if (ApplicationEvent.event != null) {
              ApplicationEvent.event.fire(ListRefreshEvent('refresh'));
              Routers.pop(context, {'status': 'done'});
            }
          }
        }, (message) => EasyLoading.dismiss());
      }
    }, (message) => EasyLoading.dismiss());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF8F8F8),
        appBar: MyAppBar(
          centerTitle: '预览优惠券',
        ),
        bottomNavigationBar: Material(
          //底部栏整体的颜色
          color: Color(0xffe4382d),
          child: FlatButton(
            child: new Padding(
              padding: new EdgeInsets.all(10),
              child: Text("立即发放",
                  style: TextStyle(
                    fontSize: 18.0, //textsize
                    color: Colors.white, // textcolor
                  )),
            ),
            color: Color(0xffe4382d),
            onPressed: () async {
              immediateRelease();
            },
          ),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment.center,
                width: 300,
                height: 209,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/shop/coupon@3x.png"),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                        transform: Matrix4.translationValues(0, -17, 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: 38.5,
                                height: 39.5,
                                child: CachedNetworkImage(
                                  imageUrl: Provider.of<ShopInfoProvider>(
                                          context,
                                          listen: false)
                                      .shopInfo
                                      .logo,
                                  placeholder: (context, url) =>
                                      const CircleAvatar(
                                    backgroundColor: AppColor.bgGray,
                                    radius: 60,
                                  ),
                                  imageBuilder: (context, image) =>
                                      CircleAvatar(
                                    backgroundImage: image,
                                    radius: 60,
                                  ),
                                )),
                            Container(
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  Provider.of<ShopInfoProvider>(context,
                                          listen: false)
                                      .shopInfo
                                      .name,
                                  style: TextStyle(fontSize: 12),
                                )),
                            Text(info['type'] == 1 ? '抵用券' : '折扣券'),
                          ],
                        )),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text('${info['type'] == 1 ? '￥' : ''}'),
                              Text(
                                '${info['type'] == 1 ? num.parse(info['amount']).toStringAsFixed(2) : '${info['amount']} %'}',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 18.5, bottom: 11.5),
                              child: Text(
                                CouponStatus.scopeFunc(info['scope']) +
                                    (info['type'] == 1
                                        ? discount(info['threshold'])
                                        : '') +
                                    '可用',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              )),
                          Container(
                              width: 194.5,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 2, bottom: 2),
                              decoration: BoxDecoration(
                                  color: Color(0xff1C1717),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                  '有效期：${info['begin_time']}-${info['end_time']}',
                                  style: TextStyle(
                                      color: Color(0xffBDA563),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400))),
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ));
  }
}
