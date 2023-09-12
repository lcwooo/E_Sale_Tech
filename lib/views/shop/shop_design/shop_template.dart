import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/model/shop/shop_template_info.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:E_Sale_Tech/components/click_item.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/components/skeloton/skeleton.dart';
import 'package:E_Sale_Tech/utils/click_upload_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ShopTemplate extends StatefulWidget {
  @override
  _ShopTemplateState createState() => _ShopTemplateState();
}

class _ShopTemplateState extends State<ShopTemplate> {
  final subtitleStyle = TextStyle(color: Color(0xff999999));
  ShopTemplateInfo templateInfo;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffF8F8F8),
      appBar: MyAppBar(centerTitle: '通用模板'),
      // bottomNavigationBar: Material(
      //   //底部栏整体的颜色
      //   child: Container(
      //       height: 60,
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: <Widget>[
      //           RaisedButtonCustom(
      //               onPressed: () {},
      //               shape: Border.all(
      //                 // 设置边框样式
      //                 color: AppColor.themeRed,
      //                 width: 1.0,
      //                 style: BorderStyle.solid,
      //               ),
      //               textColor: AppColor.themeRed,
      //               color: Colors.white,
      //               txt: '使用该模板',
      //               padding: EdgeInsets.only(left: 20, right: 20)),
      //           RaisedButtonCustom(
      //               onPressed: () {},
      //               shape: Border.all(
      //                 // 设置边框样式
      //                 color: AppColor.themeRed,
      //                 width: 1.0,
      //                 style: BorderStyle.solid,
      //               ),
      //               textColor: AppColor.themeRed,
      //               color: Colors.white,
      //               txt: '预览效果',
      //               padding: EdgeInsets.only(left: 20, right: 20)),
      //         ],
      //       )),
      // ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                ClickItem(
                    title: '封面图片',
                    rightWidget: Container(
                        width: 34,
                        height: 34,
                        child: CachedNetworkImage(
                          imageUrl: templateInfo?.coverPicture ?? '',
                          placeholder: (context, url) => const CircleAvatar(
                            backgroundColor: AppColor.bgGray,
                            radius: 60,
                          ),
                          imageBuilder: (context, image) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: image,
                              ),
                            ),
                          ),
                        )),
                    onTap: () {
                      ClickUploadImage.showDemoActionSheet(
                        onSuccessCallback: (image) {
                          ApiShop.setShopTemplate({
                            'template_id': templateInfo.templateId,
                            'cover_picture': image
                          }, (data) {
                            if (data.ret == 1) {
                              setState(() {
                                templateInfo.coverPicture = image;
                              });
                              Util.showToast('上传成功');
                            }
                          }, (message) => null);
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
                    }),
                ClickItem(
                    title: '商品列表样式',
                    rightWidget: Text(
                        templateInfo?.productList == '1' ? '双列小图' : '最新商品',
                        style: subtitleStyle),
                    onTap: () {
                      Routers.push(
                          '/shop/shopDesign/shopDecoration/shopTemplateGoodsStyle',
                          context, {
                        'id': templateInfo.templateId,
                        'type': templateInfo?.productList
                      }).then((res) {
                        if (res != null && res['event'] == 'success') {
                          setState(() {
                            templateInfo.productList = res['value'];
                          });
                        }
                      });
                    }),
                ClickItem(
                    title: '图片广告',
                    rightWidget: Text(
                        templateInfo?.adPicture == '1' ? '轮播广告' : '无广告',
                        style: subtitleStyle),
                    onTap: () {
                      Routers.push(
                          '/shop/shopDesign/shopDecoration/shopTemplateImgAd',
                          context, {
                        'type': templateInfo?.adPicture,
                        'id': templateInfo.templateId
                      }).then((res) {
                        if (res != null && res['event'] == 'success') {
                          setState(() {
                            templateInfo.adPicture = res['value'];
                          });
                        }
                      });
                      // _showUpdateDialog();
                    }),
              ],
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child:
                  Container(margin: EdgeInsets.all(15), child: Text('效果示例'))),
          Container(
              padding: EdgeInsets.only(left: 50, right: 50),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 5,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 120,
                            margin: EdgeInsets.only(right: 7),
                            color: Color(0xffe4382d),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/shop/white_house@3x.png',
                                        width: 24,
                                        height: 24)),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          '店铺名称',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(left: 10),
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: Color(0xFFFFFFFF))),
                                            child: Text('认证',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9))),
                                        // Text('店铺签名'),
                                      ],
                                    ),
                                    Text('店铺签名',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(right: 7),
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, bottom: 30),
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('最新商品'))),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 5,
                                          child: Container(
                                            height: 145.5,
                                            margin: EdgeInsets.only(right: 2.5),
                                            color: Color(0xffF8F8F8),
                                            child: Image.asset(
                                                'assets/images/shop/white_gift@3x.png',
                                                width: 12,
                                                scale: 2,
                                                height: 12),
                                          )),
                                      Expanded(
                                          flex: 5,
                                          child: Container(
                                            height: 145.5,
                                            margin: EdgeInsets.only(left: 2.5),
                                            color: Color(0xffF8F8F8),
                                            child: Image.asset(
                                                'assets/images/shop/white_gift@3x.png',
                                                width: 12,
                                                scale: 2,
                                                height: 12),
                                          )),
                                    ],
                                  ),
                                  Skeleton.skeletonSubscription(
                                      left: 2.5, right: 50.0),
                                  Skeleton.skeletonSubscription(),
                                ],
                              )),
                        ],
                      )),
                ],
              ))
        ],
      )),
    );
  }
}
