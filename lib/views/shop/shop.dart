import 'dart:typed_data';

import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/model/shop/shop_info.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/localstorage.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/shop/shop_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
// import 'package:fluwx/fluwx.dart';

class ShopPage extends StatefulWidget {
  ShopPage({this.arguments});
  final Map arguments;
  @override
  _ShopPageState createState() => new _ShopPageState();
}

class _ShopPageState extends State<ShopPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final titleStyle = TextStyle(color: Colors.white, fontSize: 14);
  final titleValueStyle = TextStyle(color: Colors.white, fontSize: 20);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initShopInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initShopInfo() async {
    var data = await ApiShop.getShopInfo();
    setState(() {
      Provider.of<ShopInfoProvider>(context, listen: false).setShopInfo(data);
    });
  }

  List<Map<String, dynamic>> girdList(BuildContext context) {
    return [
      {
        'name': S.of(context).shopDesign,
        'icon': 'assets/images/shop/shop_info@3x.png',
        'link': '/shop/shopDesign',
      },
      {
        'name': S.of(context).orderManagement,
        'icon': 'assets/images/shop/order_manager@3x.png',
        'link': '/shop/orderManager',
      },
      {
        'name': S.of(context).discount,
        'icon': 'assets/images/shop/discount@3x.png',
        'link': '/shop/coupon/couponManager',
      },
      {
        'name': S.of(context).favorites,
        'icon': 'assets/images/shop/collection@3x.png',
        'link': '/shop/collection',
      },
      {
        'name': S.of(context).dataStatistics,
        'icon': 'assets/images/shop/data_statistic@3x.png',
        'link': '/shop/dataStatistic',
      },
      {
        'name': S.of(context).discountStores,
        'icon': 'assets/images/shop/shop_discount@3x.png',
        'link': '/shop/discountStore',
      },
      {
        'name': S.of(context).myGoods,
        'icon': 'assets/images/shop/myGoods@3x.png',
        'link': '/goodsPage',
      },
    ];
  }

  void showShareModal(BuildContext context) {
    showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        builder: (BuildContext context) {
          return ShareDialog();
        });
  }

  Widget menuWidget(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, //一行的Widget数量
        mainAxisSpacing: 15.0, //垂直子Widget之间间距
        crossAxisSpacing: 15.0, //水平子Widget之间间距
      ),
      itemCount: girdList(context).length,
      itemBuilder: (context, index) {
        var item = girdList(context)[index];
        return GestureDetector(
          child: Container(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      item['icon'],
                      width: ScreenUtil().setWidth(100),
                    ),
                  ),
                  Text(
                    item['name'],
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
          ),
          onTap: () async {
            if (index == 2) {
              if (!await LocalStorage.getCompleteInfo()) {
                showAlertDialog(context);
                return;
              }
            }
            Routers.push(item['link'], context);
          },
        );
      },
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('需要完善信息才能进行下一步操作！！！'),
            title: Center(
                child: Text(
              '提示',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold),
            )),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Routers.push('/fillInformation', context);
                  },
                  child: Text(
                    '确定',
                    style: TextStyle(
                        color: AppColor.themeRed,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('取消',
                      style: TextStyle(
                          color: AppColor.mainTextColor,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold))),
            ],
          );
        });
  }

  Future _onRefresh() async {
    initShopInfo();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      body: RefreshIndicator(
          color: AppColor.themeRed,
          onRefresh: _onRefresh,
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/shop/bg_banner@3x.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(''),
                          ),
                          Container(
                            width: 64,
                            height: 64,
                            child: CachedNetworkImage(
                              imageUrl: Provider?.of<ShopInfoProvider>(context,
                                          listen: true)
                                      ?.shopInfo
                                      ?.logo ??
                                  '',
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
                          Expanded(
                            flex: 6,
                            child: Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        '${Provider?.of<ShopInfoProvider>(context, listen: true)?.shopInfo?.name ?? ''}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                    Text(
                                      'ID ${Provider?.of<ShopInfoProvider>(context, listen: true)?.shopInfo?.id ?? ''}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                )),
                          ),
                          Expanded(
                              flex: 3,
                              child: GestureDetector(
                                  onTap: () async {
                                    if (!await LocalStorage.getCompleteInfo()) {
                                      showAlertDialog(context);
                                    } else {
                                      showShareModal(context);
                                    }
                                  },
                                  child: Container(
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Color(0xffB9A15F),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(13),
                                          topLeft: Radius.circular(13)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '分享店铺',
                                          style: TextStyle(
                                              color: Color(0xff5C471B),
                                              fontSize: 12),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Icon(
                                              Icons.share,
                                              size: 12,
                                              color: Color(0xff5C471B),
                                            ))
                                      ],
                                    ),
                                  )))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Column(
                            children: <Widget>[
                              Text('商品', style: titleStyle),
                              Text(
                                  '${Provider?.of<ShopInfoProvider>(context, listen: true)?.shopInfo?.goodsCount ?? ''}',
                                  style: titleValueStyle)
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: <Widget>[
                              Text('访客', style: titleStyle),
                              Text(
                                  '${Provider?.of<ShopInfoProvider>(context, listen: true)?.shopInfo?.visitorCount ?? ''}',
                                  style: titleValueStyle)
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: <Widget>[
                              Text('收益', style: titleStyle),
                              Text(
                                  '${Provider?.of<ShopInfoProvider>(context, listen: true)?.shopInfo?.earningsCount?.toStringAsFixed(2) ?? ''}',
                                  style: titleValueStyle)
                            ],
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              menuWidget(context)
            ],
          )),
    );
  }
}

