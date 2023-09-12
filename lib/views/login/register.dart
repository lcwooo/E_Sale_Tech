import 'dart:async';

import 'package:E_Sale_Tech/api/user.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/login/login_config.dart';
import 'package:E_Sale_Tech/utils/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  var _mobileController = new TextEditingController();
  var _passwordController = new TextEditingController();
  var _repeatController = new TextEditingController();
  var _surnameController = new TextEditingController();
  var _nameController = new TextEditingController();
  var _emailController = new TextEditingController();
  var _addressController = new TextEditingController();
  var _codeController = new TextEditingController();

  String sent = S().clickSend;
  bool isButtonEnable = true;
  Timer timer;
  int count = 60;
  String countryCode = "";
  String state = S().country;
  bool isSelectState = false;
  String agreementString = "";
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
          codeColor = '#0DAC32';
          count = 60; //重置时间
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
    getAgeement();
  }

  @override
  void dispose() {
    timer?.cancel(); //销毁计时器
    timer = null;
    super.dispose();
  }

  void getAgeement() async {
    String code = await LocalStorage.getDefaultPhoneCode();
    var a = await rootBundle
        .loadString('assets/images/common/service_agreement.txt');
    setState(() {
      agreementString = a;
      countryCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PublicView().initBar(S.of(context).register),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(right: 20, left: 20, top: 40),
        child: Column(
          children: <Widget>[
            email(),
            line(),
            //手机号
            // buildLoginNameTextField(),
            // line(),
            //验证码
            // buildLoginPasswordTextField(),
            // line(),
            password(),
            line(),
            passwordConfirm(),
            line(),
            name(),
            nameLine(),
            // country(),
            // line(),
            // address(),
            // line(),
            agreement(),
            registerButton(),
            login(),
          ],
        ),
      ),
    );
  }

  var _checkValue = false;

  Widget agreement() {
    return Row(
      children: <Widget>[
        Checkbox(
          value: _checkValue,
          onChanged: (value) {
            setState(() {
              _checkValue = value;
            });
          },
          activeColor: Colors.blue,
          checkColor: Colors.white,
        ),
        PublicView().getText(S.of(context).readAgree, "#1C1717", 12),
        GestureDetector(
          child: PublicView()
              .getText(S.of(context).serviceAgreement, "#6698FF", 12),
          onTap: () {
            showDialog(context: context, builder: (ctx) => _buildAlertDialog());
          },
        ),
      ],
    );
  }

  Widget _buildAlertDialog() {
    return AlertDialog(
      title: _dialogTitle(),
      titlePadding: EdgeInsets.only(
        top: 5,
        right: 5,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      backgroundColor: Colors.white,
      content: _buildContent(),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
    );
  }

  Widget _buildContent() {
    return Container(
      height: MediaQuery.of(context).size.height / 2 + 100,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
        child: Text(
          agreementString,
          strutStyle: StrutStyle(forceStrutHeight: true, height: 1.5),
          style: TextStyle(fontSize: 13),
        ),
      ),
    );
  }

  Widget country() {
    return new Padding(
      padding: new EdgeInsets.all(0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: GestureDetector(
              child: Container(
                child: Text(
                  "国家(选填)",
                  style: TextStyle(color: HexToColor('#1C1717'), fontSize: 15),
                ),
                margin: EdgeInsets.only(top: 15, bottom: 15),
              ),
              onTap: () async {
                var s = await Navigator.pushNamed(context, '/phoneCode');
                String a = s;
                setState(() {
                  state = a.substring(a.indexOf('=') + 1);
                  isSelectState = true;
                });
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 20,
            ),
          )
        ],
      ),
    );
  }

  Widget address() {
    return new TextField(
      maxLines: 1,
      cursorColor: Theme.of(context).primaryColor,
      controller: _addressController,
      decoration: new InputDecoration(
          hintText: "地址详情(选填)",
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 15,
          )),
    );
  }

  Widget email() {
    return new TextField(
      maxLines: 1,
      cursorColor: Theme.of(context).primaryColor,
      controller: _emailController,
      decoration: new InputDecoration(
          hintText: '邮箱(必填)',
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 15,
          )),
    );
  }

  Widget nameLine() {
    return Row(
      children: <Widget>[
        Expanded(
          child: line(),
          flex: 3,
        ),
        Expanded(
          child: Text(''),
          flex: 1,
        ),
        Expanded(
          child: line(),
          flex: 5,
        ),
      ],
    );
  }

  Widget name() {
    return Row(
      children: <Widget>[
        Expanded(
          child: new TextField(
            maxLines: 1,
            cursorColor: Theme.of(context).primaryColor,
            controller: _surnameController,
            decoration: new InputDecoration(
                hintText: S.of(context).surname,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 15,
                )),
          ),
          flex: 3,
        ),
        Expanded(
          child: Text(''),
          flex: 1,
        ),
        Expanded(
          child: new TextField(
            maxLines: 1,
            cursorColor: Theme.of(context).primaryColor,
            controller: _nameController,
            decoration: new InputDecoration(
                hintText: S.of(context).name,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 15,
                )),
          ),
          flex: 5,
        ),
      ],
    );
  }

  Widget passwordConfirm() {
    return new TextField(
      obscureText: true,
      maxLines: 1,
      cursorColor: Theme.of(context).primaryColor,
      controller: _repeatController,
      decoration: new InputDecoration(
          hintText: S.of(context).passwordConfirmation,
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 15,
          )),
    );
  }

  Widget password() {
    return new TextField(
      obscureText: true,
      maxLines: 1,
      cursorColor: Theme.of(context).primaryColor,
      controller: _passwordController,
      decoration: new InputDecoration(
          hintText: S.of(context).password,
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 15,
          )),
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
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            cursorColor: Theme.of(context).primaryColor,
            controller: _codeController,
            decoration: new InputDecoration(
                hintText: '验证码(可不发送)',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 15,
                )),
          )),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              child: MaterialButton(
                onPressed: null,
                color: Colors.white,
                child: Text(
                  sent,
                  style: TextStyle(color: HexToColor(codeColor), fontSize: 12),
                ),
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                if (_mobileController.text.isEmpty) {
                  Util.showToast(S.of(context).pleaseInputMobileNumber);
                  return;
                }
                if (_mobileController.text.startsWith('0')) {
                  Util.showToast('手机号码格式有误，号码前请不要加0');
                  return;
                }
                if (!isButtonEnable) {
                  return;
                }

                Map<String, dynamic> map = {
                  'phone': _mobileController.text,
                  'flag': "1",
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
            child: Text(
              '+$countryCode',
              style: TextStyle(fontSize: 15),
            ),
            onTap: () async {
              var s = await Navigator.pushNamed(context, '/phoneCode');
              String a = s;
              setState(() {
                countryCode = a.substring(0, a.indexOf('='));
              });
            },
          ),
          Container(
            width: 20,
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 20.0),
          new Expanded(
              child: new TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _mobileController,
            maxLines: 1,
            cursorColor: Theme.of(context).primaryColor,
            onEditingComplete: () {},
            decoration: new InputDecoration(
                hintText: '手机号(选填)',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 15,
                )),
          )),
        ],
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

  Widget registerButton() {
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
          S.of(context).register,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());

