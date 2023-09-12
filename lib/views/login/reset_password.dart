import 'dart:async';

import 'package:E_Sale_Tech/api/user.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/login/login_config.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/utils/localstorage.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() {
    return _ResetPasswordState();
  }
}

class _ResetPasswordState extends State<ResetPassword> {
  var _mobileController = new TextEditingController();
  var _codeController = new TextEditingController();
  var _newPasswordController = new TextEditingController();
  String sent = S().clickSend;
  bool isButtonEnable = true;
  Timer timer;
  int count = 60;
  String countryCode = "31";
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
    getReviewing();
  }

  void getReviewing() async {
    String code = await LocalStorage.getDefaultPhoneCode();
    setState(() {
      countryCode = code;
    });
  }

  @override
  void dispose() {
    timer?.cancel(); //销毁计时器
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PublicView().initBar(S.of(context).resetPassword),
      body: GestureDetector(
        child: Container(
          margin: EdgeInsets.only(left: 30, right: 30),
          child: reset(),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      ),
    );
  }

  Widget line() {
    return Divider(
      height: 1.0,
      indent: 0,
      color: HexToColor('#464646'),
    );
  }

  Widget reset() {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _appName(),
        buildLoginNameTextField(),
        line(),
        buildLoginPasswordTextField(),
        line(),
        newPassword(),
        line(),
        loginButton(),
      ],
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

  Widget loginButton() {
    return GestureDetector(
      child: Container(
        height: 44,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 60),
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
          color: HexToColor('#1C1717'),
        ),
        child: Text(
          S.of(context).submit,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());

        if (_mobileController.text.isEmpty) {
          Util.showToast(S.of(context).pleaseInputMobileNumber);
          return;
        }
        if (_codeController.text.isEmpty) {
          Util.showToast(S.of(context).verificationCode);
          return;
        }

        if (_newPasswordController.text.isEmpty) {
          Util.showToast(S.of(context).pleaseInputPassword);
          return;
        }
        Map<String, dynamic> map = {
          'phone': _mobileController.text,
          'new_password': _newPasswordController.text,
          'verify_code': _codeController.text
        };
        var bean = await ApiUser.resetPassword(map);
        int ret = bean['ret'];
        if (ret == 0) {
          //Util.showToast(bean['msg']);
          return;
        }
        Util.showToast(bean['msg']);
        Routers.goBack(context);
      },
    );
  }

  Widget newPassword() {
    return new Padding(
      padding: new EdgeInsets.all(5),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            obscureText: true,
            controller: _newPasswordController,
            decoration: new InputDecoration(
                hintText: S.of(context).newPassword,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 15,
                )),
          )),
        ],
      ),
    );
  }

  Widget buildLoginPasswordTextField() {
    return new Padding(
      padding: new EdgeInsets.all(5),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            maxLines: 1,
            controller: _codeController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: new InputDecoration(
                hintText: S.of(context).verificationCode,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 15,
                )),
          )),
          Align(
            alignment: Alignment.centerRight,
            child: MaterialButton(
              onPressed: null,
              color: Colors.white,
              child: GestureDetector(
                child: Text(
                  sent,
                  style: TextStyle(color: HexToColor(codeColor), fontSize: 12),
                ),
                onTap: () async {
                  if (_mobileController.text.isEmpty) {
                    Util.showToast(S.of(context).pleaseInputMobileNumber);
                    return;
                  }

                  if (!isButtonEnable) {
                    return;
                  }

                  Map<String, dynamic> map = {
                    'phone': _mobileController.text,
                    'flag': "3",
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
              ),
            ),
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
                if (s == null) {
                  return;
                }
                countryCode = a.substring(0, a.indexOf('='));
              });
            },
          ),
          SizedBox(width: 20.0),
          new Expanded(
              child: new TextField(
            maxLines: 1,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _mobileController,
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
