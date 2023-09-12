import 'package:E_Sale_Tech/api/common.dart';
import 'package:E_Sale_Tech/api/goods.dart';
import 'package:E_Sale_Tech/api/home.dart';
import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/components/input/normal_input.dart';
import 'package:E_Sale_Tech/components/load_image.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/click_upload_image.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:E_Sale_Tech/components/common_button/icon_text_button.dart';

class RealNamePage extends StatefulWidget {
  RealNamePage({this.arguments});
  final Map arguments;
  @override
  _RealNamePageState createState() => new _RealNamePageState();
}

class _RealNamePageState extends State<RealNamePage>
    with AutomaticKeepAliveClientMixin {
  final textEditingController = TextEditingController();
  @override
  bool get wantKeepAlive => true;

  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _textContactController = new TextEditingController();
  final FocusNode _nodeContact = FocusNode();

  int direction;
  String frontUrl = "";
  String backUrl = "";
  get detailData => null;

  @override
  void initState() {
    super.initState();
    // life circle
    textEditingController.text = 'XXX';
    // 监听文本变化
    textEditingController.addListener(() {
      debugPrint('input: ${textEditingController.text}');
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: MyAppBar(
        centerTitle: "实名认证",
        isBack: true,
        backToRoot: true,
        backBtnPress: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/main',
            (route) => false, //true 保留当前栈 false 销毁所有 只留下RepeatLogin
            arguments: {},
          );
        },
        actionName: "跳过",
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/main',
            (route) => false, //true 保留当前栈 false 销毁所有 只留下RepeatLogin
            arguments: {},
          );
        },
      ),
      bottomNavigationBar: Material(
        //底部栏整体的颜色
        color: AppColor.themeRed,
        child: FlatButton(
          child: new Padding(
            padding: new EdgeInsets.all(0),
            child: Text("提交认证",
                style: TextStyle(
                    color: AppColor.white, fontWeight: FontWeight.w300)),
          ),
          color: AppColor.themeRed,
          onPressed: () {
            applyIdCard();
          },
        ),
      ),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: new Container(
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFF5F5F9), width: 0.8)),
          height: 350,
          width: ScreenUtil().screenWidth,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(right: 15, left: 15, top: 10),
                height: 80,
                width: ScreenUtil().screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("身份证照片",
                            style: TextStyle(
                                color: AppColor.mainTextColor, fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "信息仅用于身份验证，我们将保证您信息安全",
                            style: TextStyle(
                                color: Color(0xFFCCCCCC), fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 15),
                  new GestureDetector(
                    onTap: () {
                      direction = 1;
                      photoClick();
                    },
                    child: Container(
                      width: (ScreenUtil().screenWidth - 60) / 2,
                      height: 120,
                      child: Stack(
                        children: <Widget>[
                          ConstrainedBox(
                            constraints: BoxConstraints.expand(),
                            child: LoadImage(
                              frontUrl,
                              fit: BoxFit.fitWidth,
                              holderImg: "home/人像面@3x",
                              format: "png",
                            ),
                          ),
                          new Positioned(
                              //方法二
                              bottom: 20,
                              width: (ScreenUtil().screenWidth - 60) / 2,
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/home/相机@3x.png",
                                    fit: BoxFit.fitWidth,
                                    width: 50,
                                    height: 50,
                                  ),
                                  Text(
                                    "上传人像面",
                                    style: TextStyle(fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  new GestureDetector(
                    onTap: () {
                      direction = 2;
                      photoClick();
                    },
                    child: Container(
                      width: (ScreenUtil().screenWidth - 60) / 2,
                      height: 120,
                      child: Stack(
                        children: <Widget>[
                          ConstrainedBox(
                            constraints: BoxConstraints.expand(),
                            child: LoadImage(
                              backUrl,
                              fit: BoxFit.fitWidth,
                              holderImg: "home/国徽面@3x",
                              format: "png",
                            ),
                          ),
                          new Positioned(
                            //方法二
                            bottom: 20,
                            width: (ScreenUtil().screenWidth - 60) / 2,
                            child: Column(
                              children: <Widget>[
                                Image.asset(
                                  "assets/images/home/相机@3x.png",
                                  fit: BoxFit.fitWidth,
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                  "上传国徽面",
                                  style: TextStyle(fontSize: 13),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Container(
                  padding: EdgeInsets.only(right: 15, left: 15, top: 10),
                  height: 80,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            "联系方式",
                            style: TextStyle(
                                fontSize: 16, color: AppColor.mainTextColor),
                          )),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: NormalInput(
                              hintText: "根据监管要求，需要提供联系方式以做备案",
                              controller: _textContactController,
                              focusNode: _nodeContact,
                              autoFocus: detailData != null,
                              keyboardType: TextInputType.text,
                              onSubmitted: (res) {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                            )),
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void applyIdCard() {
    if (frontUrl.isEmpty) {
      Util.showToast("请上传人像面身份证");
      return;
    }
    if (backUrl.isEmpty) {
      Util.showToast("请上传国徽面身份证");
      return;
    }
    if (_textContactController.text.isEmpty) {
      Util.showToast("请提供联系方式");
      return;
    }
    Map par = {
      "id_card_front": frontUrl,
      "id_card_back": backUrl,
      "contact": _textContactController.text,
    };
    ApiHome.applyIDCard(par, (data) {
      if (data["ret"] == 1) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/main',
          (route) => false, //true 保留当前栈 false 销毁所有 只留下RepeatLogin
          arguments: {},
        );
        Util.showToast("认证成功");
      }
    }, (message) => null);
  }

  void photoClick() {
    ClickUploadImage.showIDCardActionSheet(
      onSuccessCallback: (image) async {
        if (direction == 1) {
          var imageData = await Api.uploadIDCardImage(image, 'front');
          setState(() {
            frontUrl = imageData["path"];
          });
        } else if (direction == 2) {
          var imageData = await Api.uploadIDCardImage(image, 'back');
          if (imageData != null) {
            setState(() {
              backUrl = imageData['path'];
            });
          }
        }
      },
      context: context,
      child: CupertinoActionSheet(
        title: const Text('请选择上传方式'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text('相册'),
            onPressed: () {
              Navigator.pop(context, 'gallery');
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('照相机'),
            onPressed: () {
              Navigator.pop(context, 'camera');
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('取消'),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
      ),
    );
  }
}
