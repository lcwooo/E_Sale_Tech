import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/model/shop/orders_info.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OrderManagerDetail extends StatefulWidget {
  OrderManagerDetail({this.arguments});
  final Map arguments;

  @override
  _OrderManagerDetailState createState() => _OrderManagerDetailState();
}

class _OrderManagerDetailState extends State<OrderManagerDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  OrdersListInfo info = new OrdersListInfo();

  final addressTextStyle =
      new TextStyle(color: Color(0xff1C1717), fontSize: 15);
  final topTextStyle = TextStyle(color: Colors.white, fontSize: 14);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getDetail();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getDetail() {
    EasyLoading.show(status: '加载中...');
    ApiShop.getOrderDetail(widget.arguments['id'], (data) {
      EasyLoading.dismiss();
      setState(() {
        info = data;
      });
    }, (message) => EasyLoading.dismiss());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xffF8F8F8),
        appBar: MyAppBar(
          centerTitle: "订单详情",
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
                height: info?.status == 201 ? 110 : 80,
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage("assets/images/shop/order_detail_bg@3x.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('基本信息', style: topTextStyle),
                        Text(info?.statusName ?? '', style: topTextStyle),
                      ],
                    ),
                    info?.status == 201
                        ? Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('等待付款', style: topTextStyle),
                                Text(
                                    '剩${((info?.ordersPayment?.closeAfter ?? 0) ~/ 60)}分自动关闭',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)),
                              ],
                            ))
                        : SizedBox()
                  ],
                )),
            Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Image.asset('assets/images/shop/location@3x.png',
                            width: 16, height: 16)),
                    Expanded(
                        flex: 8,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      (info?.ordersAddress?.name ?? '') +
                                          '   ' +
                                          (info?.ordersAddress?.mobile ?? ''),
                                      style: addressTextStyle),
                                ),
                              ],
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    info?.ordersAddress != null
                                        ? info.ordersAddress.provinces +
                                            info.ordersAddress.address
                                        : '',
                                    style: addressTextStyle))
                          ],
                        )),
                  ],
                )),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Container(
                          width: 63.5,
                          height: 63.5,
                          margin: EdgeInsets.only(right: 10),
                          child: CachedNetworkImage(
                              imageUrl: (info?.ordersOrderItem?.length ?? 0) > 0
                                  ? info?.ordersOrderItem[0]?.imageUrl
                                  : '',
                              placeholder: (context, url) => const CircleAvatar(
                                    backgroundColor: Color(0xffF8F8F8),
                                  ),
                              imageBuilder: (context, image) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: image,
                                      ),
                                    ),
                                  )))),
                  Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(info?.ordersOrderItem != null
                              ? info?.ordersOrderItem[0].name
                              : ''),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                '规格: ${info?.ordersOrderItem != null ? info?.ordersOrderItem[0]?.specName : ''}',
                                style: TextStyle(
                                    color: Color(0xFF999999), fontSize: 12),
                              )),
                              Text(
                                '   x${info?.ordersOrderItem != null ? info?.ordersOrderItem[0]?.qty : ''}',
                                style: TextStyle(
                                    color: Color(0xFF999999), fontSize: 12),
                              )
                            ],
                          )
                        ],
                      )),
                  Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '￥${info?.ordersOrderItem != null ? info?.ordersOrderItem[0]?.price?.toStringAsFixed(2) : ''}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('商品总价'),
                        Text(
                            '￥${info?.ordersPayment?.itemFee?.toStringAsFixed(2) ?? ''}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('税费'),
                        Text(
                            '￥${info?.ordersPayment?.taxFee?.toStringAsFixed(2) ?? ''}'),
                      ],
                    ),
                    info?.owner == 2
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('优惠金额'),
                              Text(
                                  '￥${info?.ordersPayment?.couponDiscountFee?.toStringAsFixed(2) ?? ''}'),
                            ],
                          )
                        : SizedBox(),
                    Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('总计'),
                            Text(
                                '￥${info?.ordersPayment?.paymentFee?.toStringAsFixed(2) ?? ''}',
                                style: TextStyle(color: Color(0xffE45151))),
                          ],
                        ))
                  ],
                )),
            Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('成本价'),
                        Text(
                            '￥${info?.ordersPayment?.costPrice?.toStringAsFixed(2) ?? ''}'),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('我的收益'),
                            Text(
                                '￥${info?.ordersPayment?.profit?.toStringAsFixed(2) ?? ''}',
                                style: TextStyle(color: Color(0xffE45151))),
                          ],
                        ))
                  ],
                )),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 15.5),
                              child: Text(
                                '订单编号',
                                style: TextStyle(color: Color(0xff999999)),
                              )),
                          GestureDetector(
                              onTap: () {
                                ClipboardData data =
                                    new ClipboardData(text: info?.orderSn);
                                Clipboard.setData(data);
                                Util.showToast("订单复制成功");
                              },
                              child: Text('${info?.orderSn ?? ''}')),
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 15.5),
                              child: Text(
                                '下单时间',
                                style: TextStyle(color: Color(0xff999999)),
                              )),
                          Text('${info?.createdAt ?? ''}'),
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 15.5),
                              child: Text(
                                '付款时间',
                                style: TextStyle(color: Color(0xff999999)),
                              )),
                          Text('${info?.paidAt ?? ''}'),
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 15.5),
                              child: Text(
                                '完成时间',
                                style: TextStyle(color: Color(0xff999999)),
                              )),
                          Text('${info?.signedAt ?? ''}'),
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 15.5),
                              child: Text(
                                '支付方式',
                                style: TextStyle(color: Color(0xff999999)),
                              )),
                          Text('${info?.ordersPayment?.paymentMethod ?? ''}'),
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 15.5),
                              child: Text(
                                '订单备注',
                                style: TextStyle(color: Color(0xff999999)),
                              )),
                          Expanded(child: Text('${info?.remark ?? ''}')),
                        ],
                      )),
                ],
              ),
            ),
            // 未付款 200 到 299   取消订单 600 到 699 不能查看物流
            !(((info?.status ?? 0) >= 200 && info.status <= 299) ||
                    ((info?.status ?? 0) >= 600 && info.status <= 699))
                ? Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('物流信息')),
                        Container(
                            margin: EdgeInsets.only(bottom: 5, top: 5),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(right: 15.5),
                                    child: Text(
                                      '快递公司',
                                      style:
                                          TextStyle(color: Color(0xff999999)),
                                    )),
                                Text('${info?.ordersExpress?.name ?? ''}'),
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(right: 15.5),
                                    child: Text(
                                      '物流单号',
                                      style:
                                          TextStyle(color: Color(0xff999999)),
                                    )),
                                GestureDetector(
                                    onTap: () {
                                      ClipboardData data = new ClipboardData(
                                          text: info?.ordersExpress?.number);
                                      Clipboard.setData(data);
                                      Util.showToast("单号复制成功");
                                    },
                                    child: Text(
                                        '${info?.ordersExpress?.number ?? ''}')),
                              ],
                            )),
                      ],
                    ))
                : SizedBox(),
            // 未付款 200 到 299   取消订单 600 到 699 不能查看物流
            !(((info?.status ?? 0) >= 200 && info.status <= 299) ||
                    ((info?.status ?? 0) >= 600 && info.status <= 699))
                ? Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('物流详情'),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            width: 104,
                            height: 24,
                            child: RaisedButtonCustom(
                                onPressed: () {
                                  Routers.push(
                                      '/shop/orderManager/logisticsDetail',
                                      context,
                                      {'id': info?.id});
                                },
                                shape: const RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: AppColor.themeRed,
                                        width: 1.0,
                                        style: BorderStyle.solid),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                textColor: AppColor.themeRed,
                                color: Colors.white,
                                txt: '查看详情',
                                padding: EdgeInsets.only(left: 0, right: 0)))
                      ],
                    ))
                : SizedBox(),
          ],
        )));
  }
}
