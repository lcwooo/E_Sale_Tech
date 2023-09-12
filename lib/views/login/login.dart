import 'dart:async';

import 'package:E_Sale_Tech/api/common.dart';
import 'package:E_Sale_Tech/api/user.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/model/index.dart';
import 'package:E_Sale_Tech/model/user/login_bean.dart';
import 'package:E_Sale_Tech/model/user/wx_login.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/localstorage.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/login/login_config.dart';
import 'package:E_Sale_Tech/views/login/login_event.dart';
import 'package:E_Sale_Tech/views/me/agent_provider.dart';
import 'package:E_Sale_Tech/views/shop/shop_provider.dart';
import 'package:flutter/material.dart';
// import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  var _phoneController = new TextEditingController();
  var _passwordController = new TextEditingController();
  String countryCode = "";
  String _result = "无";
  StreamSubscription _themeModelscription;
  bool isWx = true;
  bool wxClick = true;
  bool isReviewing = true;

  @override
  void initState() {
    super.initState();
    _themeModelscription = eventBus.on<LoginEvent>().listen((event) {
      this.isWx = event.isWx;
      if (event.isClose) {
        Navigator.pop(context);
        return;
      }
    });
    if (!isWx) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // getReviewing();
    });

    //   fluwx.weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
    //     if (res is fluwx.WeChatAuthResponse) {
    //       if (res.isSuccessful == false) {
    //         return;
    //       }
    //       setState(() async {
    //         if (isWx) {
    //           Map<String, dynamic> map = {'code': res.code};
    //           var bean = await ApiUser.openLogin(map);
    //           int ret = bean['ret'];
    //           WxBean wxBean = bean['bean'];
    //           if (ret == 0) {
    //             wxClick = true;
    //             //Util.showToast(bean['msg']);
    //             return;
    //           }
    //           wxClick = true;
    //           if (wxBean.token.isEmpty) {
    //             var s = await Navigator.pushNamed(context, '/bindingPhone',
    //                 arguments: {
    //                   "out_id": wxBean.outId.toString(),
    //                   'token': wxBean.session
    //                 });
    //             int result = s;
    //             if (result == 0) {
    //               Routers.pop(context);
    //             }
    //             return;
    //           }
    //           FocusScope.of(context).requestFocus(FocusNode());
    //           String token = wxBean.tokenType + ' ' + wxBean.token;
    //           Provider.of<Model>(context, listen: false).setToken(token);
    //           Provider.of<ShopInfoProvider>(context, listen: false).getShopInfo();
    //           Provider.of<AgentInfoProvider>(context, listen: false)
    //               .getAgentInfo();
    //           LocalStorage.saveToken(token);
    //           LocalStorage.saveCompleteInfo(wxBean.completeinfo);
    //           ApplicationEvent.event.fire(new HomeRefresh());
    //           Util.showToast(S.of(context).loginSuccessful);
    //           Routers.pop(context);
    //         }
    //       });
    //     }
    //   });
  }

  @override
  void dispose() {
    super.dispose();

    _result = null;
    _themeModelscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PublicView().initBar(S.of(context).accountLogin),
      body: GestureDetector(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _appName(),
              _loginInfo(context),
              _weChatLogin(),
            ],
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
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
            mobileLogin(),
            loginButton(),
            registerButton(),
          ],
        ),
      ),
    );
  }

  Widget mobileLogin() {
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 20),
              child:
                  PublicView().getText(S.of(context).quickLogin, '#1C1717', 15),
            ),
            onTap: () async {
              var a = await Navigator.pushNamed(context, '/mobileLogin');
              int result = a;
              if (result == 0) {
                Navigator.pop(context);
              }
            },
          ),
          flex: 1,
        ),
        Expanded(
          child: GestureDetector(
            child: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(top: 20),
              child: PublicView()
                  .getText(S.of(context).forgetPassword, '#1C1717', 15),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/resetPassword');
            },
          ),
          flex: 1,
        )
      ],
    );
  }

  Widget registerButton() {
    return GestureDetector(
        child: Container(
          height: 44,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
            border: new Border.all(color: HexToColor('#1C1717'), width: 1),
            borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
          ),
          child: Text(
            S.of(context).register,
            style: TextStyle(color: HexToColor('#1C1717'), fontSize: 18),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/register');
        });
  }

  Widget loginButton() {
    return GestureDetector(
      child: Container(
        height: 44,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 40),
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
          color: HexToColor('#1C1717'),
        ),
        child: Text(
          S.of(context).login,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());

        if (_phoneController.text.isEmpty) {
          Util.showToast(S.of(context).pleaseInputMobileNumber);
          return;
        }
        if (_phoneController.text.startsWith('0')) {
          Util.showToast('手机号码格式有误，号码前请不要加0');
          return;
        }
        if (_passwordController.text.isEmpty) {
          Util.showToast(S.of(context).pleaseInputPassword);
          return;
        }

        Map<String, dynamic> map = {
          'phone': _phoneController.text,
          'password': _passwordController.text,
          //'timezone': countryCode
        };
        var bean = await Api.login(map);
        String msg = bean['msg'];
        LoginBean loginBean = bean['bean'];
        if (msg != null && msg.length > 0) {
          //Util.showToast(msg);
          return;
        }
        String token = loginBean.tokenType + ' ' + loginBean.accessToken;
        Provider.of<Model>(context, listen: false).setToken(token);
        Provider.of<ShopInfoProvider>(context, listen: false).getShopInfo();
        Provider.of<AgentInfoProvider>(context, listen: false).getAgentInfo();
        LocalStorage.saveToken(token);
        LocalStorage.saveCompleteInfo(loginBean.completeinfo);
        ApplicationEvent.event.fire(new HomeRefresh());
        Util.showToast(S.of(context).loginSuccessful);
        Routers.pop(context);
      },
    );
  }

  Widget buildLoginPasswordTextField() {
    return new Padding(
      padding: new EdgeInsets.all(5),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: _passwordController,
            maxLines: 1,
            cursorColor: Theme.of(context).primaryColor,
            obscureText: true,
            decoration: new InputDecoration(
                hintText: S.of(context).pleaseInputPassword,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 15,
                )),
          )),
        ],
      ),
    );
  }

  Widget buildLoginNameTextField() {
    return new Padding(
      padding: new EdgeInsets.all(5),
      child: new Row(
        children: <Widget>[
          /* GestureDetector(
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
          SizedBox(width: 20.0),*/
          new Expanded(
              child: new TextField(
            controller: _phoneController,
            maxLines: 1,
            cursorColor: Theme.of(context).primaryColor,
            keyboardType: TextInputType.emailAddress,
            decoration: new InputDecoration(
                hintText: '手机号/邮箱',
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

  Widget _weChatLogin() {
    return new Offstage(
      offstage: isReviewing,
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 40),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            PublicView().getText(S.of(context).thirdPartyLogin, '#AFAFAF', 12),
            SizedBox(
              height: 10,
            ),
            new GestureDetector(
              child: new Image.asset(
                'assets/images/common/weChat.png',
                width: 40,
                height: 40,
              ),
              onTap: () {
                if (wxClick) {
                  wxClick = false;
                  loginWX();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void loginWX() {
    // fluwx.isWeChatInstalled.then((installed) {
    //   if (installed) {
    //     fluwx
    //         .sendWeChatAuth(
    //             scope: "snsapi_userinfo", state: "wechat_sdk_demo_test")
    //         .then((data) {})
    //         .catchError((e) {});
    //   } else {
    //     Util.showToast("请先安装微信");
    //   }
    // });
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

  void getReviewing() async {
    int re = await LocalStorage.getIsReviewing();
    String code = await LocalStorage.getDefaultPhoneCode();
    if (re == 0) {
      setState(() {
        isReviewing = false;
      });
    } else {
      setState(() {
        isReviewing = true;
      });
    }
    setState(() {
      countryCode = code;
    });
  }
}
