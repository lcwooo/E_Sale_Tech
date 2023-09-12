import 'dart:convert';

import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/model/shop/shop_info.dart';
import 'package:E_Sale_Tech/utils/click_upload_image.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/shop/shop_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:E_Sale_Tech/components/click_item.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:provider/provider.dart';
// import 'package:fluwx/fluwx.dart';

class ShopDesign extends StatefulWidget {
  @override
  _ShopDesignState createState() => _ShopDesignState();
}

class _ShopDesignState extends State<ShopDesign> {
  final subtitleStyle = TextStyle(color: Color(0xff999999));
  ShopInfo shopInfo;
  @override
  void initState() {
    super.initState();
    // setState(() {
    //   shopInfo =
    //       Provider?.of<ShopInfoProvider>(context, listen: true)?.shopInfo;
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      shopInfo =
          Provider?.of<ShopInfoProvider>(context, listen: true)?.shopInfo;
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffF8F8F8),
      appBar: MyAppBar(
        centerTitle: S.of(context).shopDesign,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                ClickItem(
                    title: '店铺ID',
                    rightWidget: Text('${shopInfo?.id}', style: subtitleStyle)),
                ClickItem(
                    title: '店铺名称',
                    rightWidget:
                        Text('${shopInfo?.name}', style: subtitleStyle),
                    onTap: () {
                      Routers.push('/shop/shopDesign/modifyShopName', context);
                    }),
                ClickItem(
                    title: '店铺签名',
                    rightWidget:
                        Text('${shopInfo?.signature}', style: subtitleStyle),
                    onTap: () {
                      Routers.push(
                          '/shop/shopDesign/modifyShopSignature', context);
                    }),
                ClickItem(
                    title: '店铺logo',
                    rightWidget: Container(
                      width: 24,
                      height: 24,
                      child: CachedNetworkImage(
                        imageUrl:
                            Provider.of<ShopInfoProvider>(context, listen: true)
                                .shopInfo
                                .logo,
                        placeholder: (context, url) => const CircleAvatar(
                          backgroundColor: AppColor.bgGray,
                          radius: 60,
                        ),
                        imageBuilder: (context, image) => CircleAvatar(
                          backgroundImage: image,
                          radius: 60,
                        ),
                      ),
                    ),
                    onTap: () {
                      ClickUploadImage.showDemoActionSheetCircle(
                        onSuccessCallback: (image) async {
                          if (image != null) {
                            ApiShop.setShopInfo({'logo': image}, (data) async {
                              Provider.of<ShopInfoProvider>(context,
                                      listen: false)
                                  .getShopInfo();
                            }, (message) => null);
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
                    }),
                ClickItem(
                    title: '店铺装修',
                    onTap: () {
                      Routers.push("/shop/shopDesign/shopDecoration", context);
                    }),
                ClickItem(
                    title: '店铺二维码',
                    onTap: () {
                      Routers.push(
                          "/shop/shopDesign/modifyShopQRcode", context);
                    }),
                ClickItem(
                    title: '商品排列',
                    onTap: () {
                      Routers.push("/shop/shopDesign/shopDrag", context);
                    }),
              ],
            ),
          ),
          Container(
              color: Color(0xffF8F8F8),
              margin: EdgeInsets.only(top: 50),
              width: 200,
              height: 45,
              child: RaisedButtonCustom(
                  onPressed: () {
                    Routers.push('/webview', context,
                        {'url': shopInfo?.h5Url, 'title': '店铺预览'});
                    // launchWeChatMiniProgram(
                    //     username: "gh_0b843255dd9c",
                    //     path:
                    //         "/pages/index/index?shop_id=" + shopInfo.shareCode);
                  },
                  shape: Border.all(
                    // 设置边框样式
                    color: AppColor.themeRed,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                  textColor: AppColor.themeRed,
                  color: Colors.white,
                  txt: '预览',
                  padding: EdgeInsets.all(0)))
        ],
      )),
    );
  }
}
