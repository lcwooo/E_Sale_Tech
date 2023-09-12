import 'package:E_Sale_Tech/api/goods.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/components/input/input_text_item.dart';
import 'package:E_Sale_Tech/components/input/normal_input.dart';
import 'package:E_Sale_Tech/components/load_image.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/model/goods/goodsDetailInfo.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:flutter_screenutil/screenutil.dart' as ScreenUtil;

class EditGoodsPricePage extends StatefulWidget {
  EditGoodsPricePage({this.arguments});
  final Map arguments;
  @override
  _EditGoodsPricePageState createState() =>
      new _EditGoodsPricePageState(arguments: arguments);
}

class _EditGoodsPricePageState extends State<EditGoodsPricePage>
    with AutomaticKeepAliveClientMixin {
  final Map arguments;
  _EditGoodsPricePageState({this.arguments});
  @override
  bool get wantKeepAlive => true;

  bool isLoading = false;

  bool firstState = true;
  bool secondState = false;

  GoodsDetailInfo goodInfo;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool autoFocus = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  void getData() async {
    isLoading = true;
    EasyLoading.show(status: '加载商品...');
    ApiGoods.goodsDetail(this.arguments, (data) {
      EasyLoading.dismiss();
      setState(() {
        goodInfo = data;
      });
    }, (message) => EasyLoading.dismiss());
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
          centerTitle: S.of(context).editPrice,
          isBack: true,
          actionName: S.of(context).save,
          onPressed: () async {
            // Routers.pop(context);
            for (Goods item in goodInfo.goods) {
              if (item.isShow == 1) {
                if (item.totalPrice == 0) {
                  Util.showToast('您还有规格没设置利润');
                }
              }
            }
            Map result = await ApiGoods.editGoodsPrice({"goodsInfo": goodInfo});
            if (result["ret"] == 1) {
              EasyLoading.showSuccess(result["msg"]);
              ApplicationEvent.event
                  .fire(new RefreshGoodDetailAfterEditPrice());
              Routers.pop(context);
            }
            print("sdasadasdas");
          },
        ),
        bottomNavigationBar: Material(
          //底部栏整体的颜色
          color: AppColor.themeRed,
          child: FlatButton(
            child: new Padding(
              padding: new EdgeInsets.all(0),
              child: Text(S.of(context).uniformlySetProfit,
                  style: TextStyle(
                      color: AppColor.white, fontWeight: FontWeight.w300)),
            ),
            color: AppColor.themeRed,
            onPressed: () async {
              showModal(context);
            },
          ),
        ),
        body: (goodInfo != null)
            ? SingleChildScrollView(
                child: Column(
                children: <Widget>[
                  buildHeadView(),
                  Gaps.lowBr,
                  _getListData(),
                ],
              ))
            : Container());
  }

  void showModal(BuildContext context) {
    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: GoodsProfitDialog(
                    goodInfo: goodInfo,
                    onClick: (context) {
                      setState(() {
                        goodInfo = context;
                      });
                    },
                  )));
        });
  }

  _getListData() {
    var row_colum = GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          child: ListView.builder(
              shrinkWrap: true,
              physics: new NeverScrollableScrollPhysics(),
              itemCount: goodInfo.goods.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return buildSetPriceView(goodInfo.goods[index]);
              }),
        ));
    return row_colum;
  }

  Widget buildSetPriceView(Goods specGood) {
    TextEditingController _textCityController = new TextEditingController();
    _textCityController.text =
        specGood?.totalPrice?.toStringAsFixed(2) == '0.00'
            ? ''
            : specGood?.totalPrice?.toStringAsFixed(2);
    final FocusNode _nodeCity = FocusNode();
    bool autoFocusCell = false;
    if (specGood.isShow == 1 && autoFocus) {
      autoFocusCell = true;
      autoFocus = false;
    }
    return Container(
        height: 196,
        child: Column(
          children: <Widget>[
            Container(
                height: 50,
                padding: EdgeInsets.only(right: 15, left: 0, top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 15, left: 0, top: 0),
                          width: 5,
                          height: 20,
                          color: AppColor.themeRed,
                        ),
                        Container(
                          width: ScreenUtil.ScreenUtil().screenWidth / 2,
                          child: Text(
                            specGood.specName,
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 2,
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: (specGood.isShow == 0)
                          ? RaisedButton(
                              onPressed: () {
                                setState(() {
                                  specGood.isShow = 1;
                                });
                              },
                              child: Text(
                                S.of(context).close,
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Color(0xFFFF6363),
                              shape: StadiumBorder(),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            )
                          : OutlineButton(
                              onPressed: () {
                                setState(() {
                                  specGood.isShow = 0;
                                });
                              },
                              child: Text(S.of(context).enable),
                              shape: StadiumBorder(),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              borderSide:
                                  new BorderSide(color: Color(0x8A53CA4A)),
                            ),
                    )
                  ],
                )),
            Container(
              height: 80,
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Text(
                            specGood.discountPrice.toInt() == 0
                                ? "￥" + specGood.specPrice?.toStringAsFixed(2)
                                : "￥" +
                                    specGood.discountPrice?.toStringAsFixed(2),
                            style: TextStyle(
                                color: AppColor.mainTextColor, fontSize: 15),
                          ),
                          Text(
                            S.of(context).originPrice,
                            style: TextStyle(
                                color: Color(0xFF999999), fontSize: 13),
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: (specGood?.lowestPrice != 0)
                          ? Column(
                              children: <Widget>[
                                Text(
                                  "￥" +
                                      specGood.lowestPrice?.toStringAsFixed(2),
                                  style: TextStyle(
                                      color: AppColor.mainTextColor,
                                      fontSize: 15),
                                ),
                                Text(
                                  S.of(context).lowestPrice,
                                  style: TextStyle(
                                      color: Color(0xFF999999), fontSize: 13),
                                ),
                              ],
                            )
                          : Container()),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "￥" + specGood.averagePrice?.toStringAsFixed(2),
                          style: TextStyle(
                              color: AppColor.mainTextColor, fontSize: 15),
                        ),
                        Text(
                          S.of(context).averagePrice,
                          style:
                              TextStyle(color: Color(0xFF999999), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30),
                ],
              ),
            ),
            Gaps.line,
            Container(
              height: 55,
              child: Column(
                children: <Widget>[
                  // 编辑价格
                  InputTextItem(
                      title: S.of(context).saleprice1,
                      inputText: NormalInput(
                        board: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        hintText: S.of(context).warmTips,
                        controller: _textCityController,
                        focusNode: _nodeCity,
                        autoFocus: autoFocusCell,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onSubmitted: (res) {
                          FocusScope.of(context).requestFocus(_nodeCity);
                        },
                        onChanged: (res) {
                          specGood?.totalPrice = double.parse(res);
                        },
                      )),
                ],
              ),
            ),
            Gaps.lowBr,
          ],
        ));
  }

  Widget buildHeadView() {
    return Container(
        height: 120,
        child: Row(children: <Widget>[
          Container(
            width: 120,
            height: 120,
            padding: EdgeInsets.all(28),
            child: LoadImage(
              goodInfo.majorThumb.first,
              fit: BoxFit.fitWidth,
              holderImg: "goods/rosebox@3x",
              format: "png",
            ),
          ),
          Container(
            width: ScreenUtil.ScreenUtil().screenWidth - 130,
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new SizedBox(height: 0),
                Expanded(
                    flex: 8,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: Text(
                            goodInfo.name,
                            style: TextStyle(
                              fontSize: 13,
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
                    flex: 4,
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          child: Text("BBD：" + goodInfo.goods.first.bbd,
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 13,
                              )),
                        )
                      ],
                    )),
                Expanded(
                    flex: 4,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            S.of(context).inventory +
                                ":" +
                                goodInfo.number.toString(),
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ]));
  }
}

