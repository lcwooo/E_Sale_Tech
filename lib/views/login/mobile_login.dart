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
import 'package:E_Sale_Tech/views/me/agent_provider.dart';
import 'package:E_Sale_Tech/views/shop/shop_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:E_Sale_Tech/views/login/login_event.dart';
// import 'package:fluwx/fluwx.dart' as fluwx;

class MobileLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PageIndexState();
  }
}

class _PageIndexState extends State<MobileLogin> {
  PackageInfo packageInfo;
  var _phoneController = new TextEditingController();
  var _codeController = new TextEditingController();
  String sent = S().clickSend;
  bool isButtonEnable = true;
  Timer timer;
  int count = 60;
  String countryCode = "31";
  String codeColor = '#0DAC32';
  StreamSubscription _themeModelscription;
  bool isReviewing = true;

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
    FocusScope.of(context).requestFocus(FocusNode());
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
    _themeModelscription = eventBus.on<LoginEvent>().listen((event) {
      if (event.isClose) {
        Navigator.pop(context);
        return;
      }
    });

    // fluwx.weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
    //   if (res is fluwx.WeChatAuthResponse) {
    //     if (res.isSuccessful == false) {
    //       return;
    //     }
    //     setState(() async {
    //       Map<String, dynamic> map = {'code': res.code};
    //       var bean = await ApiUser.openLogin(map);
    //       int ret = bean['ret'];
    //       WxBean wxBean = bean['bean'];
    //       if (ret == 0) {
    //         //Util.showToast(bean['msg']);
    //         return;
    //       }
    //       if (wxBean.token.isEmpty) {
    //         var s = await Navigator.pushNamed(context, '/bindingPhone',
    //             arguments: {
    //               "out_id": wxBean.outId.toString(),
    //               'token': wxBean.session
    //             });
    //         int result = s;
    //         if (result == 0) {
    //           Routers.pop(context);
    //         }
    //         return;
    //       }
    //       //eventBus.fire(new LoginEvent(true, true));
    //       FocusScope.of(context).requestFocus(FocusNode());
    //       String token = wxBean.tokenType + ' ' + wxBean.token;
    //       Provider.of<Model>(context, listen: false).setToken(token);
    //       Provider.of<ShopInfoProvider>(context, listen: false).getShopInfo();
    //       Provider.of<AgentInfoProvider>(context, listen: false).getAgentInfo();
    //       LocalStorage.saveToken(token);
    //       LocalStorage.saveCompleteInfo(wxBean.completeinfo);
    //       ApplicationEvent.event.fire(new HomeRefresh());
    //       Util.showToast(S.of(context).loginSuccessful);
    //       Navigator.of(context).pop(0);
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    timer?.cancel(); //销毁计时器
    timer = null;
    _themeModelscription.cancel();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PublicView().initBar(S.of(context).mobileQuickLogin),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _appName(),
                _loginInfo(context),
                _weChatLogin(),
              ],
            ),
          )),
    );
  }

  Widget _appName() {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 30, bottom: 30),
        child: new Image.asset(
          'assets/images/common/user_logo.png',
          width: 73,
          height: 73,
        ),
      ),
    );
  }

  Widget _loginInfo([BuildContext context]) {
    return Container(
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
          loginButton(),
        ],
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
        if (_codeController.text.isEmpty) {
          Util.showToast(S.of(context).verificationCode);
          return;
        }
        Map<String, dynamic> map = {
          'phone': _phoneController.text,
          'code': _codeController.text
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
        Navigator.of(context).pop(0);
      },
    );
  }

  Widget line() {
    return Divider(
      height: 1.0,
      indent: 0,
      color: HexToColor('#464646'),
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
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            maxLines: 1,
            cursorColor: Theme.of(context).primaryColor,
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

  Widget buildLoginPasswordTextField() {
    return new Padding(
      padding: new EdgeInsets.all(5),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: _codeController,
            maxLines: 1,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              if (_phoneController.text.startsWith('0')) {
                Util.showToast('手机号码格式有误，号码前请不要加0');
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
              FocusScope.of(context).requestFocus(FocusNode());
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

  Widget _weChatLogin() {
    return new Offstage(
      offstage: isReviewing,
      child: Container(
        padding: EdgeInsets.all(40),
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            PublicView().getText(S.of(context).thirdPartyLogin, '#AFAFAF', 12),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: new Image.asset(
                'assets/images/common/weChat.png',
                width: 40,
                height: 40,
              ),
              onTap: () {
                eventBus.fire(new LoginEvent(false, false));
                loginWX();
              },
            ),
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
}
