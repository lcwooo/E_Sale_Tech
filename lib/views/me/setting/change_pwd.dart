import 'package:E_Sale_Tech/api/me.dart';
import 'package:E_Sale_Tech/model/index.dart';
import 'package:E_Sale_Tech/utils/click_upload_image.dart';
import 'package:E_Sale_Tech/utils/localstorage.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/me/my_address/address_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:E_Sale_Tech/components/click_item.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePwd extends StatefulWidget {
  @override
  _ChangePwdState createState() => _ChangePwdState();
}

class _ChangePwdState extends State<ChangePwd> {
  String version = "";

  final subtitleStyle = TextStyle(color: Color(0xff999999));

  TextEditingController _oldPwdController = TextEditingController();
  TextEditingController _newPwdController = TextEditingController();
  TextEditingController _secondPwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffF8F8F8),
      appBar: MyAppBar(
        centerTitle: '修改密码',
      ),
      body: Container(
        margin: EdgeInsets.only(
          left: ScreenUtil().screenWidth * 0.1,
          top: ScreenUtil().screenHeight * 0.25,
        ),
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth * 0.8,
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: '旧密码'),
              controller: _oldPwdController,
              obscureText: true,
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(hintText: '新密码'),
              controller: _newPwdController,
              obscureText: true,
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(hintText: '确认新密码'),
              controller: _secondPwdController,
              obscureText: true,
            ),
            Container(
              width: ScreenUtil().screenWidth * 0.8,
              height: 44,
              margin: EdgeInsets.only(top: 24),
              child: RaisedButtonCustom(
                textStyle: null,
                shape: Border.all(
                  // 设置边框样式
                  color: AppColor.white,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
                textColor: AppColor.white,
                color: AppColor.themeRed,
                txt: '提交',
                onPressed: () {
                  if (_oldPwdController.text == '') {
                    Util.showToast('旧密码不能为空');
                    return;
                  }
                  if (_newPwdController.text == '') {
                    Util.showToast('新密码不能为空');
                    return;
                  }
                  if (_secondPwdController.text == '') {
                    Util.showToast('验证密码不能为空');
                    return;
                  }
                  if (_secondPwdController.text != _newPwdController.text) {
                    Util.showToast('两次输入的密码不一致');
                    return;
                  }
                  ApiMe.updatePwd({
                    'oldpassword': _oldPwdController.text,
                    'newpassword': _newPwdController.text,
                    'secondpassword': _secondPwdController.text,
                  }).then((value) {
                    if (value == 1) {
                      Util.showToast('修改成功');
                      Routers.pop(context);
                      return;
                    }
                    Util.showToast('修改失败');
                    return;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
