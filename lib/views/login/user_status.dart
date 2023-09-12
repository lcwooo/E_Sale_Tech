import 'package:E_Sale_Tech/views/login/login_config.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/utils/util.dart';

class UserStatus extends StatefulWidget {
  final Map arguments;

  UserStatus({this.arguments});

  @override
  _UserStatusState createState() {
    return _UserStatusState(arguments: arguments);
  }
}

class _UserStatusState extends State<UserStatus> {
  final Map arguments;

  _UserStatusState({this.arguments});

  @override
  void initState() {
    print('======state======${arguments["id"]}');
    super.initState();
  }

  @override
  void dispose() {
    print('======dispose======');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: checkBar(),
      body: checkBody(),
    );
  }

  Widget checkBar() {
    int state = arguments["id"];
    switch (state) {
      case 0:
        return PublicView().initBar("重置成功");
        break;
      case 1:
        return PublicView().initBar("重置成功");
        break;
      case 2:
        return PublicView().initBar("注册成功");
        break;
    }
    return null;
  }

  Widget checkBody() {
    int state = arguments["id"];
    switch (state) {
      case 0: //绑定手机
        return bindingPhone('恭喜，绑定手机成功！');
        break;
      case 1: //重置密码
        return bindingPhone('恭喜，重置登录密码成功！');
        break;
      case 2: //注册成功
        return loginSuccess();
        break;
    }
    return null;
  }

  Widget loginSuccess() {
    return Column(
      children: <Widget>[
        Container(
          height: 120,
          alignment: Alignment.center,
          child: new Image.asset(
            'assets/images/common/smile.png',
            width: 56,
            height: 56,
          ),
        ),
        Text(
          '注册成功，待审核！',
          style: TextStyle(
            color: HexToColor('#1C1717'),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 40, right: 30, left: 30),
          child: Text(
            '恭喜，注册申请已经提交成功，等待管理员审核！审核结果会发送短信至您的注册手机号，请留意信息。',
            style: TextStyle(
              color: HexToColor('#1C1717'),
              fontSize: 14,
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            height: 44,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 80, right: 30, left: 30),
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
              color: HexToColor('#1C1717'),
            ),
            child: Text(
              '确定',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          onTap: () {
            Util.showToast('注册审核中');
          },
        ),
      ],
    );
  }

  Widget bindingPhone(String info) {
    return Column(
      children: <Widget>[
        Container(
          height: 120,
          alignment: Alignment.center,
          child: new Image.asset(
            'assets/images/common/smile.png',
            width: 56,
            height: 56,
          ),
        ),
        Text(
          info,
          style: TextStyle(
            color: HexToColor('#1C1717'),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        GestureDetector(
          child: Container(
            height: 44,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 80, right: 30, left: 30),
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
              color: HexToColor('#1C1717'),
            ),
            child: Text(
              '登录',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          onTap: () {
            Util.showToast('绑定手机成功');
          },
        ),
      ],
    );
  }
}
