import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:E_Sale_Tech/components/click_item.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';

class SetCouponRange extends StatefulWidget {
  @override
  _SetCouponRangeState createState() => _SetCouponRangeState();
}

class _SetCouponRangeState extends State<SetCouponRange> {
  DateTime dateBegin;
  DateTime temporaryDateBegin;
  DateTime dateEnd;
  DateTime temporaryDateEnd;

  final subtitleStyle = TextStyle(color: Color(0xff999999));

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffF8F8F8),
      appBar: MyAppBar(
        centerTitle: '指定适用范围',
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                ClickItem(
                    title: '指定商品',
                    rightWidget: Text('选择商品', style: subtitleStyle),
                    onTap: () {
                      Routers.push('/shop/coupon/setCouponSelectGoods', context)
                          .then((res) {
                        if (res['goods_id'].length > 0) {
                          Routers.pop(context,
                              {'type': 'goods', 'goods_id': res['goods_id']});
                        }
                      });
                    }),
                ClickItem(
                    title: '指定品牌',
                    rightWidget: Text('选择品牌', style: subtitleStyle),
                    onTap: () {
                      Routers.push('/shop/coupon/setCouponSelectBrand', context)
                          .then((res) {
                        if (res['brand_id'].length > 0) {
                          Routers.pop(context,
                              {'type': 'brand', 'brand_id': res['brand_id']});
                        }
                      });
                    }),
                ClickItem(
                    title: '指定分类',
                    rightWidget: Text('选择分类', style: subtitleStyle),
                    onTap: () {
                      Routers.push(
                              '/shop/coupon/setCouponSelectCategory', context)
                          .then((res) {
                        if (res['category_id'].length > 0) {
                          Routers.pop(context, {
                            'type': 'category',
                            'category_id': res['category_id']
                          });
                        }
                      });
                    }),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
