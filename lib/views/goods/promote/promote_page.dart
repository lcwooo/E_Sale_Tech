import 'dart:typed_data';

import 'package:E_Sale_Tech/api/goods.dart';
import 'package:E_Sale_Tech/components/load_image.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class PromotePage extends StatefulWidget {
  PromotePage({this.arguments});
  final Map arguments;
  @override
  _PromotePageState createState() =>
      new _PromotePageState(arguments: arguments);
}

class _PromotePageState extends State<PromotePage>
    with AutomaticKeepAliveClientMixin {
  final Map arguments;
  _PromotePageState({this.arguments});
  @override
  bool get wantKeepAlive => true;
  Map dataMap = new Map();
  List imageMapList = [];
  List textMapList = [];
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getMtarialsData();
    });
  }

  getMtarialsData() {
    EasyLoading.show(status: "加载素材...");
    ApiGoods.getGoodsmterial(this.arguments["goodsId"].toString(), (data) {
      EasyLoading.dismiss();
      setState(() {
        isLoading = true;
        dataMap = data;
        textMapList = dataMap["text"];
        for (String item in dataMap["images"]) {
          LoadImage img = LoadImage(
            item,
            fit: BoxFit.fitWidth,
            holderImg: "home/banner@3x",
            format: "png",
          );
          Map imgMap = {"select": false, "img": img, "imgUrl": item};
          imageMapList.add(imgMap);
        }
      });
      print(data);
    }, (message) => EasyLoading.dismiss());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: MyAppBar(
          centerTitle: "推广素材库",
          isBack: true,
        ),
        body: isLoading
            ? SingleChildScrollView(
                child: (textMapList.length != 0 || imageMapList.length != 0)
                    ? Column(
                        children: <Widget>[
                          buildListHeader({
                            'pic': 'assets/images/goods/CircleFriends@3x.png',
                            'title': '产品推广文字素材',
                            'type': 1
                          }),
                          ListView(
                            children: _getListData(),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                          ),
                          // buildTextViewModel(),
                          // buildTextViewModel(),
                          Gaps.lowBr,
                          buildListHeader({
                            'pic': 'assets/images/goods/CircleFriends@3x.png',
                            'title': '产品推广图片素材',
                            'type': 2
                          }),
                          buildGrideView(),
                        ],
                      )
                    : Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 200,
                            ),
                            Text("暂无推广素材",
                                style: TextStyle(
                                    color: AppColor.themeRed, fontSize: 24)),
                          ],
                        ),
                      ),
              )
            : Container());
  }

  Widget buildListHeader(Map dic) {
    var newColumn = Column(
      children: <Widget>[
        Gaps.line,
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.asset(
                    dic["pic"],
                    width: 28,
                    height: 28,
                  ),
                  SizedBox(width: 10),
                  Text(
                    dic["title"],
                    style: TextStyle(
                        color: AppColor.mainTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              (dic["type"] == 2)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              bool selected = false;
                              for (Map imgMap in imageMapList) {
                                if (imgMap["select"]) {
                                  selected = true;
                                }
                              }
                              if (selected) {
                                for (Map imgMap in imageMapList) {
                                  if (imgMap["select"]) {
                                    selected = true;
                                    savePic(imgMap["imgUrl"]);
                                  }
                                }
                              } else {
                                Util.showToast('请选择要保存的图片');
                              }
                            },
                            child: Text(
                              "下载图片",
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Color(0xFF50B674)),
                            )),
                        Image.asset(
                          "assets/images/goods/downLoad@3x.png",
                          width: 20,
                          height: 20,
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        Gaps.line,
      ],
    );
    return newColumn;
  }

  savePic(String urlStr) async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.storage,
    ].request();
    var isDenied = await Permission.storage.isDenied;
    var isGranted = await Permission.storage.isGranted;
    if (isDenied) {
      openAppSettings();
    } else {
      var response = await Dio()
          .get(urlStr, options: Options(responseType: ResponseType.bytes));
      final result =
          await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
      if (result is String || result) {
        Util.showToast('保存成功');
      } else {
        Util.showToast('保存失败');
      }
    }
  }

  _getListData() {
    List<Widget> widgets = [];

    for (var i = 0; i < textMapList.length; i++) {
      Map textMap = textMapList[i];
      widgets.add(buildTextViewModel(textMap));
    }
    return widgets;
  }

  Widget buildTextViewModel(Map textMap) {
    var textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          child: Container(
              padding: EdgeInsets.only(top: 10, left: 15, right: 20),
              child: Text(
                textMap["text"],
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 100,
              )),
          onLongPress: () {
            clipBoardText(textMap);
          },
        ),
        Container(
          padding: EdgeInsets.only(top: 6, left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                textMap["count"].toString() + "位店主使用过该素材",
                style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 12),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          print("object");
                          clipBoardText(textMap);
                        },
                        child: Text(
                          "复制文案",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Color(0xFF50B674)),
                        )),
                    Image.asset(
                      "assets/images/goods/copy@3x.png",
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
    return textColumn;
  }

  void clipBoardText(Map textMap) {
    if (!textMap["is_copied"]) {
      setState(() {
        textMap["count"] = textMap["count"] + 1;
      });
      ApiGoods.copyAddOne(
          textMap["id"].toString(), this.arguments["goodsId"].toString(),
          (data) {
        print(data);
        textMap["is_copied"] = true;
      }, (message) => null);
    }
    ClipboardData data = new ClipboardData(text: textMap["text"]);
    Clipboard.setData(data);
    Util.showToast("复制成功");
  }

  Widget _getListData1(context, index) {
    //第二种设置数据：
    return new GestureDetector(
      onTap: () {
        setState(() {
          // for (Map item in imageMapList) {
          //   item["select"] = false;
          // }
          imageMapList[index]["select"] = !imageMapList[index]["select"];
        });
      },
      child: Container(
        child: Stack(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              color: Colors.white,
              child: imageMapList[index]["img"],
            ),
            new Positioned(
              //方法二
              right: 15.0,
              top: 15.0,
              child: imageMapList[index]["select"]
                  ? Icon(
                      Icons.check_circle,
                      size: 25.0,
                      color: AppColor.themeRed,
                    )
                  : Icon(
                      Icons.panorama_fish_eye,
                      size: 25.0,
                      color: Colors.grey,
                    ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFF5F5F9), width: 0.5)),
      ),
    );
  }

  Widget buildGrideView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 0.0, //水平子Widget之间间距
        mainAxisSpacing: 0.0, //垂直子Widget之间间距
        crossAxisCount: 2, //一行的Widget数量
        childAspectRatio: 1 / 1, // 宽高比例
      ),
      itemCount: imageMapList.length,
      itemBuilder: this._getListData1,
    );
  }
}
