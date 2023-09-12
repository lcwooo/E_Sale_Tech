import 'dart:convert';

import 'package:E_Sale_Tech/api/log_util.dart';
import 'package:E_Sale_Tech/api/me.dart';
import 'package:E_Sale_Tech/components/click_item.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/components/input/normal_input.dart';
import 'package:E_Sale_Tech/components/input/base_input.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/model/me/agent_info.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/me/agent_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ComplateProfile extends StatefulWidget {
  @override
  _ComplateProfileState createState() => _ComplateProfileState();
}

class _ComplateProfileState extends State<ComplateProfile> {
  bool isEdit = false;
  bool isVerified = false;

  final subtitleStyle = TextStyle(color: Color(0xff999999));

  String country = '中国';

  FocusNode _countryFocus = FocusNode();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _countryController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  final FocusNode _nodeName = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MyAppBar(
        actionName: '保存',
        centerTitle: '完善资料',
        onPressed: () async {
          if (_lastNameController.text == '') {
            Util.showToast('名不能为空');
            return;
          }
          if (_firstNameController.text == '') {
            Util.showToast('姓不能为空');
            return;
          }
          if (_emailController.text == '') {
            Util.showToast('邮箱不能为空');
            return;
          }
          if (!_isValidEmail(_emailController.text)) {
            Util.showToast('邮箱不合法');
            return;
          }
          if (country == '') {
            Util.showToast('国家不能为空');
            return;
          }
          if (_addressController.text == '') {
            Util.showToast('详细地址不能为空');
            return;
          }
          int ret = await ApiMe.updateAgentInfo({
            'surname': _lastNameController.text,
            'name': _firstNameController.text,
            'email': _emailController.text,
            'country': country,
            'address': _addressController.text,
          });
          if (ret == 1) {
            Provider.of<AgentInfoProvider>(context, listen: false)
                .getAgentInfo();
            Util.showToast('保存成功');
            Routers.pop(context);
            return;
          }
          Util.showToast('保存失败');
          return;
        },
      ),
      body: Container(
          child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
              flex: 8,
              child: Container(
                // color: Colors.red,
                padding: EdgeInsets.only(top: 23),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 30,
                          child: TextField(
                            cursorColor: AppColor.themeRed,
                            decoration: InputDecoration(hintText: '姓'),
                            controller: _firstNameController,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 70,
                          child: TextField(
                            cursorColor: AppColor.themeRed,
                            decoration: InputDecoration(hintText: '名'),
                            controller: _lastNameController,
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      cursorColor: AppColor.themeRed,
                      decoration: InputDecoration(hintText: '邮箱'),
                      controller: _emailController,
                    ),
                    InkWell(
                      child: Stack(
                        children: <Widget>[
                          TextField(
                            cursorColor: AppColor.themeRed,
                            enabled: false,
                            decoration: InputDecoration(hintText: '国家'),
                            controller: _countryController,
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: ScreenUtil().screenWidth,
                            height: 50,
                            // color: Colors.red,
                            child: Icon(Icons.keyboard_arrow_right),
                          ),
                        ],
                      ),
                      onTap: () async {
                        var s =
                            await Navigator.pushNamed(context, '/phoneCode');
                        String a = s;
                        // Log.i("当前返回的结果为" + a);
                        if (a != null) {
                          setState(() {
                            _countryController.text =
                                a.substring(a.indexOf('=') + 1);
                          });
                        }
                      },
                    ),
                    TextField(
                      cursorColor: AppColor.themeRed,
                      decoration: InputDecoration(hintText: '地址详情'),
                      controller: _addressController,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 69),
                      child: Column(
                        children: <Widget>[
                          Text(
                            this.isVerified ? '当前账号已实名认证' : '当前账号还未实名认证',
                            style: TextStyle(color: AppColor.themeRed),
                          ),
                          this.isVerified
                              ? Text('')
                              : RaisedButtonCustom(
                                  shape: Border.all(
                                    // 设置边框样式
                                    color: AppColor.themeRed,
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                  ),
                                  textColor: AppColor.themeRed,
                                  color: Colors.white,
                                  txt: '立即认证',
                                  padding: EdgeInsets.only(
                                    left: 50,
                                    right: 50,
                                    top: 1,
                                    bottom: 1,
                                  ),
                                  onPressed: () {
                                    Routers.push('/realNameAuthen', context);
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      )),
    );
  }

  bool _isValidEmail(String email) {
    if (email.contains('@')) {
      return true;
    }
    return false;
  }

  void _loadData() async {
    AgentInfo info = await ApiMe.getAgentInfo();
    var names = info.name.split(" ");
    String firstName = '';
    String lastName = '';
    if (names.length != 0) {
      firstName = names[0];
      if (names.length > 1) {
        lastName = names[1];
        for (var i = 2; i < names.length; i++) {
          lastName = lastName + '' + names[i];
        }
      }
    }

    this.setState(() {
      this._firstNameController.text = firstName;
      this._lastNameController.text = lastName;
      this._emailController.text = info.email;
      this._countryController.text = info.country;
      this._addressController.text = info.address;
      this.isVerified = info.isVerified == 1;
    });
  }
}
