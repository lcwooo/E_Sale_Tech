import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:E_Sale_Tech/api/me.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/components/input/normal_input.dart';
import 'package:E_Sale_Tech/components/input/base_input.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomerService extends StatefulWidget {
  @override
  _CustomerServiceState createState() => _CustomerServiceState();
}

class _CustomerServiceState extends State<CustomerService> {
  String qrCodeUrl = '';

  bool isLoadData = true;

  List qaListData = List();

  Image currentImage;
  final subtitleStyle = TextStyle(color: Color(0xff999999));

  TextEditingController _textGoodsNameController = new TextEditingController();
  final FocusNode _nodeGoodsName = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    ApiMe.getCustomerService().then(
      (url) => this.setState(() {
        // this.qrCodeUrl = url;
        this.currentImage = Image.network(url);
      }),
    );
    ApiMe.getQAList((data) {
      EasyLoading.dismiss();
      isLoadData = true;
      setState(() {
        qaListData = data;
      });
    }, (message) {
      EasyLoading.dismiss();
      EasyLoading.showError(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(
          centerTitle: '客服中心',
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 24),
                      width: double.infinity,
                      height: 255,
                      child:
                          // this.qrCodeUrl == '' ? Text('') : Image.network(this.qrCodeUrl),
                          this.currentImage == null
                              ? Text('')
                              : this.currentImage),
                  Container(
                    // color: Color(0xffF8F8F8),
                    margin: EdgeInsets.only(top: 23),
                    width: 187,
                    height: 44,
                    child: RaisedButtonCustom(
                      shape: Border.all(
                        // 设置边框样式
                        color: AppColor.themeRed,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                      textColor: Colors.black,
                      color: AppColor.themeRed,
                      textStyle: TextStyle(color: Colors.white),
                      txt: '保存图片至相册',
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        this.saveScreenshot();
                      },
                    ),
                  ),
                  Container(
                    width: ScreenUtil().screenWidth * 0.7,
                    margin: EdgeInsets.only(top: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '1.保存图片至相册',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '2.打开微信，扫一扫，选择相册，打开保存 的二维码，添加您的专属客服。',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Gaps.br,
              SizedBox(
                height: 15,
              ),
              Text(
                "Q&A答疑",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 15,
              ),
              isLoadData ? buildGride(qaListData) : Container(),
            ],
          ),
        ));
  }

  @override
  Widget buildGride(List date) {
    return GridView.builder(
      physics: new NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 10.0, //水平子Widget之间间距
        mainAxisSpacing: 10.0, //垂直子Widget之间间距
        crossAxisCount: 2, //一行的Widget数量
        childAspectRatio: 5 / 2, // 宽高比例
      ),
      itemCount: date.length,
      itemBuilder: (context, index) => _getListData1(date, index),
    );
  }

  Widget _getListData1(List goodList, index) {
    double width = (ScreenUtil().screenWidth) / 2;
    Map map = goodList[index];
    //第二种设置数据：
    return new GestureDetector(
      onTap: () {
        //处理点击事件
        Routers.push(
            '/webview', context, {'url': map['url'], 'title': 'Q&A答疑'});
        // Routers.push("/me/myMsg/detail", context, {'msg': msg});

        // Routers.push('/goodsDetailPage', context, {"goodsId": saleDate.id});
      },
      child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          padding: EdgeInsets.only(left: 10, bottom: 20),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
            image: new DecorationImage(
              fit: BoxFit.fitWidth,
              image: new NetworkImage(
                map['background'],
              ),
              //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  map['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color.fromRGBO(109, 109, 109, 1),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              )
            ],
          )),
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
      var provider = this.currentImage.image;
      var image = await this.loadImageByProvider(provider);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<ui.Image> loadImageByProvider(
    ImageProvider provider, {
    ImageConfiguration config = ImageConfiguration.empty,
  }) async {
    Completer<ui.Image> completer = Completer<ui.Image>(); //完成的回调
    ImageStreamListener listener;
    ImageStream stream = provider.resolve(config); //获取图片流
    listener = ImageStreamListener((ImageInfo frame, bool sync) {
//监听
      final ui.Image image = frame.image;
      completer.complete(image); //完成
      stream.removeListener(listener); //移除监听
    });
    stream.addListener(listener); //添加监听
    return completer.future; //返回
  }
}
