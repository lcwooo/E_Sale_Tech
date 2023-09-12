import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';

class MePage extends StatefulWidget {
  MePage({this.arguments});

  final Map arguments;

  @override
  _MePageState createState() => new _MePageState();
}

class _MePageState extends State<MePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // life circle
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("======build======");
    return Scaffold(
      key: _scaffoldKey,
      appBar: MyAppBar(
        centerTitle: "Me",
        isBack: false,
      ),
      body: Column(
        children: <Widget>[
          RaisedButtonCustom(
            onPressed: () {
              Routers.push('/language', context);
            },
          ),
          Text('${S.of(context).language}'),
          RaisedButtonCustom(
              onPressed: () {
                Routers.push('/mobileLogin', context);
              },
              txt: S.of(context).mobileQuickLogin),
          RaisedButtonCustom(
              onPressed: () {
                Routers.push('/login', context);
              },
              txt: '账号密码登录'),
          RaisedButtonCustom(
              onPressed: () {
                Routers.push('/resetPassword', context);
              },
              txt: '密码重置'),
          RaisedButtonCustom(
              onPressed: () {
                Routers.push('/userStatus', context,{"id": 1});
                //Navigator.pushNamed(context, '/userStatus', arguments: {"id": 20});
              },
              txt: '登录注册的各种状态页面通用'),
        ],
      ),
    );
  }
}
