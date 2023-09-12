import 'dart:async';

import 'package:E_Sale_Tech/api/user.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/model/index.dart';
import 'package:E_Sale_Tech/model/user/wx_login.dart';
import 'package:E_Sale_Tech/utils/localstorage.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/login/login_event.dart';
import 'package:E_Sale_Tech/views/login/public.dart';
import 'package:E_Sale_Tech/views/login/public_view.dart';
import 'package:E_Sale_Tech/views/me/agent_provider.dart';
import 'package:E_Sale_Tech/views/shop/shop_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BindingPhone extends StatefulWidget {
  final Map arguments;

  BindingPhone({this.arguments});

  @override
  _BindingPhoneState createState() {
    return _BindingPhoneState(arguments: arguments);
  }
}

class _BindingPhoneState extends State<BindingPhone> {
  final Map arguments;

  _BindingPhoneState({this.arguments});

  var _phoneController = new TextEditingController();
  var _codeController = new TextEditingController();
  var _passwordController = new TextEditingController();
  String countryCode = "31";
  String sent = S().clickSend;
  bool isButtonEnable = true;
  Timer timer;
  int count = 60;
  String codeColor = '#0DAC32';

  void _buttonClickListen() {
    setState(() {
      if (isButtonEnable) {
        //当按钮可点击时
        isButtonEnable = false; //按钮状态标记
        _initTimer();
        return null; //返回null按钮禁止点击
      } else {
        //当按钮不可点击时
        return null; //返回null按钮禁止点击
      }
    });
  }

  void _initTimer() {
    timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      count--;
      setState(() {
        if (count == 0) {
          timer.cancel(); //倒计时结束取消定时器
          isButtonEnable = true; //按钮可点击
          count = 60; //重置时间
          codeColor = '#0DAC32';
          sent = S().clickSend; //重置按钮文本
        } else {
          sent = S.of(context).resend + '($count)'; //更新文本内容
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel(); //销毁计时器
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PublicView().initBar("绑定手机号"),
      body: GestureDetector(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _appName(),
              _loginInfo(context),
              //_password(),
            ],
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      ),
    );
  }

  Widget _appName() {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: new Image.asset(
          'assets/images/common/user_logo.png',
          width: 73,
          height: 73,
        ),
      ),
    );
  }

  Widget _loginInfo([BuildContext context]) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
        child: Column(
          children: <Widget>[
            //手机号
            buildLoginNameTextField(),
            line(),
            //验证码
            buildLoginPasswordTextField(),
            line(),
            _password(),
            line(),
            loginButton(),
          ],
        ),
      ),
    );
  }

  Widget loginButton() {
    return GestureDetector(
      child: Container(
        height: 44,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 100),
        width: MediaQuery.of(context).size.width,
        color: HexToColor('#1C1717'),
        child: Text(
          '立即绑定',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());

        //eventBus.fire(new LoginEvent(false, true));
        //Navigator.pop(context);

        if (_phoneController.text.isEmpty) {
          Util.showToast(S.of(context).pleaseInputMobileNumber);
          return;
        }
        if (_codeController.text.isEmpty) {
          Util.showToast(S.of(context).verificationCode);
          return;
        }
        if (_passwordController.text.isEmpty) {
          Util.showToast(S.of(context).pleaseInputPassword);
          return;
        }
        Map<String, dynamic> map = {
          'timezone': countryCode,
          'phone': _phoneController.text,
          'out_id': arguments["out_id"],
          'token': arguments["token"],
          'code': _codeController.text
        };
        var bean = await ApiUser.vxBind(map);
        String msg = bean['msg'];
        WxBean bindBean = bean['bean'];
        int ret = bean['ret'];
        if (ret == 0) {
          eventBus.fire(new LoginEvent(false, false));
          return;
        }
        eventBus.fire(new LoginEvent(false, true));

        String token = bindBean.tokenType + " " + bindBean.token;
        Provider.of<Model>(context, listen: false).setToken(token);
        Provider.of<ShopInfoProvider>(context, listen: false).getShopInfo();
        Provider.of<AgentInfoProvider>(context, listen: false).getAgentInfo();
        LocalStorage.saveToken(token);
        LocalStorage.saveCompleteInfo(bindBean.completeinfo);
        ApplicationEvent.event.fire(new HomeRefresh());
        Navigator.pop(context);
      },
    );
  }

  Widget _password() {
    return new TextField(
      controller: _passwordController,
      maxLines: 1,
      obscureText: true,
      cursorColor: Theme.of(context).primaryColor,
      decoration: new InputDecoration(
          hintText: '设置密码',
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 15,
          )),
    );
  }

  Widget line() {
    return Divider(
      height: 1.0,
      indent: 0,
      color: HexToColor('#464646'),
    );
  }

  Widget buildLoginPasswordTextField() {
    return new Padding(
      padding: new EdgeInsets.all(5),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: _codeController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            maxLines: 1,
            cursorColor: Theme.of(context).primaryColor,
            decoration: new InputDecoration(
                hintText: S.of(context).verificationCode,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 15,
                )),
          )),
          GestureDetector(
            child: Align(
              alignment: Alignment.centerRight,
              child: MaterialButton(
                onPressed: null,
                color: Colors.white,
                child: Text(
                  sent,
                  style: TextStyle(color: HexToColor(codeColor), fontSize: 12),
                ),
              ),
            ),
            onTap: () async {
              if (_phoneController.text.isEmpty) {
                Util.showToast(S.of(context).pleaseInputMobileNumber);
                return;
              }

              if (!isButtonEnable) {
                return;
              }

              Map<String, dynamic> map = {
                'phone': _phoneController.text,
                'flag': "2",
                'timezone': countryCode
              };
              var bean = await ApiUser.sendVerify(map);
              int ret = bean['ret'];
              if (ret == 0) {
                //Util.showToast(bean['msg']);
                return;
              }
              Util.showToast(bean['msg']);
              setState(() {
                codeColor = '#999999';
                _buttonClickListen();
              });
            },
          )
        ],
      ),
    );
  }

  Widget buildLoginNameTextField() {
    return new Padding(
      padding: new EdgeInsets.all(5),
      child: new Row(
        children: <Widget>[
          GestureDetector(
            child: ButtonBar(
              alignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  '+$countryCode',
                  style: TextStyle(fontSize: 15),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 25,
                ),
              ],
            ),
            onTap: () async {
              var s = await Navigator.pushNamed(context, '/phoneCode');
              String a = s;
              setState(() {
                countryCode = a.substring(0, a.indexOf('='));
              });
            },
          ),
          SizedBox(width: 20.0),
          new Expanded(
              child: new TextField(
            controller: _phoneController,
            maxLines: 1,
            cursorColor: Theme.of(context).primaryColor,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: new InputDecoration(
                hintText: S.of(context).phoneNumber,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 15,
                )),
          )),
        ],
      ),
    );
  }
}
