import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:E_Sale_Tech/api/order.dart';
import 'package:E_Sale_Tech/components/input/normal_input.dart';
import 'package:E_Sale_Tech/components/load_image.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/model/goods/goodsDetailInfo.dart';
import 'package:E_Sale_Tech/model/goods/orderPreviewDetail.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
// import 'package:fluwx/fluwx.dart';
import 'package:grouped_checkbox/grouped_checkbox.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class OrderSettleMentPage extends StatefulWidget {
  final Map arguments;
  OrderSettleMentPage({this.arguments});
  @override
  _OrderSettleMentPageState createState() =>
      new _OrderSettleMentPageState(arguments: arguments);
}

class _OrderSettleMentPageState extends State<OrderSettleMentPage>
    with AutomaticKeepAliveClientMixin {
  final Map arguments;
  _OrderSettleMentPageState({this.arguments});
  @override
  bool get wantKeepAlive => true;
  OrderPreviewDetail orderPreviewData;
  Goods specGoods;
  GoodsDetailInfo baseGoods;
  Image imgCode;
  String remarkStr = "";
  int qtyNum; // 下单数量
  int payState; // 1表示帮客户下单   2表示店主自付
  String _newValue = '1';
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final addressTextStyle =
      new TextStyle(color: Color(0xff1C1717), fontSize: 13);
  final warmTextStyle = new TextStyle(color: AppColor.themeRed, fontSize: 11);
  TextEditingController _textCityController = new TextEditingController();
  final FocusNode _nodeCity = FocusNode();
  @override
  void initState() {
    super.initState();
    getPreView();
    // life circle
  }

  getPreView() {
    specGoods = this.arguments["specGoods"];
    baseGoods = this.arguments["baseGoods"];
    qtyNum = this.arguments["num"];
    payState = this.arguments["payState"];
    Map<String, dynamic> paras = {
      "goods_id": specGoods.id.toString(),
      "qty": qtyNum.toString()
    };
    ApiOrder.orderPreview(paras, (data) {
      print(data);
      setState(() {
        isLoading = true;
        orderPreviewData = data;
        payState = this.arguments["payState"];
        _newValue = data.paymentList.first.id.toString();
      });
    }, (message) => null);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: MyAppBar(
          centerTitle: "订单结算",
          isBack: true,
        ),
        bottomNavigationBar: isLoading
            ? Material(
                child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 10,
                        child: Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "实付:",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: AppColor.mainTextColor,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "￥" +
                                    (orderPreviewData.itemFee +
                                            orderPreviewData.taxFee)
                                        .toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: AppColor.textRed,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        )),
                    Expanded(
                      flex: 10,
                      child: Container(
                          color: AppColor.themeRed,
                          child: FlatButton(
                              onPressed: () {
                                // _bottomSheet(context);
                                if (orderPreviewData.address.id == null) {
                                  Util.showToast("请选择送货地址");
                                  return;
                                }
                                placeTheOrder();
                              },
                              child: Text((payState == 1) ? "分享给客户" : "立即下单",
                                  style: TextStyle(fontSize: 13)))),
                    ),
                  ],
                ),
              ))
            : Container(),
        body: isLoading
            ? new GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    GestureDetector(
                        onTap: () async {
                          // 跳转选择地址
                          print("选择地址");
                          // Routers.push('/me/myAddress', context);
                          var s = await Navigator.pushNamed(
                              context, '/me/myAddress',
                              arguments: {"fromOrder": "order"});
                          Address a = s;
                          if (s == null) {
                            return;
                          }
                          setState(() {
                            orderPreviewData.address = a;
                          });
                        },
                        child: Container(
                            color: Colors.white,
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(15),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Expanded(
                                    flex: 2,
                                    child: Image.asset(
                                        'assets/images/shop/location@3x.png',
                                        width: 16,
                                        height: 16)),
                                Expanded(
                                    flex: 16,
                                    child: (orderPreviewData.address != null)
                                        ? Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                      orderPreviewData
                                                          .address.name,
                                                      style: addressTextStyle),
                                                  Text(
                                                      orderPreviewData
                                                          .address.mobile,
                                                      style: addressTextStyle),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                      orderPreviewData
                                                          .address.idCard,
                                                      style: addressTextStyle),
                                                ],
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      orderPreviewData.address
                                                              .provinces +
                                                          orderPreviewData
                                                              .address.address,
                                                      style: addressTextStyle))
                                            ],
                                          )
                                        : Container(
                                            child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text("请选择地址"),
                                            ],
                                          ))),
                                Expanded(
                                  flex: 1,
                                  child:
                                      Icon(Icons.arrow_forward_ios, size: 15.0),
                                ),
                              ],
                            ))),
                    Container(
                        padding: EdgeInsets.all(15),
                        color: Color(0xFFF8F8F8),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '根据中国海关第194号文要求，需要保证订购人身份信息与支付人一致，且真实有效，否则无法购买海外跨境商品。',
                                style: warmTextStyle,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            )
                          ],
                        )),
                    buildMiddleView(),
                  ],
                )))
            : Container());
  }

  placeTheOrder() async {
    Map parames = {
      "address_id": orderPreviewData.address.id,
      "info": [
        {"goods_id": specGoods.id, "qty": qtyNum}
      ],
      "remark": remarkStr,
      "payment": {"type": payState, "id": 1}
    };
    print(parames);
    ApiOrder.placeTheOrder(parames, (data) {
      if (payState == 1) {
        // 客户下单
        Navigator.popAndPushNamed(context, '/shop/orderManager');
        share(data);
        //  Routers.push('/shop/orderManager/logisticsDetail',context);
      } else {
        print(data);
        Map appconfig = data["data"]["app_config"];
        Routers.push("/payMentPage", context,
            {"orderData": orderPreviewData, "appconfig": appconfig});
      }
    }, (message) => null);
  }

  share(Map data) {
    // isWeChatInstalled.then((installed) {
    //   if (installed) {
    //     shareToWeChat(WeChatShareWebPageModel(data["data"]["code_url"],
    //         title: "商品已经帮你选购好了，快来支付吧",
    //         thumbnail: WeChatImage.asset('assets/images/common/user_logo.png'),
    //         scene: WeChatScene.SESSION));
    //   } else {
    //     Util.showToast("请先安装微信");
    //   }
    // });
  }

  Widget buildMiddleView() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10, left: 15, bottom: 10),
            child: Row(
              children: <Widget>[
                Text(
                  orderPreviewData.warehouseName,
                  style: TextStyle(fontSize: 16, color: AppColor.mainTextColor),
                )
              ],
            ),
          ),
          Gaps.line,
          Container(
            height: 120,
            child: buildGoodsInfoView(),
          ),
          Gaps.line,
          Container(
            height: 90,
            child: buildGoodsExpressView(),
          ),
          Gaps.lowBr,
          buildReMarkView(),
          Gaps.lowBr,
          buildBottomView(),
          Gaps.lowBr,
          (payState == 1) ? buildGroupedCheckBox() : Container(),
          Container(
            height: 100,
            color: AppColor.line,
            child: imgCode,
          )
        ],
      ),
    );
  }

  Widget buildGroupedCheckBox() {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          itemCount: orderPreviewData.paymentList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return _returnLietCell(orderPreviewData.paymentList[index]);
          }),
    );
  }

  _returnLietCell(PaymentList payMent) {
    return Center(
      child: RadioListTile<String>(
        value: payMent.id.toString(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              "assets/images/common/weChat.png",
              width: 30,
              height: 30,
            ),
            SizedBox(width: 10),
            Text(payMent.name)
          ],
        ),
        activeColor: Colors.red,
        groupValue: _newValue,
        onChanged: (value) {
          setState(() {
            _newValue = value;
          });
        },
      ),
    );
  }

  Widget buildBottomView() {
    var newRow = Container(
      // height: 120,
      padding: EdgeInsets.only(right: 15, left: 15, top: 25, bottom: 25),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(
                  "商品总价",
                  style: TextStyle(
                      color: AppColor.mainTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("￥" + orderPreviewData?.itemFee?.toStringAsFixed(2)),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(
                  "税费总价",
                  style: TextStyle(
                      color: AppColor.mainTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("￥" + orderPreviewData?.taxFee?.toStringAsFixed(2)),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(
                  "实付总价",
                  style: TextStyle(
                      color: AppColor.mainTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("￥" +
                      (orderPreviewData.itemFee + orderPreviewData.taxFee)
                          .toStringAsFixed(2)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
    return newRow;
  }

  Widget buildReMarkView() {
    var newRow = Container(
      height: 40,
      padding: EdgeInsets.only(right: 15, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                "备注",
                style: TextStyle(
                    color: AppColor.mainTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                child: NormalInput(
                  hintText: "填写给商家的备注",
                  controller: _textCityController,
                  textAlign: TextAlign.right,
                  focusNode: _nodeCity,
                  autoFocus: false,
                  keyboardType: TextInputType.text,
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(_nodeCity);
                  },
                  onChanged: (res) {
                    remarkStr = res;
                  },
                ),
              )),
        ],
      ),
    );
    return newRow;
  }

  Widget buildcouponsView() {
    var newRow = new Container(
      child: Container(
        height: 40,
        padding: EdgeInsets.only(right: 15, left: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Text(
                    "优惠券",
                    style: TextStyle(
                        color: AppColor.mainTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        print("object");
                      },
                      child: Text("-￥10", textAlign: TextAlign.right)),
                  Icon(Icons.arrow_forward_ios, size: 20.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return newRow;
  }

  // 商品配送信息
  Widget buildGoodsExpressView() {
    var newRow = new Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            padding: EdgeInsets.only(right: 15, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    "税费",
                    style: TextStyle(
                        color: AppColor.mainTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("￥" + orderPreviewData?.taxFee?.toStringAsFixed(2)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.only(right: 15, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    "小计",
                    style: TextStyle(
                        color: AppColor.mainTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("￥" +
                        (orderPreviewData.itemFee + orderPreviewData.taxFee)
                            .toStringAsFixed(2)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return newRow;
  }

  Widget buildGoodsInfoView() {
    var newRow = new Container(
      height: 120,
      width: ScreenUtil().screenWidth,
      child: new Row(
        children: <Widget>[
          new Container(
            width: 120,
            height: 120,
            padding: EdgeInsets.all(18),
            child: LoadImage(
              baseGoods.majorThumb.first,
              fit: BoxFit.fitWidth,
              holderImg: "goods/goodDefault@3x",
              format: "png",
            ),
          ),
          new Container(
            width: ScreenUtil().screenWidth - 130,
            height: 90,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new SizedBox(height: 0),
                Expanded(
                    flex: 1,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: Text(
                            baseGoods.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PingFang-SC-Regular',
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 2,
                          ),
                        )
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "规格 :" + specGoods.specName,
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 14,
                              fontFamily: 'PingFang-SC-Regular',
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "× " + qtyNum.toString(),
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 14,
                              fontFamily: 'PingFang-SC-Regular',
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
    return newRow;
  }
}
