import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/components/input/base_input.dart';
import 'package:E_Sale_Tech/components/input/input_text_item.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/shop/coupon/coupon_status_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import 'package:E_Sale_Tech/components/click_item.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/style.dart';

class SetCoupon extends StatefulWidget {
  @override
  _SetCouponState createState() => _SetCouponState();
}

class _SetCouponState extends State<SetCoupon> {
  DateTime dateBegin;
  DateTime temporaryDateBegin;
  DateTime dateEnd;
  DateTime temporaryDateEnd;
  int type; // type
  int scope; // 适用范围
  int customerLimit = 1; // 每人限领
  List selectedListIds = [];
  bool isSave = true;

  final subtitleStyle = TextStyle(color: Color(0xff999999));
  // 发放总量
  TextEditingController _textDispatchAmountController =
      new TextEditingController();
  final FocusNode _nodeDispatchAmount = FocusNode();
  // 金额
  TextEditingController _textAmountController = new TextEditingController();
  final FocusNode _nodeAmount = FocusNode();
  // 门槛
  TextEditingController _textThresholdController = new TextEditingController();
  final FocusNode _nodeThreshold = FocusNode();
  // name
  TextEditingController _textNameController = new TextEditingController();
  final FocusNode _nodeName = FocusNode();

  TextEditingController _textValueController = new TextEditingController();
  final FocusNode _nodeValue = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textDispatchAmountController?.dispose();
    _textAmountController?.dispose();
    _textThresholdController?.dispose();
    _textNameController?.dispose();
    _textValueController?.dispose();
    super.dispose();
  }

  saveCoupon() {
    if (!checkForm()) {
      Util.showToast('请填写完整');
      return;
    }
    EasyLoading.show(status: '保存中...');
    if (isSave) {
      isSave = false;
      ApiShop.newCoupons({
        'type': type,
        'name': _textNameController.text,
        'amount':
            type == 1 ? _textValueController.text : _textAmountController.text,
        'threshold': type == 1 ? _textThresholdController.text : 0,
        'dispatch_amount': _textDispatchAmountController.text,
        'begin_time': DateFormat('yyyy-MM-dd').format(dateBegin).toString(),
        'end_time': DateFormat('yyyy-MM-dd').format(dateEnd).toString(),
        'scope': scope,
        'customer_limit': customerLimit,
        'ids': selectedListIds,
      }, (data) {
        if (data.ret == 1) {
          Util.showToast('新建成功');
          if (ApplicationEvent.event != null) {
            ApplicationEvent.event.fire(ListRefreshEvent('refresh'));
            Routers.pop(context);
          }
        }
        isSave = true;
      }, (message) => null);
    }
  }

  bool checkForm() {
    if (type != 1 && type != 2) {
      return false;
    }
    if (_textNameController.text.isEmpty ||
        _textDispatchAmountController.text.isEmpty) {
      return false;
    }
    if (_textValueController.text.isEmpty &&
        _textAmountController.text.isEmpty) {
      return false;
    }
    if (type == 1 && _textThresholdController.text.isEmpty) {
      return false;
    }
    if (dateBegin == null || dateEnd == null) {
      return false;
    }
    if (scope != 0 && selectedListIds.length < 1) {
      return false;
    }
    return true;
  }

  void showActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => child,
    ).then((value) async {
      FocusScope.of(context).requestFocus(FocusNode());
      if (value == 0 || value == null) return;
      _textThresholdController.text = '';
      _textAmountController.text = '';
      _textValueController.text = '';
      setState(() {
        type = value;
      });
    });
  }

  void showScopeSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => child,
    ).then((value) async {
      FocusScope.of(context).requestFocus(FocusNode());
      if (value == null) return;
      if (value == 'all') {
        setState(() {
          scope = 0;
        });
      } else if (value == 'appoint') {
        Routers.push('/shop/coupon/setCouponRange', context).then((res) {
          if (res != null) {
            switch (res['type']) {
              case 'brand':
                setState(() {
                  scope = 2;
                  selectedListIds = res['brand_id'];
                });
                break;
              case 'goods':
                setState(() {
                  scope = 1;
                  selectedListIds = res['goods_id'];
                });
                break;
              case 'category':
                setState(() {
                  scope = 3;
                  selectedListIds = res['category_id'];
                });
                break;
              default:
            }
          }
        });
      }
    });
  }

  void showDateActionSheet(
      {BuildContext context, Widget child, Function onSuccessCallback}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => child,
    ).then((type) async {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  void showCupertinoPicker({BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
          height: 150,
          child: CupertinoPicker(
              itemExtent: 30,
              onSelectedItemChanged: (position) {
                setState(() {
                  customerLimit = position + 1;
                });
              },
              children: [
                Text("1"),
                Text("2"),
                Text("3"),
                Text("4"),
                Text("5"),
                Text("6"),
                Text("7"),
                Text("8"),
                Text("9"),
                Text("10"),
              ])),
    ).then((type) async {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffF8F8F8),
      appBar: MyAppBar(
        centerTitle: '创建优惠券',
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
                      saveCoupon();
                    },
                    shape: Border.all(
                      // 设置边框样式
                      color: AppColor.themeRed,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                    textColor: AppColor.themeRed,
                    color: Colors.white,
                    txt: '保存',
                    padding: EdgeInsets.only(left: 50, right: 50)),
                RaisedButtonCustom(
                    onPressed: () {
                      if (!checkForm()) {
                        Util.showToast('请填写完整');
                        return;
                      }
                      Routers.push('/shop/coupon/previewCoupon', context, {
                        'type': type,
                        'name': _textNameController.text,
                        'amount': type == 1
                            ? _textValueController.text
                            : _textAmountController.text,
                        'threshold':
                            type == 1 ? _textThresholdController.text : 0,
                        'dispatch_amount': _textDispatchAmountController.text,
                        'begin_time': DateFormat('yyyy-MM-dd')
                            .format(dateBegin)
                            .toString(),
                        'end_time':
                            DateFormat('yyyy-MM-dd').format(dateEnd).toString(),
                        'scope': scope,
                        'customer_limit': customerLimit,
                        'ids': selectedListIds,
                      }).then((res) {
                        if (res != null && res['status'] == 'done') {
                          Routers.pop(context);
                        }
                      });
                    },
                    shape: Border.all(
                      // 设置边框样式
                      color: AppColor.themeRed,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                    textColor: AppColor.themeRed,
                    color: Colors.white,
                    txt: '预览',
                    padding: EdgeInsets.only(left: 50, right: 50)),
              ],
            )),
      ),
      body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ClickItem(
                        title: '优惠形式',
                        rightWidget: Text(
                            type == 1
                                ? '抵用券'
                                : type == 2
                                    ? '折扣券'
                                    : '未设置',
                            style: subtitleStyle),
                        onTap: () {
                          showActionSheet(
                            context: context,
                            child: CupertinoActionSheet(
                              title: const Text('选择优惠形式'),
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  child: const Text('抵用券'),
                                  onPressed: () {
                                    Navigator.pop(context, 1);
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('折扣券'),
                                  onPressed: () async {
                                    Navigator.pop(context, 2);
                                  },
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text('取消'),
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context, 0);
                                },
                              ),
                            ),
                          );
                        }),
                    InputTextItem(
                        title: "优惠券名称",
                        inputText: BaseInput(
                          maxLength: 20,
                          textAlign: TextAlign.right,
                          hintText: "最多10个字",
                          controller: _textNameController,
                          focusNode: _nodeName,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          keyboardType: TextInputType.text,
                          onSubmitted: (res) {
                            // FocusScope.of(context).requestFocus(_nodeValue);
                          },
                        )),
                    Container(
                        child: InputTextItem(
                            height: type == 2 ? 0 : 55,
                            title: "面值",
                            inputText: BaseInput(
                              maxLength: 5,
                              textAlign: TextAlign.right,
                              hintText: "1-10000",
                              controller: _textValueController,
                              focusNode: _nodeValue,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 8.0),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              onSubmitted: (res) {
                                // FocusScope.of(context).requestFocus(_nodeThreshold);
                              },
                            ))),
                    Container(
                        height: type == 2 ? 0 : 55,
                        child: InputTextItem(
                            title: "使用门槛",
                            inputText: BaseInput(
                              maxLength: 5,
                              textAlign: TextAlign.right,
                              hintText: "0-10000",
                              controller: _textThresholdController,
                              focusNode: _nodeThreshold,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 8.0),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              onSubmitted: (res) {
                                FocusScope.of(context)
                                    .requestFocus(_nodeAmount);
                              },
                            ))),
                    Container(
                        height: type == 1 ? 0 : 55,
                        child: InputTextItem(
                            title: "折扣",
                            hideArrow: true,
                            rightWidget: Text('%', style: AppText.textGray14),
                            inputText: BaseInput(
                              maxLength: 3,
                              textAlign: TextAlign.right,
                              hintText: "1-99",
                              controller: _textAmountController,
                              focusNode: _nodeAmount,
                              contentPadding: EdgeInsets.all(9.5),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              onSubmitted: (res) {
                                FocusScope.of(context)
                                    .requestFocus(_nodeDispatchAmount);
                              },
                            ))),
                    InputTextItem(
                        title: "发放总量",
                        inputText: BaseInput(
                          maxLength: 7,
                          textAlign: TextAlign.right,
                          hintText: "1-1000000",
                          controller: _textDispatchAmountController,
                          focusNode: _nodeDispatchAmount,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          onSubmitted: (res) {},
                        )),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      ClickItem(
                          title: '开始时间',
                          rightWidget: Text(
                              dateBegin == null
                                  ? '未设置'
                                  : DateFormat('yyyy-MM-dd').format(dateBegin),
                              style: subtitleStyle),
                          onTap: () {
                            showDateActionSheet(
                                onSuccessCallback: (val) {
                                  print('onSuccessCallback $val');
                                },
                                context: context,
                                child: Container(
                                    height: 250,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                GestureDetector(
                                                    onTap: () {
                                                      Routers.pop(context);
                                                    },
                                                    child: Container(
                                                        child: Text('取消'))),
                                                GestureDetector(
                                                    onTap: () {
                                                      if (temporaryDateBegin ==
                                                          null) {
                                                        setState(() {
                                                          dateBegin =
                                                              DateTime.now();
                                                        });
                                                      } else {
                                                        setState(() {
                                                          dateBegin =
                                                              temporaryDateBegin;
                                                        });
                                                      }
                                                      Routers.pop(context);
                                                    },
                                                    child: Container(
                                                        child: Text(
                                                      '确定',
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .themeRed),
                                                    ))),
                                              ],
                                            )),
                                        SizedBox(
                                          height: 200,
                                          child: CupertinoDatePicker(
                                              initialDateTime: dateBegin != null
                                                  ? dateBegin
                                                  : DateTime.now(),
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                              onDateTimeChanged: (value) {
                                                setState(() {
                                                  temporaryDateBegin = value;
                                                });
                                              }),
                                        )
                                      ],
                                    )));
                          }),
                      ClickItem(
                          title: '结束时间',
                          rightWidget: Text(
                              dateEnd == null
                                  ? '未设置'
                                  : DateFormat('yyyy-MM-dd').format(dateEnd),
                              style: subtitleStyle),
                          onTap: () {
                            showDateActionSheet(
                                onSuccessCallback: (val) {
                                  print('onSuccessCallback $val');
                                },
                                context: context,
                                child: Container(
                                    height: 250,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                GestureDetector(
                                                    onTap: () {
                                                      Routers.pop(context);
                                                    },
                                                    child: Container(
                                                        child: Text('取消'))),
                                                GestureDetector(
                                                    onTap: () {
                                                      if (temporaryDateEnd ==
                                                          null) {
                                                        setState(() {
                                                          dateEnd =
                                                              DateTime.now();
                                                        });
                                                      } else {
                                                        setState(() {
                                                          dateEnd =
                                                              temporaryDateEnd;
                                                        });
                                                      }
                                                      Routers.pop(context);
                                                    },
                                                    child: Container(
                                                        child: Text(
                                                      '确定',
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .themeRed),
                                                    ))),
                                              ],
                                            )),
                                        SizedBox(
                                          height: 200,
                                          child: CupertinoDatePicker(
                                              initialDateTime: dateEnd != null
                                                  ? dateEnd
                                                  : DateTime.now(),
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                              onDateTimeChanged: (value) {
                                                setState(() {
                                                  temporaryDateEnd = value;
                                                });
                                              }),
                                        )
                                      ],
                                    )));
                          }),
                      ClickItem(
                          title: '每人限领',
                          rightWidget: Text(customerLimit.toString(),
                              style: subtitleStyle),
                          onTap: () {
                            showCupertinoPicker(context: context);
                          }),
                      ClickItem(
                          title: '适用范围',
                          rightWidget: Text(CouponStatus.scopeFunc(scope)),
                          onTap: () {
                            showScopeSheet(
                              context: context,
                              child: CupertinoActionSheet(
                                title: const Text('适用范围'),
                                actions: <Widget>[
                                  CupertinoActionSheetAction(
                                    child: const Text('全部商品'),
                                    onPressed: () {
                                      Navigator.pop(context, 'all');
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: const Text('指定范围可用'),
                                    onPressed: () async {
                                      Navigator.pop(context, 'appoint');
                                    },
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  child: const Text('取消'),
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context, null);
                                  },
                                ),
                              ),
                            );
                          }),
                    ],
                  )),
              Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  '优惠券设置说明：优惠金额会从店主设置的利润中扣除。请确保金额在您设置的相应产品的利润范围内，若超过相应利润范围，优惠券将无法使用。',
                  style: TextStyle(
                      color: Color(0xff999999), fontSize: 12, letterSpacing: 1),
                ),
              )
            ],
          ))),
    );
  }
}
