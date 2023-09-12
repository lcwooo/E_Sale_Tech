import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/components/skeloton/skeleton.dart';

class ShopTemplateGoodsStyle extends StatefulWidget {
  final Map arguments;
  ShopTemplateGoodsStyle({this.arguments});
  @override
  _ShopTemplateGoodsStyleState createState() => _ShopTemplateGoodsStyleState();
}

class _ShopTemplateGoodsStyleState extends State<ShopTemplateGoodsStyle> {
  final subtitleStyle = TextStyle(color: Color(0xff999999));

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget doubleArrange(
      {height = 85.5, imgScale = 2.0, left = 0.0, right = 0.0}) {
    return Expanded(
        flex: 5,
        child: Container(
          height: height,
          margin: EdgeInsets.fromLTRB(left, 0.0, right, 0.0),
          color: Color(0xffF8F8F8),
          child: Image.asset('assets/images/shop/white_gift@3x.png',
              width: 12, scale: imgScale, height: 12),
        ));
  }

  Widget singleArrange({height = 85.5, left = 0.0, right = 0.0}) {
    return Expanded(
        flex: 5,
        child: Container(
          height: height,
          margin: EdgeInsets.only(left: left),
          child: Column(
            children: <Widget>[
              Skeleton.skeletonTitle(right: 0.0, left: 0.0),
              Skeleton.skeletonSubscription(left: 0.0, right: 0.0),
              Skeleton.skeletonSubscription(left: 0.0, right: 0.0),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: MyAppBar(centerTitle: '选择商品列表样式'),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.fromLTRB(12.5, 12.5, 12.5, 0),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 5,
                child: Container(
                    height: 275,
                    margin: EdgeInsets.only(left: 6.25),
                    padding: EdgeInsets.only(left: 5, right: 5),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('双列小图')),
                        Row(
                          children: <Widget>[
                            doubleArrange(
                                imgScale: 3.0, height: 60.5, right: 2.5),
                            doubleArrange(
                                imgScale: 3.0, height: 60.5, left: 2.5),
                          ],
                        ),
                        Skeleton.skeletonSubscription(left: 2.5, right: 50.0),
                        Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Skeleton.skeletonSubscription()),
                        Row(
                          children: <Widget>[
                            doubleArrange(
                                imgScale: 3.0, height: 60.5, right: 2.5),
                            doubleArrange(
                                imgScale: 3.0, height: 61.5, left: 2.5),
                          ],
                        ),
                        Skeleton.skeletonSubscription(left: 2.5, right: 50.0),
                        Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Skeleton.skeletonSubscription()),
                        widget.arguments['type'] == '2'
                            ? RaisedButtonCustom(
                                onPressed: () {
                                  ApiShop.setShopTemplate({
                                    'template_id': widget.arguments['id'],
                                    'product_list': '1'
                                  }, (data) {
                                    if (data.ret == 1) {
                                      Util.showToast('设置成功');
                                      Routers.pop(context,
                                          {'event': 'success', 'value': '1'});
                                    }
                                  }, (message) => null);
                                },
                                padding: EdgeInsets.only(left: 20, right: 20),
                                elevation: 0,
                                shape: Border.all(
                                  // 设置边框样式
                                  color: Color(0xffCCCCCC),
                                  width: 0.5,
                                  style: BorderStyle.solid,
                                ),
                                splashColor: Colors.white,
                                txt: '使用此模板',
                                color: Colors.white,
                                textColor: Color(0xff1C1717),
                              )
                            : Container(
                                margin: EdgeInsets.all(13),
                                child: Text(
                                  '正在使用',
                                  style: TextStyle(color: Color(0xffe4382d)),
                                ))
                      ],
                    ))),
            Expanded(flex: 5, child: Container()),
            // Expanded(
            //   flex: 5,
            //   child: Container(
            //       height: 275,
            //       margin: EdgeInsets.only(right: 6.25),
            //       padding: EdgeInsets.only(left: 5, right: 5),
            //       color: Colors.white,
            //       child: Column(
            //         children: <Widget>[
            //           Padding(
            //               padding: EdgeInsets.only(top: 5, bottom: 5),
            //               child: Text('最新商品')),
            //           Container(
            //               margin: EdgeInsets.only(bottom: 5),
            //               child: Row(
            //                 children: <Widget>[
            //                   doubleArrange(right: 2.5),
            //                   singleArrange(left: 2.5)
            //                 ],
            //               )),
            //           Container(
            //               margin: EdgeInsets.only(bottom: 5),
            //               child: Row(
            //                 children: <Widget>[
            //                   doubleArrange(right: 2.5),
            //                   singleArrange(left: 2.5)
            //                 ],
            //               )),
            //           widget.arguments['type'] == '1'
            //               ? RaisedButtonCustom(
            //                   onPressed: () {
            //                     ApiShop.setShopTemplate({
            //                       'template_id': widget.arguments['id'],
            //                       'product_list': '2'
            //                     }, (data) {
            //                       if (data.ret == 1) {
            //                         Util.showToast('设置成功');
            //                         Routers.pop(context,
            //                             {'event': 'success', 'value': '2'});
            //                       }
            //                     }, (message) => null);
            //                   },
            //                   padding: EdgeInsets.only(left: 20, right: 20),
            //                   elevation: 0,
            //                   shape: Border.all(
            //                     // 设置边框样式
            //                     color: Color(0xffCCCCCC),
            //                     width: 0.5,
            //                     style: BorderStyle.solid,
            //                   ),
            //                   splashColor: Colors.white,
            //                   txt: '使用此模板',
            //                   color: Colors.white,
            //                   textColor: Color(0xff1C1717),
            //                 )
            //               : Container(
            //                   margin: EdgeInsets.all(13),
            //                   child: Text(
            //                     '正在使用',
            //                     style: TextStyle(color: Color(0xffe4382d)),
            //                   ))
            //         ],
            //       )),
            // ),
            // 暂时隐藏
          ],
        ),
      )),
    );
  }
}
