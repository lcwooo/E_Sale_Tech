import 'dart:convert';

import 'package:E_Sale_Tech/api/log_util.dart';
import 'package:E_Sale_Tech/api/me.dart';
import 'package:E_Sale_Tech/utils/click_upload_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:E_Sale_Tech/components/click_item.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyProperty extends StatefulWidget {
  @override
  _MyPropertyState createState() => _MyPropertyState();
}

class _MyPropertyState extends State<MyProperty> {
  String version = "";
  String waitSettle = "*";
  String waitWithdraw = "*";
  String withdraw = "*";
  String paidAmount = "*";
  String withdrawing = "*";

  final subtitleStyle = TextStyle(color: Color(0xff999999));

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    var properties = await ApiMe.getProperties();
    // Log.e("拉取结果完成" + jsonEncode(properties));
    this.setState(() {
      this.waitSettle = properties['wait_settle'].toString() ?? '*';
      this.waitWithdraw = properties['wait_withdraw'].toString() ?? '*';
      this.withdraw = properties['withdraw'].toString() ?? '*';
      this.withdrawing = properties['withdrawing'].toString() ?? '*';
      this.paidAmount = properties['paid_amount'].toString() ?? '*';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffF8F8F8),
      appBar: MyAppBar(
        centerTitle: S.of(context).myProperty,
      ),
      bottomNavigationBar: Material(
        //底部栏整体的颜色
        color: Color(0xffe4382d),
        child: TextButton(
          child: new Padding(
            padding: new EdgeInsets.all(10),
            child: Text("提现",
                style: TextStyle(
                  fontSize: 18.0, //textsize
                  color: Colors.white, // textcolor
                )),
          ),
          onPressed: () {
            Routers.push("/me/myProperty/applyWithdraw", context);
          },
        ),
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
                        title: '待结算收益(RMB)',
                        rightWidget:
                            Text(this.waitSettle, style: subtitleStyle)),
                    ClickItem(
                      title: '可提现收益(RMB)',
                      rightWidget:
                          Text(this.waitWithdraw, style: subtitleStyle),
                    ),
                    ClickItem(
                      title: '提现中收益(RMB)',
                      rightWidget: Text(this.withdrawing, style: subtitleStyle),
                    ),
                    ClickItem(
                      title: '已提现收益(RMB)',
                      rightWidget: Text(this.withdraw, style: subtitleStyle),
                    ),
                    ClickItem(
                      title: '已支付费用(RMB)',
                      rightWidget: Text(this.paidAmount, style: subtitleStyle),
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
        ],
      ),
    );
  }
}