/*        if (_mobileController.text.isEmpty) {
          Util.showToast(S.of(context).pleaseInputMobileNumber);
          return;
        }
        if (_codeController.text.isEmpty) {
          Util.showToast(S.of(context).verificationCode);
          return;
        }*/
        if (_passwordController.text.isEmpty ||
            _repeatController.text.isEmpty) {
          Util.showToast(S.of(context).pleaseInputPassword);
          return;
        }

        if (_passwordController.text != _repeatController.text) {
          Util.showToast(S.of(context).passwordsAreInconsistent);
          return;
        }

        if (_surnameController.text.isEmpty || _nameController.text.isEmpty) {
          Util.showToast(S.of(context).pleaseInputName);
          return;
        }

/*        if (_addressController.text.isEmpty) {
          Util.showToast(S.of(context).pleaseInputAddress);
          return;
        }*/

/*        if (_emailController.text.isEmpty) {
          Util.showToast(S.of(context).pleaseInputEmail);
          return;
        }*/

/*        if (!isSelectState) {
          Util.showToast(S.of(context).pleaseSelectCountry);
          return;
        }*/

        if (!_checkValue) {
          Util.showToast(S.of(context).userAgreement);
          return;
        }
        Map<String, dynamic> map = {
          'phone': '',
          'password': _passwordController.text,
          'timezone': '',
          'confirm_password': _repeatController.text,
          'name': _surnameController.text + " " + _nameController.text,
          'email': _emailController.text,
          'country': '',
          'flag': '1',
          'detailed_address': '',
          'verify_code': '',
        };
        var bean = await ApiUser.register(map);
        int ret = bean['ret'];
        if (ret == 0) {
          //Util.showToast(bean['msg']);
          return;
        }
        Util.showToast(bean['msg']);
        //Navigator.pushNamed(context, '/userStatus', arguments: {"id": 2});
        Navigator.pop(context);
      },
    );
  }

  Widget login() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        child: PublicView().getText(S.of(context).backLogin, "#AFAFAF", 15),
      ),
      onTap: () {
        Routers.goBack(context);
      },
    );
  }

  Widget _dialogTitle() {
    return GestureDetector(
      child: Align(
        child: Icon(
          Icons.close,
          size: 20,
        ),
        alignment: Alignment.centerRight,
      ),
      onTap: () {
        Routers.goBack(context);
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }
}