class ShareDialog extends StatefulWidget {
  ShareDialog({Key key, this.createSimpleDialog, this.items}) : super(key: key);
  final List<DropdownMenuItem> items;
  final Function createSimpleDialog;

  @override
  _ShareDialogState createState() => new _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  ShopInfo shopInfo;

  @override
  void initState() {
    super.initState();
    setState(() {
      shopInfo =
          Provider?.of<ShopInfoProvider>(context, listen: false)?.shopInfo;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            color: Color(0xffF8F8F8),
            padding: EdgeInsets.all(40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      // isWeChatInstalled.then((installed) {
                      //   if (installed) {
                      //     Navigator.of(context).pop();
                      //     // shareToWeChat(WeChatShareMiniProgramModel(
                      //     //   webPageUrl: 'https://esale.nle-tech.com/',
                      //     //   path:
                      //     //       '/pages/index/index?shop_id=${shopInfo?.shareCode}',
                      //     //   miniProgramType: WXMiniProgramType.RELEASE,
                      //     //   userName: 'gh_0b843255dd9c',
                      //     //   title: shopInfo.name,
                      //     //   thumbnail: WeChatImage.asset(
                      //     //       'assets/images/common/user_logo.png'),
                      //     // ));
                      //   } else {
                      //     Util.showToast("请先安装微信");
                      //   }
                      // });
                    },
                    child: Column(
                      children: <Widget>[
                        Image.asset('assets/images/shop/wechat_friends@3x.png',
                            width: 40, height: 40),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '微信好友',
                              style: TextStyle(fontSize: 12),
                            ))
                      ],
                    )),
                GestureDetector(
                    onTap: () {
                      // isWeChatInstalled.then((installed) {
                      //   if (installed) {
                      //     Navigator.of(context).pop();
                      //     // shareToWeChat(WeChatShareWebPageModel(shopInfo?.h5Url,
                      //     //     title: shopInfo.name,
                      //     //     thumbnail: WeChatImage.asset(
                      //     //         'assets/images/common/user_logo.png'),
                      //     //     scene: WeChatScene.TIMELINE));
                      //   } else {
                      //     Util.showToast("请先安装微信");
                      //   }
                      // });
                    },
                    child: Column(
                      children: <Widget>[
                        Image.asset('assets/images/shop/moments@3x.png',
                            width: 40, height: 40),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text('朋友圈', style: TextStyle(fontSize: 12)))
                      ],
                    )),
                GestureDetector(
                    onTap: () async {
                      var response = await Dio().get(shopInfo.qrCode,
                          options: Options(responseType: ResponseType.bytes));
                      final result = await ImageGallerySaver.saveImage(
                          Uint8List.fromList(response.data));
                      if (result is String || result) {
                        Util.showToast('保存成功');
                      } else {
                        Util.showToast('保存失败');
                      }
                    },
                    child: Column(
                      children: <Widget>[
                        Image.asset('assets/images/shop/qrcode@3x.png',
                            width: 40, height: 40),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '小程序码',
                              style: TextStyle(fontSize: 12),
                            ))
                      ],
                    )),
                GestureDetector(
                    onTap: () {
                      ClipboardData data =
                          new ClipboardData(text: shopInfo?.h5Url ?? '');
                      Clipboard.setData(data);
                      Util.showToast("复制成功");
                    },
                    child: Column(
                      children: <Widget>[
                        Image.asset('assets/images/shop/linker@3x.png',
                            width: 40, height: 40),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '复制链接',
                              style: TextStyle(fontSize: 12),
                            ))
                      ],
                    )),
              ],
            )),
      ],
    ));
  }
}
