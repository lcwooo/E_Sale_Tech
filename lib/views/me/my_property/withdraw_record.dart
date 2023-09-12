import 'dart:math';

import 'package:E_Sale_Tech/api/me.dart';
import 'package:E_Sale_Tech/components/list_refresh.dart';
import 'package:E_Sale_Tech/model/me/withdraw_list.dart';
import 'package:E_Sale_Tech/utils/click_upload_image.dart';
import 'package:E_Sale_Tech/views/me/my_address/address_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:E_Sale_Tech/components/click_item.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WithdrawRecordPage extends StatefulWidget {
  final Map arguments;

  WithdrawRecordPage({this.arguments});

  @override
  _WithdrawRecordState createState() {
    return _WithdrawRecordState(arguments: arguments);
  }
}

class _WithdrawRecordState extends State<WithdrawRecordPage> {
  final Map arguments;
  int pageIndex = 0;
  var imgList = [
    'assets/images/me/alipay@3x.png',
    'assets/images/me/withdraw_china@3x.png',
    'assets/images/me/withdraw_eu@3x.png',
  ];

  _WithdrawRecordState({this.arguments});

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
        centerTitle: '提现记录',
      ),
      body: Container(
        child: ListRefresh(
          renderItem: _buildListItem,
          more: loadMoreList,
          refresh: loadList,
        ),
      ),
    );
  }

  loadList({String type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> params = {
      "page": (++pageIndex),
    };

    return await ApiMe.withdrawList(params);
  }

  Widget _buildListItem(int index, WithdrawInfo withdrawInfo) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: LeadingIcon(iconPath: this.imgList[withdrawInfo.type - 1]),
          title: Text(
            '提现至--${withdrawInfo.name}',
            style: TextStyle(fontSize: 14.5),
          ),
          subtitle: Text(
            withdrawInfo.createdAt,
            style: TextStyle(fontSize: 9),
          ),
          trailing: Text(withdrawInfo.amount),
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }
}

class LeadingIcon extends StatelessWidget {
  final String iconPath;

  LeadingIcon({this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
      width: 20,
      height: 20,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: Image.asset(this.iconPath).image,
      ),
    );
    return Container(
      child: Container(
        width: 20,
        height: 20,
        child: CircleAvatar(
          backgroundImage: Image.asset(this.iconPath).image,
        ),
      ),
    );
  }
}