class GoodsProfitDialog extends StatefulWidget {
  GoodsProfitDialog({Key key, this.goodInfo, this.onClick}) : super(key: key);
  final GoodsDetailInfo goodInfo;
  final ValueChanged<GoodsDetailInfo> onClick;

  @override
  _GoodsProfitDialogState createState() => new _GoodsProfitDialogState();
}

class _GoodsProfitDialogState extends State<GoodsProfitDialog> {
  num goodsProfitValue = 1;

  final Border goodsProfitSelected = Border.all(
    color: AppColor.themeRed,
    width: 1,
    style: BorderStyle.solid,
  );

  final Border goodsProfitUnSelected = Border.all(
    color: Color(0xffCCCCCC),
    width: 0.5,
    style: BorderStyle.solid,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  dynamic countryId;
  TextEditingController _textValueController = new TextEditingController();
  final FocusNode _nodeValue = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
          height: 330,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  height: 44,
                  color: Color(0xffe4382d),
                  child: Text('请先设置商品利润', style: TextStyle(fontSize: 18))),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                          color: Color(0xffF8F8F8),
                          width: 123,
                          height: 33,
                          child: RaisedButtonCustom(
                              onPressed: () {
                                setState(() {
                                  goodsProfitValue = 1;
                                });
                              },
                              shape: goodsProfitValue == 1
                                  ? goodsProfitSelected
                                  : goodsProfitUnSelected,
                              textColor: AppColor.themeRed,
                              color: Colors.white,
                              txt: '按照利润比例',
                              padding: EdgeInsets.all(0))),
                      Container(
                          color: Color(0xffF8F8F8),
                          width: 123,
                          height: 33,
                          child: RaisedButtonCustom(
                              onPressed: () {
                                setState(() {
                                  goodsProfitValue = 2;
                                });
                              },
                              shape: goodsProfitValue == 2
                                  ? goodsProfitSelected
                                  : goodsProfitUnSelected,
                              textColor: AppColor.themeRed,
                              color: Colors.white,
                              txt: '按照利润净值',
                              padding: EdgeInsets.all(0))),
                    ],
                  )),
              Container(
                  width: 246,
                  height: 44,
                  child: TextField(
                      autofocus: true,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                          suffix: Container(
                              child: Text(
                            '${goodsProfitValue == 1 ? '%' : ''}',
                          )),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                                color: AppColor.themeRed, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                                color: Color(0xffDCDCDC), width: 1.0),
                          ),
                          hintText: "请输入利润",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 16.0),
                          contentPadding: EdgeInsets.all(10.0),
                          disabledBorder: null),
                      controller: _textValueController)),
              Container(
                width: 246,
                alignment: Alignment.center,
                child: Text('若售卖价低于最低售价，将取最低售价',
                    style: TextStyle(color: Color(0xff999999), fontSize: 12)),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    child: new Padding(
                      padding: new EdgeInsets.all(12),
                      child: Text("取消",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          )),
                    ),
                    color: Color(0xffCBCBCB),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  )),
                  Expanded(
                      child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    child: new Padding(
                      padding: new EdgeInsets.all(12),
                      child: Text("确定",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          )),
                    ),
                    color: Color(0xffe4382d),
                    onPressed: () async {
                      if (_textValueController.text.isEmpty) {
                        Util.showToast('请输入正确的信息');
                        return;
                      }
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.of(context).pop();
                      if (goodsProfitValue == 1) {
                        for (Goods item in widget.goodInfo.goods) {
                          item.totalPrice = (item.specPrice *
                                      double.parse(_textValueController.text)) /
                                  100 +
                              item.specPrice;
                          if (item.lowestPrice != 0) {
                            if (item.lowestPrice > item.totalPrice) {
                              item.totalPrice = item.lowestPrice;
                            }
                          }
                        }
                      } else {
                        for (Goods item in widget.goodInfo.goods) {
                          item.totalPrice =
                              double.parse(_textValueController.text) +
                                  item.specPrice;
                          if (item.lowestPrice != 0) {
                            if (item.lowestPrice > item.totalPrice) {
                              item.totalPrice = item.lowestPrice;
                            }
                          } else {}
                        }
                      }
                      widget.onClick(widget.goodInfo);
                      // EasyLoading.show(status: '提交信息...');
                      // ApiGoods.setProductBatchUpShelf({
                      //   'product_id': widget.goodInfo.id,
                      //   'type': goodsProfitValue,
                      //   'value': _textValueController.text
                      // }, (data) {
                      //   if (data.ret == 1) {
                      //     EasyLoading.showSuccess("修改成功");
                      //     ApplicationEvent.event
                      //         .fire(new RefreshGoodDetailAfterEditPrice());
                      //     Navigator.of(context).pop();
                      //     Routers.pop(context);
                      //   }
                      // }, (message) => null);
                    },
                  )),
                ],
              )
            ],
          )),
    );
  }

