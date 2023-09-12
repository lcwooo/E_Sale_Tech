import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/model/shop/shop_info.dart';
import 'package:E_Sale_Tech/utils/click_upload_image.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/shop/shop_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:E_Sale_Tech/utils/style.dart';

class ModifyShopQRcode extends StatefulWidget {
  @override
  _ModifyShopQRcodeState createState() => _ModifyShopQRcodeState();
}

class _ModifyShopQRcodeState extends State<ModifyShopQRcode> {
  bool isEdit = false;

  ShopQrCode shopQrCodeInfo = new ShopQrCode();
  GlobalKey repaintKey = GlobalKey();

  TextEditingController _textDescriptionController =
      new TextEditingController();
  final FocusNode _nodeGoodsName = FocusNode();

  @override
  void initState() {
    super.initState();
    getShopQRcode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getShopQRcode() async {
    ShopQrCode data = await ApiShop.getShopQRcode();
    setState(() {
      shopQrCodeInfo = data;
      _textDescriptionController.text = shopQrCodeInfo.description;
    });
  }

  void setShopQRcode() async {
    if (!isEdit) {
      setState(() {
        isEdit = true;
      });
      return;
    }
    await ApiShop.setShopQRcode({
      'description': _textDescriptionController.text,
      'picture': shopQrCodeInfo.picture,
    }, (data) {
      if (data.ret == 1) {
        getShopQRcode();
        setState(() {
          isEdit = false;
          Util.showToast('更改成功');
        });
      }
    }, (message) => null);
  }

  void uploadPicture() {
    ClickUploadImage.showDemoActionSheet(
      onSuccessCallback: (image) async {
        if (image != null) {
          setState(() {
            shopQrCodeInfo.picture = image;
          });
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

  void saveScreenshot() async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.storage,
    ].request();
    var isDenied = await Permission.storage.isDenied;
    var isGranted = await Permission.storage.isGranted;
    if (isDenied) {
      openAppSettings();
    } else {
      final result = await ImageGallerySaver.saveImage(await capturePng());
      if (result is String || result) {
        Util.showToast('保存成功');
      } else if (isGranted) {
        openAppSettings();
      }
    }
  }

  Future<Uint8List> capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          repaintKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(
          actionName: isEdit ? '保存' : '编辑',
          centerTitle: '店铺二维码',
          onPressed: () {
            setShopQRcode();
          },
        ),
        bottomNavigationBar: Material(
          //底部栏整体的颜色
          color: Color(0xffe4382d),
          child: FlatButton(
            child: new Padding(
              padding: new EdgeInsets.all(10),
              child: Text("保存图片到相册",
                  style: TextStyle(
                    fontSize: 18.0, //textsize
                    color: Colors.white, // textcolor
                  )),
            ),
            color: Color(0xffe4382d),
            onPressed: () async {
              saveScreenshot();
            },
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
              child: RepaintBoundary(
                  key: repaintKey,
                  child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Container(
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              padding: EdgeInsets.only(bottom: 40),
                              width: double.infinity,
                              height: 390,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, -3),
                                        blurRadius: 15,
                                        color: Color(0x5CB0B0B0),
                                        spreadRadius: 0),
                                    BoxShadow(
                                        offset: Offset(0, 3),
                                        blurRadius: 5,
                                        color: Color(0x5CB0B0B0),
                                        spreadRadius: 0),
                                    BoxShadow(
                                        offset: Offset(0, 3),
                                        blurRadius: 5,
                                        color: Color(0x5CB0B0B0),
                                        spreadRadius: 0),
                                    BoxShadow(
                                        offset: Offset(0, 3),
                                        blurRadius: 5,
                                        color: Color(0x5CB0B0B0),
                                        spreadRadius: 0),
                                  ]),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Opacity(
                                      opacity: isEdit ? 1 : 0,
                                      child: GestureDetector(
                                          onTap: () {
                                            if (!isEdit) return;
                                            uploadPicture();
                                          },
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 15, right: 15),
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Image.asset(
                                                      'assets/images/shop/camera@3x.png',
                                                      width: 24,
                                                      height: 24))))),
                                  Container(
                                      width: 237,
                                      height: 164,
                                      child: CachedNetworkImage(
                                        imageUrl: shopQrCodeInfo?.picture,
                                        placeholder: (context, url) =>
                                            CircleAvatar(
                                          backgroundColor: AppColor.bgGray,
                                          radius: 60,
                                        ),
                                        imageBuilder: (context, image) =>
                                            Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 10, 0, 10),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )),
                                  isEdit
                                      ? Column(children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                  flex: 1, child: Text('')),
                                              Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Image.asset(
                                                          'assets/images/shop/chat@3x.png',
                                                          width: 24,
                                                          height: 24))),
                                              Expanded(
                                                  flex: 4,
                                                  child: Container(
                                                      child: TextField(
                                                          cursorColor:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          decoration:
                                                              InputDecoration(
                                                                  border: InputBorder
                                                                      .none, //去掉输入框的下滑线
                                                                  fillColor: Color(
                                                                      0xffF8F8F8),
                                                                  filled: true,
                                                                  hintText:
                                                                      "请输入推广语",
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          13.0),
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5.0),
                                                                  enabledBorder:
                                                                      null,
                                                                  disabledBorder:
                                                                      null),
                                                          controller:
                                                              _textDescriptionController))),
                                              Expanded(
                                                  flex: 1, child: Text('')),
                                            ],
                                          ),
                                        ])
                                      : Column(
                                          children: <Widget>[
                                            Text(
                                                '${Provider.of<ShopInfoProvider>(context, listen: false).shopInfo.name}',
                                                style: TextStyle(
                                                    color: Color(0xff555555),
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                '${shopQrCodeInfo?.description}',
                                                style: TextStyle(
                                                    color: Color(0xff555555),
                                                    fontSize: 12)),
                                          ],
                                        )
                                ],
                              )),
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 40, 0, 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                      child: Row(
                                    children: <Widget>[
                                      Container(
                                          width: 64,
                                          height: 64,
                                          margin: EdgeInsets.only(right: 10),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                Provider.of<ShopInfoProvider>(
                                                        context,
                                                        listen: true)
                                                    .shopInfo
                                                    .logo,
                                            placeholder: (context, url) =>
                                                const CircleAvatar(
                                              backgroundColor: AppColor.bgGray,
                                              radius: 60,
                                            ),
                                            imageBuilder: (context, image) =>
                                                CircleAvatar(
                                              backgroundImage: image,
                                              radius: 60,
                                            ),
                                          )),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                              child: Text(
                                                  '${Provider.of<ShopInfoProvider>(context, listen: false).shopInfo.name}',
                                                  style: TextStyle(
                                                      color: Color(0xff555555),
                                                      fontSize: 10.5))),
                                          Container(
                                              child: Text('扫描或长按二维码',
                                                  style: TextStyle(
                                                      color: Color(0xff555555),
                                                      fontSize: 10.5))),
                                        ],
                                      ),
                                    ],
                                  )),
                                  Container(
                                      width: 64,
                                      height: 64,
                                      child: CachedNetworkImage(
                                        imageUrl: shopQrCodeInfo?.qrCode,
                                        placeholder: (context, url) =>
                                            CircleAvatar(
                                          backgroundColor: AppColor.bgGray,
                                          radius: 60,
                                        ),
                                        imageBuilder: (context, image) =>
                                            Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              )),
                        ],
                      )))),
        ));
  }
}
