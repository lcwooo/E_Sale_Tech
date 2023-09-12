import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/model/shop/shop_template_info.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/click_upload_image.dart';

class ShopTemplateImgAd extends StatefulWidget {
  final Map arguments;
  ShopTemplateImgAd({this.arguments});
  @override
  _ShopTemplateImgAdState createState() => _ShopTemplateImgAdState();
}

class _ShopTemplateImgAdState extends State<ShopTemplateImgAd> {
  bool isEditing = false;
  ShopTemplateInfo templateInfo;
  List<String> temporatySwiperList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTemplateInfo();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getTemplateInfo() {
    EasyLoading.show(status: '加载中');
    ApiShop.getShopTemplate((data) {
      setState(() {
        templateInfo = data;
      });
      EasyLoading.dismiss();
    }, (message) => EasyLoading.dismiss());
  }

  Widget buildBanner() {
    return Opacity(
        opacity: isEditing ? 1 : 0.5,
        child: Container(
          padding: EdgeInsets.only(top: 0, bottom: 10),
          height: 155 * ScreenUtil().screenWidth / 375,
          child: (templateInfo?.adPictureUrls?.length ?? 0) > 0 ||
                  temporatySwiperList.length > 0
              ? new Swiper(
                  // 横向
                  scrollDirection: Axis.horizontal,
                  // 布局构建
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: <Widget>[
                        Container(
                            constraints:
                                BoxConstraints(minHeight: 100, minWidth: 100),
                            child: CachedNetworkImage(
                              imageUrl: isEditing
                                  ? temporatySwiperList[index]
                                  : templateInfo?.adPictureUrls[index] ?? '',
                              placeholder: (context, url) => Container(
                                color: AppColor.bgGray,
                              ),
                              imageBuilder: (context, image) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: image,
                                  ),
                                ),
                              ),
                            )),
                        isEditing
                            ? Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                    decoration: new BoxDecoration(
                                      color: Color(0x66000000),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(60.0)),
                                    ),
                                    child: IconButton(
                                        onPressed: () {
                                          uploadImage(index: index);
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: AppColor.bgGray,
                                        ))))
                            : SizedBox(),
                        isEditing
                            ? Positioned(
                                top: 5,
                                left: 5,
                                child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(0),
                                    child: IconButton(
                                        onPressed: () {
                                          removeImage(index: index);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: AppColor.bgGray,
                                        )),
                                    decoration: new BoxDecoration(
                                      color: Color(0x66000000),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(60.0)),
                                    )))
                            : SizedBox(),
                      ],
                    );
                    // new Image.network(
                    //   "http://hbimg.b0.upaiyun.com/a3e592c653ea46adfe1809e35cd7bc58508a6cb94307-aaO54C_fw658",
                    //   fit: BoxFit.fitWidth,
                    // );
                  },
                  //条目个数
                  itemCount: isEditing
                      ? temporatySwiperList.length
                      : templateInfo?.adPictureUrls?.length ?? 0,
                  // 分页指示
                  pagination: SwiperPagination(),
                  //点击事件
                  onTap: (index) {
                    print('index $index');
                  },
                  // 相邻子条目视窗比例
                  viewportFraction: 1,
                  // 布局方式
                  //layout: SwiperLayout.STACK,
                  // 用户进行操作时停止自动翻页
                  autoplayDisableOnInteraction: true,
                  // 无线轮播
                  loop: false,
                  //当前条目的缩放比例
                  scale: 1,
                )
              : Center(child: Text('请上传图片')),
        ));
  }

  void removeImage({index}) {
    setState(() {
      temporatySwiperList.removeAt(index);
    });
  }

  void uploadImage({index}) {
    ClickUploadImage.showDemoActionSheetSwiper(
      onSuccessCallback: (image) async {
        if (index == null) {
          setState(() {
            temporatySwiperList.add(image);
          });
        } else if (index != null) {
          setState(() {
            temporatySwiperList[index] = image;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: MyAppBar(centerTitle: '选择图片广告'),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        width: 60,
                        child: RaisedButtonCustom(
                          onPressed: () {
                            setState(() {
                              if (!isEditing) {
                                temporatySwiperList = [
                                  ...templateInfo.adPictureUrls
                                ];
                              } else {}
                              isEditing = !isEditing;
                            });
                          },
                          padding: EdgeInsets.only(left: 0, right: 0),
                          elevation: 0,
                          shape: Border.all(
                            // 设置边框样式
                            color: Color(0xffCCCCCC),
                            width: 0.5,
                            style: BorderStyle.solid,
                          ),
                          textStyle: TextStyle(color: Color(0xff1C1717)),
                          splashColor: Colors.white,
                          txt: isEditing ? '取消' : '编辑',
                          color: Colors.white,
                          textColor: Color(0xff1C1717),
                        )),
                    isEditing
                        ? Container(
                            width: 60,
                            child: IconButton(
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: AppColor.themeRed,
                              ),
                              onPressed: () {
                                uploadImage();
                              },
                            ))
                        : Text(''),
                    isEditing
                        ? Container(
                            width: 60,
                            child: RaisedButtonCustom(
                              onPressed: () {
                                if (temporatySwiperList.length < 1) return;
                                ApiShop.setShopTemplate({
                                  'template_id': widget.arguments['id'],
                                  'ad_picture_urls': temporatySwiperList
                                }, (data) {
                                  if (data.ret == 1) {
                                    Util.showToast('设置成功');
                                    setState(() {
                                      isEditing = !isEditing;
                                      templateInfo.adPictureUrls = [
                                        ...temporatySwiperList
                                      ];
                                    });
                                  }
                                }, (message) => null);
                              },
                              padding: EdgeInsets.only(left: 0, right: 0),
                              elevation: 0,
                              shape: Border.all(
                                // 设置边框样式
                                color: Color(0xffCCCCCC),
                                width: 0.5,
                                style: BorderStyle.solid,
                              ),
                              textStyle: TextStyle(color: Color(0xff1C1717)),
                              splashColor: Colors.white,
                              txt: '保存',
                              color: Colors.white,
                              textColor: Color(0xff1C1717),
                            ))
                        : Text(''),
                  ],
                ),
                buildBanner(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('轮播广告'),
                    widget.arguments['type'] == '1'
                        ? Text(
                            '正在使用',
                            style: TextStyle(color: Color(0xffe4382d)),
                          )
                        : RaisedButtonCustom(
                            onPressed: () {
                              ApiShop.setShopTemplate({
                                'template_id': widget.arguments['id'],
                                'ad_picture': '1'
                              }, (data) {
                                if (data.ret == 1) {
                                  Util.showToast('设置成功');
                                  Routers.pop(context,
                                      {'event': 'success', 'value': '1'});
                                }
                              }, (message) => null);
                            },
                            padding: EdgeInsets.only(left: 30, right: 30),
                            elevation: 0,
                            shape: Border.all(
                              // 设置边框样式
                              color: Color(0xffCCCCCC),
                              width: 0.5,
                              style: BorderStyle.solid,
                            ),
                            textStyle: TextStyle(color: Color(0xff1C1717)),
                            splashColor: Colors.white,
                            txt: '使用',
                            color: Colors.white,
                            textColor: Color(0xff1C1717),
                          ),
                  ],
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    color: Color(0xffF8F8F8),
                    margin: EdgeInsets.only(bottom: 10),
                    height: 145 * ScreenUtil().screenWidth / 375,
                    child: Icon(
                      Icons.do_not_disturb_alt,
                      size: 34,
                      color: Color.fromRGBO(205, 205, 205, 1),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('无广告'),
                    widget.arguments['type'] == '2'
                        ? Text(
                            '正在使用',
                            style: TextStyle(color: Color(0xffe4382d)),
                          )
                        : RaisedButtonCustom(
                            onPressed: () {
                              ApiShop.setShopTemplate({
                                'template_id': widget.arguments['id'],
                                'ad_picture': '2'
                              }, (data) {
                                if (data.ret == 1) {
                                  Util.showToast('设置成功');
                                  Routers.pop(context,
                                      {'event': 'success', 'value': '2'});
                                }
                              }, (message) => null);
                            },
                            padding: EdgeInsets.only(left: 30, right: 30),
                            elevation: 0,
                            shape: Border.all(
                              // 设置边框样式
                              color: Color(0xffCCCCCC),
                              width: 0.5,
                              style: BorderStyle.solid,
                            ),
                            splashColor: Colors.white,
                            txt: '使用',
                            textStyle: TextStyle(color: Color(0xff1C1717)),
                            color: Colors.white,
                            textColor: Color(0xff1C1717),
                          ),
                  ],
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
