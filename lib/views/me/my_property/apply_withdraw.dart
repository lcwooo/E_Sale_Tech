import 'package:E_Sale_Tech/api/me.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:E_Sale_Tech/components/click_item.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApplyWithdrawPage extends StatefulWidget {
  final Map arguments;

  ApplyWithdrawPage({this.arguments});

  @override
  _ApplyWithdrawState createState() {
    return _ApplyWithdrawState(arguments: arguments);
  }
}

class _ApplyWithdrawState extends State<ApplyWithdrawPage> {
  final Map arguments;
  static const WITHDRAW_ALIPAY = 1;
  static const WITHDRAW_CHINA_AREA_BANK = 2;
  static const WITHDRAW_EU_AREA_BANK = 3;

  int activeChoice = WITHDRAW_ALIPAY;
  TextEditingController withdrawAmount;
  TextEditingController accountIndentify;
  TextEditingController accountName;

  _ApplyWithdrawState({this.arguments});

  String version = "";
  String waitWithdraw;

  final subtitleStyle = TextStyle(color: Color(0xff999999));

  @override
  void initState() {
    super.initState();
    this.withdrawAmount = TextEditingController();
    this.accountIndentify = TextEditingController();
    this.accountName = TextEditingController();
    this._loadData();
  }

  void _loadData() async {
    var properties = await ApiMe.getProperties();
    // Log.e("拉取结果完成" + jsonEncode(properties));
    this.setState(() {
      this.waitWithdraw = properties['wait_withdraw'].toString() ?? '*';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffF8F8F8),
      appBar: MyAppBar(
        centerTitle: '提现',
        actionName: '提现记录',
        onPressed: () {
          Routers.push("/me/myProperty/withdrawRecord", context);
        },
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
          onPressed: () async {
            if (double.parse(this.withdrawAmount.text) >
                double.parse(waitWithdraw)) {
              Util.showToast('超出可提现金额');
              return;
            }
            if (double.parse(this.withdrawAmount.text) <= 0) {
              Util.showToast('提现金额不能小于 0');
              return;
            }
            if (this.accountIndentify.text == '') {
              Util.showToast('账号为必填项');
              return;
            }
            if (this.accountName.text == '') {
              Util.showToast('账户名为必填项');
              return;
            }
            Map submitParams = this.buildApplyWithrawParams();
            ApiMe.applyWithdraw(submitParams).then((res) => {
                  if (res['ret'] == 1)
                    {Util.showToast('申请成功'), Routers.pop(context)}
                  else
                    {
                      Util.showToast(
                          res['message'] != null ? res['message'] : '添加失败')
                    }
                });
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          _buildContentArea(),
          Expanded(
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentArea() {
    return Column(
      children: <Widget>[
        Divider(
          height: 1.0,
          color: Colors.transparent,
        ),
        NormalWithDrawContainer(
          widget: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 14),
            child: Text(
              '请选择提现方式',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
        Divider(
          height: 1.0,
          color: Colors.transparent,
        ),
        //构造提现类型选择区域
        _buildWithdrawTypeArea(),
        Divider(
          height: 10.0,
          color: Colors.transparent,
        ),
        _buildWithDrawAmountArea(),
        Divider(
          height: 10.0,
          color: Colors.transparent,
        ),
        _buildInputFormArea(),
      ],
    );
  }

  Widget _buildWithdrawTypeArea() {
    List<Widget> child = [];
    for (var type in [
      WITHDRAW_ALIPAY,
      WITHDRAW_CHINA_AREA_BANK,
      WITHDRAW_EU_AREA_BANK
    ]) {
      child.add(_buildWithdrawTypeItem(type));
    }
    return Column(
      children: child,
    );
  }

  Widget _buildWithdrawTypeItem(int type) {
    String iconPath;
    String title;
    switch (type) {
      case WITHDRAW_ALIPAY:
        iconPath = 'assets/images/me/alipay@3x.png';
        title = '支付宝提现';
        break;
      case WITHDRAW_CHINA_AREA_BANK:
        iconPath = 'assets/images/me/withdraw_china@3x.png';
        title = '中国地区银行提现';
        break;
      case WITHDRAW_EU_AREA_BANK:
        iconPath = 'assets/images/me/withdraw_eu@3x.png';
        title = '欧洲银行提现';
        break;
      default:
        iconPath = 'assets/images/me/alipay@3x.png';
        title = '支付宝提现';
    }
    var item = InkWell(
      onTap: () {
        this.accountName.clear();
        this.accountIndentify.clear();
        setState(() {
          this.activeChoice = type;
        });
      },
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 10),
              width: 24,
              height: 24,
              child: Image.asset(iconPath),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(title),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(right: 24),
              child: Radio(
                value: type,
                groupValue: this.activeChoice,
                onChanged: (value) {
                  this.accountName.clear();
                  this.accountIndentify.clear();
                  setState(() {
                    this.activeChoice = value;
                  });
                },
                activeColor: AppColor.green,
              ),
            ),
          ),
        ],
      ),
    );
    return NormalWithDrawContainer(
      widget: item,
    );
  }

  Widget _buildWithDrawAmountArea() {
    return Container(
      color: AppColor.white,
      width: ScreenUtil().screenWidth,
      height: 80,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(14, 15, 0, 0),
            child: Text(
              '请输入提现金额(RMB)',
              style: TextStyle(fontSize: 14.5),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 16.5, 0, 0),
            child: Row(
              children: <Widget>[
                //图标
                Container(
                  height: 24,
                  width: 24,
                  child: Image.asset('assets/images/me/rmb.png'),
                ),
                Container(
                  height: 24,
                  width: 200, //需要制定宽度,不然会报错
                  // alignment: Alignment.bottomCenter,
                  // padding: EdgeInsets.only(top: 10),
                  // padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: TextField(
                    controller: this.withdrawAmount,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, -25, 0, 0),
                      hintText: '可提现收益 ${waitWithdraw}',
                      hintStyle: TextStyle(fontSize: 17),
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFormArea() {
    Widget form;
    switch (this.activeChoice) {
      case WITHDRAW_ALIPAY:
        form = Column(
          children: <Widget>[
            NormalWithDrawContainer(
              widget: WithdrawAccount(
                title: '支付宝转账账号',
                contentController: accountIndentify,
                contentPlaceholder: '请输入支付宝账号',
              ),
            ),
            Divider(
              height: 1,
              color: Colors.transparent,
            ),
            NormalWithDrawContainer(
              widget: WithdrawAccount(
                title: '收款人姓名',
                contentController: accountName,
                contentPlaceholder: '请输入收款人姓名',
              ),
            ),
          ],
        );
        break;
      case WITHDRAW_CHINA_AREA_BANK:
        form = Column(
          children: <Widget>[
            NormalWithDrawContainer(
              widget: WithdrawAccount(
                title: '银行卡号',
                contentController: accountIndentify,
                contentPlaceholder: '请输入银行卡号',
              ),
            ),
            Divider(
              height: 1,
              color: Colors.transparent,
            ),
            NormalWithDrawContainer(
              widget: WithdrawAccount(
                title: '持卡人姓名',
                contentController: accountName,
                contentPlaceholder: '请输入持卡人姓名',
              ),
            ),
          ],
        );
        break;
      case WITHDRAW_EU_AREA_BANK:
        form = Column(
          children: <Widget>[
            NormalWithDrawContainer(
              widget: WithdrawAccount(
                title: 'IBAN',
                contentController: accountIndentify,
                contentPlaceholder: '请输入IBAN',
              ),
            ),
            Divider(
              height: 1,
              color: Colors.transparent,
            ),
            NormalWithDrawContainer(
              widget: WithdrawAccount(
                title: 'Swift Code',
                contentController: accountName,
                contentPlaceholder: '请输入Swift Code',
              ),
            ),
          ],
        );
        break;
      default:
        form = Column(
          children: <Widget>[
            NormalWithDrawContainer(),
            Divider(
              height: 1,
              color: Colors.transparent,
            ),
            NormalWithDrawContainer(),
          ],
        );
    }
    return form;
  }

  Map buildApplyWithrawParams() {
    Map<String, dynamic> submitParams;
    switch (this.activeChoice) {
      case WITHDRAW_ALIPAY:
        submitParams = {
          "type": 1,
          "amount": this.withdrawAmount.text,
          "account_number": this.accountIndentify.text,
          "account_name": this.accountName.text,
        };
        break;
      case WITHDRAW_CHINA_AREA_BANK:
        submitParams = {
          "type": 2,
          "amount": this.withdrawAmount.text,
          "account_number": this.accountIndentify.text,
          "account_name": this.accountName.text,
        };
        break;
      case WITHDRAW_EU_AREA_BANK:
        submitParams = {
          "type": 3,
          "amount": this.withdrawAmount.text,
          "iban": this.accountIndentify.text,
          "swift_code": this.accountName.text,
        };
        break;
      default:
    }
    return submitParams;
  }
}

class NormalWithDrawContainer extends StatelessWidget {
  final Widget widget;
  NormalWithDrawContainer(
      {this.widget = const Text(
        '请选择提现方式',
      )});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      width: ScreenUtil().screenWidth,
      height: 49,
      child: widget,
    );
  }
}

class WithdrawAccount extends StatelessWidget {
  final String title;
  final String contentPlaceholder;
  final TextEditingController contentController;

  WithdrawAccount(
      {this.title, this.contentController, this.contentPlaceholder});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 13.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            this.title,
            style: TextStyle(fontSize: 14.5),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            width: ScreenUtil().screenWidth * 0.6,
            child: TextField(
              controller: this.contentController,
              decoration: InputDecoration(
                hintText: this.contentPlaceholder,
                hintStyle: TextStyle(fontSize: 14.5),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
