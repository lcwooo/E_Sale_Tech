import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/model/shop/shop_preferential_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DiscountStore extends StatefulWidget {
  @override
  _DiscountStoreState createState() => _DiscountStoreState();
}

class _DiscountStoreState extends State<DiscountStore> {
  final TextStyle txtStyle = TextStyle(color: Color(0xffe4382d));
  ShopPreferential info = new ShopPreferential();
  bool isRequestFinish = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      EasyLoading.show(status: '加载中...');
      ApiShop.getShopPreferential((data) {
        EasyLoading.dismiss();
        setState(() {
          info = data;
          isRequestFinish = true;
        });
      }, (message) => EasyLoading.dismiss());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void submitApplication(type) {
    ApiShop.getShopPreferentialStatus(type, (data) {
      if (data.ret == 1) {
        createSimpleDialog();
      }
    }, (message) => null);
  }

  void createSimpleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          titlePadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          title: Column(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                transform: Matrix4.translationValues(0, -25, 0),
                decoration: BoxDecoration(
                    color: Color(0xffe4382d),
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  Icons.access_time,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 30, bottom: 20),
                  transform: Matrix4.translationValues(0, -35, 0),
                  child: Text('提交成功，等待审核',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400))),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffF8F8F8),
      appBar: MyAppBar(
        centerTitle: '店铺优惠',
      ),
      bottomNavigationBar: Material(
        //底部栏整体的颜色
        child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButtonCustom(
                    onPressed: () {
                      submitApplication(1);
                    },
                    shape: Border.all(
                      // 设置边框样式
                      color: AppColor.themeRed,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                    textColor: AppColor.themeRed,
                    color: Colors.white,
                    txt: '申请升级',
                    padding: EdgeInsets.only(left: 50, right: 50)),
                RaisedButtonCustom(
                    onPressed: () {
                      submitApplication(2);
                    },
                    shape: Border.all(
                      // 设置边框样式
                      color: AppColor.themeRed,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                    textColor: AppColor.themeRed,
                    color: Colors.white,
                    txt: '申请返现',
                    padding: EdgeInsets.only(left: 50, right: 50)),
              ],
            )),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('上月销售额'),
                  Text(info?.lastMonth?.toStringAsFixed(2)),
                ],
              )),
          Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('本月销售额'),
                  Text(info?.currentMonth?.toStringAsFixed(2)),
                ],
              )),
          Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: isRequestFinish
                  ? Row(
                      children: <Widget>[
                        Icon(Icons.access_time, color: Color(0xffe4382d)),
                        ((info?.currentMonth ?? 0) < info?.target)
                            ? Row(
                                children: <Widget>[
                                  Text('还需 ', style: txtStyle),
                                  Text(
                                    ((info?.target ?? 0) - info?.currentMonth)
                                        ?.toStringAsFixed(2),
                                    style: TextStyle(color: Color(0xffFF6161)),
                                  ),
                                  Text(' 元即可达到目标', style: txtStyle),
                                ],
                              )
                            : Text('已达成本月目标'),
                        Expanded(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Text(info?.target?.toStringAsFixed(2),
                                    style: txtStyle))),
                      ],
                    )
                  : Text('')),
          Container(
            padding: EdgeInsets.all(15),
            child: Text(
              info?.specification,
              style: TextStyle(fontSize: 14, letterSpacing: 1.5),
            ),
          )
        ],
      )),
    );
  }
}
