import 'dart:async';
import 'dart:ffi';

import 'package:E_Sale_Tech/api/home.dart';
import 'package:E_Sale_Tech/api/user.dart';
import 'package:E_Sale_Tech/components/input/client_input.dart';
import 'package:E_Sale_Tech/components/input/normal_input.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/localstorage.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/login/public.dart';
import 'package:E_Sale_Tech/views/shop/shop_provider.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:E_Sale_Tech/components/inpute_text_item.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class FillInformationPage extends StatefulWidget {
  FillInformationPage({this.arguments});
  final Map arguments;
  @override
  _FillInformationPageState createState() => new _FillInformationPageState();
}

class _FillInformationPageState extends State<FillInformationPage>
    with AutomaticKeepAliveClientMixin {
  final textEditingController = TextEditingController();
  @override
  bool get wantKeepAlive => true;

  String sent = S().clickSend;
  String codeColor = '#0DAC32';
  bool isButtonEnable = true;
  Timer timer;
  int count = 60;
  bool isRequest = false;
  bool isLoading = false;

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

// 电话区号
  String countryCodeID = "";
// 账户类型
  int accountType = 0;
// 名字
  String nameStr = "";
// 姓
  String surnameStr = "";
// 国家
  String country = "请选择国家";
  String countryCode = "";
// 城市
  String cityStr = "";
// 街道名称
  String streetNameStr = "";
// 门牌号
  String doorNumberStr = "";
// 增值税
  String vatcodeStr = "";
// 商会编号
  String commerceNumStr = "";
// 公司编码
  String compainNameStr = "";
// 邮政编码
  String expressNoStr = "";
// 备注
  String remarkForAddStr = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // 电话号码
  TextEditingController _mobileController = new TextEditingController();
  final FocusNode _nodeMobile = FocusNode();
  // 验证码
  TextEditingController _codeController = new TextEditingController();
  final FocusNode _nodeCode = FocusNode();
  // 名字
  TextEditingController _textNameController = new TextEditingController();
  final FocusNode _nodeName = FocusNode();
  // 姓
  TextEditingController _textSurnameController = new TextEditingController();
  final FocusNode _nodeSurname = FocusNode();
  // 市
  TextEditingController _textCityController = new TextEditingController();
  final FocusNode _nodeCity = FocusNode();
  // 公司名称
  TextEditingController _textCompainNameController =
      new TextEditingController();
  final FocusNode _nodeCompainName = FocusNode();
  // 商会编号
  TextEditingController _textCommerceNumController =
      new TextEditingController();
  final FocusNode _nodeCommerceNum = FocusNode();
  // 增值税编码
  TextEditingController _textVATcodeController = new TextEditingController();
  final FocusNode _nodeVATcode = FocusNode();
  // 街道名称
  TextEditingController _textStreetNameController = new TextEditingController();
  final FocusNode _nodeStreetName = FocusNode();
  // 门牌号
  TextEditingController _textDoorNumController = new TextEditingController();
  final FocusNode _nodeDoorNum = FocusNode();
  // 邮政编码
  TextEditingController _textExpressNoController = new TextEditingController();
  final FocusNode _nodeExpressNo = FocusNode();
  // 附加地址
  TextEditingController _textRemarkForAddController =
      new TextEditingController();
  final FocusNode _nodeRemarkForAdd = FocusNode();

  FocusNode blankNode = FocusNode();

  List goodPhotoList = [];

  @override
  void initState() {
    super.initState();
    // life circle
    textEditingController.text = 'XXX';
    // 监听文本变化
    textEditingController.addListener(() {
      debugPrint('input: ${textEditingController.text}');
    });
    getAgeement();
  }

  void getAgeement() async {
    String code = await LocalStorage.getDefaultPhoneCode();
    var a = await rootBundle
        .loadString('assets/images/common/service_agreement.txt');
    setState(() {
      // agreementString = a;
      countryCodeID = code;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  String getType(int type) {
    switch (type) {
      case 0:
        return "请选择账户类型";
        break;
      case 1:
        return "个人账户";
        break;
      case 2:
        return "公司账户";
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: MyAppBar(
          centerTitle: "完善资料",
          isBack: true,
        ),
        bottomNavigationBar: Material(
          //底部栏整体的颜色
          color: AppColor.themeRed,
          child: FlatButton(
            child: new Padding(
              padding: new EdgeInsets.all(0),
              child: Text("提交资料",
                  style: TextStyle(
                      color: AppColor.mainTextColor,
                      fontWeight: FontWeight.w300)),
            ),
            color: AppColor.themeRed,
            onPressed: () async {
              if (!charmData()) {
                return;
              }
              Map par;
              if (accountType == 1) {
                par = {
                  "account_type": accountType,
                  "f_name": nameStr,
                  "l_name": surnameStr,
                  "country_code": countryCode,
                  "city": cityStr,
                  "street": streetNameStr,
                  "door_no": doorNumberStr,
                  "post_code": expressNoStr,
                  "extra_address": remarkForAddStr,
                  'area_code': countryCodeID,
                  'phone': _mobileController.text,
                  'verify_code': _codeController.text
                };
              } else {
                par = {
                  "account_type": accountType,
                  "f_name": nameStr,
                  "l_name": surnameStr,
                  "country_code": countryCode,
                  "city": cityStr,
                  "street": streetNameStr,
                  "door_no": doorNumberStr,
                  "post_code": expressNoStr,
                  "extra_address": remarkForAddStr,
                  "company_info": {
                    "invoice_code": vatcodeStr,
                    "chamber_number": commerceNumStr,
                    "name": compainNameStr,
                  },
                  'area_code': countryCodeID,
                  'phone': _mobileController.text,
                  'verify_code': _codeController.text
                };
              }
              ApiHome.perfectInformation(par, (data) {
                if (data["ret"] == 1) {
                  Util.showToast('提交成功');
                  // Routers.push('/realNameAuthen', context);
                  // 完善信息成功
                  LocalStorage.saveCompleteInfo(true);
                  ApplicationEvent.event.fire(new HomeRefresh());
                  Provider.of<ShopInfoProvider>(context, listen: false)
                      .getShopInfo();
                  Routers.pop(context);
                }
              }, (message) {});
            },
          ),
        ),
        body: isRequest
            ? Container(
                child: Center(
                  child: SpinKitFoldingCube(color: Colors.black),
                ),
              )
            : Util.buildLoadingWithWiget(
                context,
                new GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min, // 设置最小的弹出
                                    children: <Widget>[
                                      new ListTile(
                                        // leading: new Icon(Icons.person_outline),
                                        title: new Text("个人账户"),
                                        onTap: () {
                                          setState(() {
                                            accountType = 1;
                                            Navigator.of(context).pop();
                                          });
                                        },
                                      ),
                                      new ListTile(
                                        // leading: new Icon(Icons.photo_library),
                                        title: new Text("公司账户"),
                                        onTap: () {
                                          setState(() {
                                            accountType = 2;
                                            Navigator.of(context).pop();
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: InputTextItem(
                              title: "账户类型",
                              inputText: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    getType(accountType),
                                    style: (accountType == 0)
                                        ? AppText.textGray14
                                        : AppText.textDark14,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 15, top: 10, bottom: 10),
                                    child: Icon(Icons.arrow_forward_ios),
                                  ),
                                ],
                              )),
                        ),
                        buildLoginNameTextField(),
                        line(),
                        buildLoginPasswordTextField(),
                        line(),
                        InputTextItem(
                            title: "*名字",
                            inputText: NormalInput(
                              hintText: "请填写英文",
                              controller: _textNameController,
                              focusNode: _nodeName,
                              autoFocus: false,
                              keyboardType: TextInputType.text,
                              onSubmitted: (res) {
                                FocusScope.of(context)
                                    .requestFocus(_nodeSurname);
                              },
                              onChanged: (res) {
                                nameStr = res;
                              },
                            )),
                        InputTextItem(
                            title: "*姓",
                            inputText: NormalInput(
                              hintText: "请填写英文",
                              controller: _textSurnameController,
                              focusNode: _nodeSurname,
                              autoFocus: false,
                              keyboardType: TextInputType.text,
                              onSubmitted: (res) {
                                FocusScope.of(context).requestFocus(_nodeCity);
                              },
                              onChanged: (res) {
                                surnameStr = res;
                              },
                            )),
                        GestureDetector(
                          onTap: () async {
                            var s = await Navigator.pushNamed(
                                context, '/phoneCode');
                            String a = s;
                            if (a == null) {
                              return;
                            }
                            setState(() {
                              country = a.split("=")[1];
                              countryCode = a.split("=")[0];
                              // state = a.substring(a.indexOf('=') + 1);
                              // isSelectState = true;
                            });
                          },
                          child: InputTextItem(
                              title: "*国家",
                              inputText: Container(
                                margin: EdgeInsets.only(left: 11),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      country,
                                      style: country.isEmpty
                                          ? AppText.textGray14
                                          : AppText.textDark14,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: 15, top: 10, bottom: 10),
                                      child: Icon(Icons.arrow_forward_ios),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        InputTextItem(
                            title: "*城市",
                            inputText: NormalInput(
                              hintText: "请填写英文",
                              controller: _textCityController,
                              focusNode: _nodeCity,
                              autoFocus: false,
                              keyboardType: TextInputType.text,
                              onSubmitted: (res) {
                                if (accountType == 2) {
                                  FocusScope.of(context)
                                      .requestFocus(_nodeCompainName);
                                } else {
                                  FocusScope.of(context)
                                      .requestFocus(_nodeStreetName);
                                }
                              },
                              onChanged: (res) {
                                cityStr = res;
                              },
                            )),
                        Container(
                          height: (accountType != 2) ? 0 : 55,
                          child: InputTextItem(
                              title: "*公司名称",
                              inputText: NormalInput(
                                hintText: "请填写英文",
                                controller: _textCompainNameController,
                                focusNode: _nodeCompainName,
                                autoFocus: false,
                                keyboardType: TextInputType.text,
                                onSubmitted: (res) {
                                  FocusScope.of(context)
                                      .requestFocus(_nodeCommerceNum);
                                },
                                onChanged: (res) {
                                  compainNameStr = res;
                                },
                              )),
                        ),
                        Container(
                            height: (accountType != 2) ? 0 : 55,
                            child: InputTextItem(
                                title: "*商会编号",
                                inputText: NormalInput(
                                  hintText: "请填写英文",
                                  controller: _textCommerceNumController,
                                  focusNode: _nodeCommerceNum,
                                  autoFocus: false,
                                  keyboardType: TextInputType.text,
                                  onSubmitted: (res) {
                                    FocusScope.of(context)
                                        .requestFocus(_nodeVATcode);
                                  },
                                  onChanged: (res) {
                                    commerceNumStr = res;
                                  },
                                ))),
                        Container(
                            height: (accountType != 2) ? 0 : 55,
                            child: InputTextItem(
                                title: "*增值税编码",
                                leftFlex: 2,
                                rightFlex: 5,
                                inputText: NormalInput(
                                  hintText: "请填写英文",
                                  controller: _textVATcodeController,
                                  focusNode: _nodeVATcode,
                                  autoFocus: false,
                                  keyboardType: TextInputType.text,
                                  onSubmitted: (res) {
                                    FocusScope.of(context)
                                        .requestFocus(_nodeStreetName);
                                  },
                                  onChanged: (res) {
                                    vatcodeStr = res;
                                  },
                                ))),
                        InputTextItem(
                            title: "*街道名称",
                            inputText: NormalInput(
                              hintText: "请填写英文",
                              controller: _textStreetNameController,
                              focusNode: _nodeStreetName,
                              autoFocus: false,
                              keyboardType: TextInputType.text,
                              onSubmitted: (res) {
                                FocusScope.of(context)
                                    .requestFocus(_nodeDoorNum);
                              },
                              onChanged: (res) {
                                streetNameStr = res;
                              },
                            )),
                        InputTextItem(
                            title: "*门牌号",
                            inputText: NormalInput(
                              hintText: "请填写英文",
                              controller: _textDoorNumController,
                              focusNode: _nodeDoorNum,
                              autoFocus: false,
                              keyboardType: TextInputType.text,
                              onSubmitted: (res) {
                                FocusScope.of(context)
                                    .requestFocus(_nodeExpressNo);
                              },
                              onChanged: (res) {
                                doorNumberStr = res;
                              },
                            )),
                        InputTextItem(
                            title: "*邮政编码",
                            inputText: NormalInput(
                              hintText: "请填写英文",
                              controller: _textExpressNoController,
                              focusNode: _nodeExpressNo,
                              autoFocus: false,
                              keyboardType: TextInputType.text,
                              onSubmitted: (res) {
                                FocusScope.of(context)
                                    .requestFocus(_nodeRemarkForAdd);
                              },
                              onChanged: (res) {
                                expressNoStr = res;
                              },
                            )),
                        InputTextItem(
                            title: "附加地址",
                            inputText: NormalInput(
                              hintText: "请填写英文",
                              controller: _textRemarkForAddController,
                              focusNode: _nodeRemarkForAdd,
                              autoFocus: false,
                              keyboardType: TextInputType.text,
                              onSubmitted: (res) {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                              onChanged: (res) {
                                remarkForAddStr = res;
                              },
                            )),
                      ],
                    ),
                  ),
                ),
                isLoading));
  }

  Widget line() {
    return Divider(
      height: 1.0,
      indent: 0,
      color: AppColor.line,
    );
  }

  Widget buildLoginNameTextField() {
    return new Padding(
      padding: new EdgeInsets.all(5),
      child: new Row(
        children: <Widget>[
          GestureDetector(
            child: Text(
              '+$countryCodeID',
              style: TextStyle(fontSize: 15),
            ),
            onTap: () async {
              var s = await Navigator.pushNamed(context, '/phoneCode');
              String a = s;
              if (a == null) {
                return;
              }
              setState(() {
                countryCodeID = a.substring(0, a.indexOf('='));
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
                hintText: '手机号',
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
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            cursorColor: Theme.of(context).primaryColor,
            controller: _codeController,
            decoration: new InputDecoration(
                hintText: '验证码',
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
                  'flag': "2",
                  'timezone': countryCodeID
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

  bool charmData() {
    bool result = false;
    if (accountType == 0) {
      Util.showToast('请选择账户类型');
      return result;
    }
    if (nameStr.isEmpty) {
      Util.showToast('请输入名字');
      return result;
    }
    if (surnameStr.isEmpty) {
      Util.showToast('请输入姓氏');
      return result;
    }
    if (country == "请选择国家") {
      Util.showToast('请选择国家');
      return result;
    }
    if (cityStr.isEmpty) {
      Util.showToast('请输入城市');
      return result;
    }
    if (accountType == 2) {
      if (compainNameStr.isEmpty) {
        Util.showToast('请输入公司名称');
        return result;
      }
      if (commerceNumStr.isEmpty) {
        Util.showToast('请输入商会编号');
        return result;
      }
      if (vatcodeStr.isEmpty) {
        Util.showToast('请输入增值税编码');
        return result;
      }
    }
    if (streetNameStr.isEmpty) {
      Util.showToast('请输入街道');
      return result;
    }
    if (doorNumberStr.isEmpty) {
      Util.showToast('请输入门牌号');
      return result;
    }
    if (expressNoStr.isEmpty) {
      Util.showToast('请输入邮政编码');
      return result;
    }
    if (_mobileController.text.isEmpty) {
      Util.showToast('请输入手机号码');
      return result;
    }
    if (_codeController.text.isEmpty) {
      Util.showToast('请输入验证码');
      return result;
    }
    return true;
  }
}