// class GoodsProfitDialog extends StatefulWidget {
//   GoodsProfitDialog({Key key, this.goodInfo}) : super(key: key);
//   final GoodsDetailInfo goodInfo;

//   @override
//   _GoodsProfitDialogState createState() => new _GoodsProfitDialogState();
// }

// class _GoodsProfitDialogState extends State<GoodsProfitDialog> {
//   num goodsProfitValue = 1;

//   final Border goodsProfitSelected = Border.all(
//     // 设置边框样式
//     color: AppColor.themeRed,
//     width: 1,
//     style: BorderStyle.solid,
//   );

//   final Border goodsProfitUnSelected = Border.all(
//     // 设置边框样式
//     color: Color(0xffCCCCCC),
//     width: 0.5,
//     style: BorderStyle.solid,
//   );

//   @override
//   void initState() {
//     super.initState();
//   }

//   dynamic countryId;
//   TextEditingController _textValueController = new TextEditingController();
//   final FocusNode _nodeValue = FocusNode();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: 330,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Container(
//                 alignment: Alignment.center,
//                 height: 44,
//                 color: Color(0xffe4382d),
//                 child: Text(S.of(context).setTips,
//                     style: TextStyle(fontSize: 16))),
//             Container(
//                 margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Container(
//                         color: Color(0xffF8F8F8),
//                         width: 123,
//                         height: 33,
//                         child: RaisedButtonCustom(
//                             onPressed: () {
//                               setState(() {
//                                 goodsProfitValue = 1;
//                               });
//                             },
//                             shape: goodsProfitValue == 1
//                                 ? goodsProfitSelected
//                                 : goodsProfitUnSelected,
//                             textColor: AppColor.themeRed,
//                             color: Colors.white,
//                             txt: S.of(context).priFitForpercentage,
//                             padding: EdgeInsets.all(0))),
//                     Container(
//                         color: Color(0xffF8F8F8),
//                         width: 123,
//                         height: 33,
//                         child: RaisedButtonCustom(
//                             onPressed: () {
//                               setState(() {
//                                 goodsProfitValue = 2;
//                               });
//                             },
//                             shape: goodsProfitValue == 2
//                                 ? goodsProfitSelected
//                                 : goodsProfitUnSelected,
//                             textColor: AppColor.themeRed,
//                             color: Colors.white,
//                             txt: S.of(context).netProfit,
//                             padding: EdgeInsets.all(0))),
//                   ],
//                 )),
//             Container(
//                 width: 246,
//                 height: 44,
//                 child: TextField(
//                     autofocus: false,
//                     cursorColor: Theme.of(context).primaryColor,
//                     decoration: InputDecoration(
//                         suffix: Container(
//                             child: Text(
//                           '${goodsProfitValue == 1 ? '%' : ''}',
//                         )),
//                         fillColor: Colors.white,
//                         filled: true,
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(0),
//                           borderSide:
//                               BorderSide(color: AppColor.themeRed, width: 1.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(0),
//                           borderSide:
//                               BorderSide(color: Color(0xffDCDCDC), width: 1.0),
//                         ),
//                         hintText: S.of(context).enterPriFit,
//                         hintStyle:
//                             TextStyle(color: Colors.grey, fontSize: 14.0),
//                         contentPadding: EdgeInsets.all(10.0),
//                         disabledBorder: null),
//                     controller: _textValueController)),
//             Container(
//               width: 246,
//               alignment: Alignment.center,
//               // margin: EdgeInsets.only(top: 9.5, bottom: 111),
//               child: Text(S.of(context).warmTips,
//                   style: TextStyle(color: Color(0xff999999), fontSize: 10)),
//             ),
//             Row(
//               children: <Widget>[
//                 Expanded(
//                     child: FlatButton(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(0)),
//                   child: new Padding(
//                     padding: new EdgeInsets.all(12),
//                     child: Text(S.of(context).cancel,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                           color: Colors.white,
//                         )),
//                   ),
//                   color: Color(0xffCBCBCB),
//                   onPressed: () async {
//                     Navigator.of(context).pop();
//                     // return false;
//                   },
//                 )),
//                 Expanded(
//                     child: FlatButton(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(0)),
//                   child: new Padding(
//                     padding: new EdgeInsets.all(12),
//                     child: Text(S.of(context).sure,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                           color: Colors.white,
//                         )),
//                   ),
//                   color: Color(0xffe4382d),
//                   onPressed: () async {
//                     EasyLoading.show(status: '提交信息...');
//                     ApiGoods.setProductBatchUpShelf({
//                       'product_id': widget.goodInfo.id,
//                       'type': goodsProfitValue,
//                       'value': _textValueController.text
//                     }, (data) {
//                       if (data.ret == 1) {
//                         EasyLoading.showSuccess("修改成功");
//                         ApplicationEvent.event
//                             .fire(new RefreshGoodDetailAfterEditPrice());
//                         Navigator.of(context).pop();
//                         Routers.pop(context);
//                       }
//                     }, (message) => null);
//                   },
//                 )),
//               ],
//             )
//           ],
//         ));
//   }

}
