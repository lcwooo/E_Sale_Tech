import 'dart:typed_data';

import 'package:E_Sale_Tech/api/goods.dart';
import 'package:E_Sale_Tech/api/order.dart';
import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/input/number_controller_Widget.dart';
import 'package:E_Sale_Tech/components/load_image.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/model/goods/goodsDetailInfo.dart';
import 'package:E_Sale_Tech/model/shop/shop_info.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/localstorage.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/goods/choice_chip_for_spec.dart';
import 'package:E_Sale_Tech/views/shop/shop_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
// import 'package:fluwx/fluwx.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class GoodsDetailPage extends StatefulWidget {
  final Map arguments;
  GoodsDetailPage({this.arguments});
  @override
  _GoodsDetailPageState createState() =>
      new _GoodsDetailPageState(arguments: arguments);
}

class _GoodsDetailPageState extends State<GoodsDetailPage>
    with AutomaticKeepAliveClientMixin {
  final Map arguments;
  _GoodsDetailPageState({this.arguments});
  @override
  bool get wantKeepAlive => true;
  List<Goods> selectSpec = [];
  List<Goods> selectPaySpec = [];
  bool isLoading = false;
  bool isSelected = false;
  bool isSelectDetails = true; // true 表示选择的是商品详情，false表示选择的是购买须知
  int buyNumber = 1;
  GoodsDetailInfo goodInfo;
  Goods selectGoodSpec;
  Goods toPayselectGoodSpec;
  String goodsMustKnow = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Map qrCode;

  bool isFavorite = true;

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    String url = '';
    if (isLiked) {
      url = ApiShop.PRODUCTS_COLLECTIONS + '/${goodInfo.id}/collect-cancel';
    } else {
      url = ApiShop.PRODUCTS_COLLECTIONS + '/${goodInfo.id}/collect';
    }
    ApiShop.setProductsFavorite(url, (data) {
      setState(() {
        isFavorite = !isLiked;
      });
    }, (message) {
      setState(() {
        isFavorite = isLiked;
      });
    });
    return !isLiked;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
    ApplicationEvent.event
        .on<RefreshGoodDetailAfterEditPrice>()
        .listen((event) {
      getData();
    });
  }

  void getData() {
    isLoading = true;
    EasyLoading.show(status: '加载商品...');
    ApiGoods.goodsDetail(this.arguments, (data) {
      EasyLoading.dismiss();
      setState(() {
        isLoading = true;
        goodInfo = data;
        selectGoodSpec = goodInfo.goods.first;
        for (Goods item in goodInfo.goods) {
          if (item.number != 0 && toPayselectGoodSpec == null) {
            toPayselectGoodSpec = item;
          }
        }
      });
      getMinerProgram();
      getMustKnowText();
    }, (message) => EasyLoading.dismiss());
  }

  void getMustKnowText() async {
    await ApiGoods.getGoodsMustKnow(this.arguments, (data) {
      setState(() {
        goodsMustKnow = data["order_notice"];
      });
    }, (message) => null);
  }

  void getMinerProgram() async {
    await ApiGoods.getShopQrCode(this.arguments, (data) {
      setState(() {
        qrCode = data;
      });
    }, (message) => null);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var unitCont = goodInfo?.unitContent != null ? goodInfo?.unitContent : '';
    return Scaffold(
      key: _scaffoldKey,
      appBar: MyAppBar(
        centerTitle: S.of(context).goodDetail,
        isBack: true,
        actionIcon: Icon(Icons.share),
        // ImageIcon(AssetImage("assets/images/goods/share@3x.png")),
        onPressed: () async {
          if (!await LocalStorage.getCompleteInfo()) {
            showAlertDialog(context);
          } else {
            if (this.goodInfo.shopProductStatus == 2) {
              Util.showToast('先上架商品');
              return;
            }
            showShareModal(context);
          }
        },
      ),
      body: isLoading
          ? SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // 轮播图
                  buildStyle1(goodInfo),
                  // 商品当前规格详情
                  Container(
                    height: 170,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: buildColmun({
                                  'name': S.of(context).originPrice,
                                  'price': (selectGoodSpec == null)
                                      ? "￥" +
                                          goodInfo.specPrice?.toStringAsFixed(2)
                                      : "￥" +
                                          selectGoodSpec.specPrice
                                              ?.toStringAsFixed(2),
                                  'hasDis': selectGoodSpec?.discountPrice != 0
                                      ? true
                                      : false
                                }),
                              ),
                              (selectGoodSpec?.discountPrice != 0)
                                  ? Expanded(
                                      flex: 1,
                                      child: buildColmun({
                                        'name': "VIP价",
                                        'price': (selectGoodSpec == null)
                                            ? "￥" +
                                                goodInfo?.totalPrice
                                                    ?.toStringAsFixed(2)
                                            : "￥" +
                                                selectGoodSpec?.discountPrice
                                                    ?.toStringAsFixed(2),
                                      }),
                                    )
                                  : SizedBox(
                                      width: 0,
                                    ),
                              Expanded(
                                flex: 1,
                                child: buildColmun({
                                  'name': S.of(context).salePrice,
                                  'price': (selectGoodSpec == null)
                                      ? "￥" +
                                          goodInfo.totalPrice
                                              ?.toStringAsFixed(2)
                                      : "￥" +
                                          selectGoodSpec.totalPrice
                                              ?.toStringAsFixed(2),
                                }),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 60,
                                    padding: EdgeInsets.only(top: 10),
                                    width: ScreenUtil().screenWidth / 4,
                                    child: GestureDetector(
                                        onTap: () async {
                                          if (!await LocalStorage
                                              .getCompleteInfo()) {
                                            showAlertDialog(context);
                                          } else {
                                            Routers.push(
                                                "/promote/PromotePage",
                                                context,
                                                {"goodsId": goodInfo?.id});
                                          }
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Image.asset(
                                                'assets/images/goods/friendsMaterial@3x.png',
                                                width: 30,
                                                height: 30),
                                            Container(
                                                margin: EdgeInsets.only(top: 5),
                                                child: Text(
                                                  '推广素材',
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ))
                                          ],
                                        )),
                                  ))
                            ],
                          ),
                        ),
                        Gaps.line,
                        Expanded(
                          flex: 4,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Container(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Text(
                                  goodInfo?.name,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColor.mainTextColor,
                                    fontSize: 15,
                                  ),
                                  strutStyle: StrutStyle(
                                      forceStrutHeight: false,
                                      height: 1,
                                      leading: 0.9),
                                  maxLines: 2,
                                ),
                              )),
                            ],
                          ),
                        ),
                        Gaps.line,
                        Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                  ),
                                  child: Text(
                                    (selectGoodSpec == null)
                                        ? S.of(context).availableStock +
                                            goodInfo?.number.toString()
                                        : S.of(context).availableStock +
                                            selectGoodSpec?.number.toString(),
                                    style: TextStyle(color: Color(0xFF999999)),
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                    ),
                                    child: LikeButton(
                                      size: 24,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      isLiked: goodInfo?.isCollect,
                                      onTap: onLikeButtonTapped,
                                    )),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Gaps.lowBr5,
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).goodsOrigin + goodInfo?.originName,
                      style: TextStyle(
                        color: AppColor.mainTextColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Gaps.lowBr5,
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).netContent + unitCont,
                      style: TextStyle(
                        color: AppColor.mainTextColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Gaps.lowBr5,
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).distribution + '   ' + '本商品由海外配送发货',
                      style: TextStyle(
                        color: AppColor.mainTextColor,
                        fontSize: 17,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    height: 65,
                    padding: EdgeInsets.only(left: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).instructions +
                          '   ' +
                          '本商品均包邮包税，本商品均为海外直邮商品，暂不支持退换货。',
                      style: TextStyle(
                        color: AppColor.mainTextColor,
                        fontSize: 15,
                      ),
                      maxLines: 10,
                    ),
                  ),
                  Gaps.lowBr5,
                  // 商品规格
                  buildProductSpecifications(goodInfo.goods),
                  Gaps.lowBr5,
                  // 商品描述
                  isSelectDetails
                      ? buildCommodityDescription(goodInfo)
                      : buildGoodsMustKnow(),
                  isSelectDetails ? _getListData() : Container(),
                ],
              ),
            )
          : Container(),
      bottomNavigationBar: Material(
          //底部栏整体的颜色
          child: isLoading
              ? Container(
                  height: 44,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 10,
                          child: Container(
                              child: FlatButton.icon(
                                  onPressed: () async {
                                    // 单个商品上架下架
                                    Map<String, dynamic> goodDic;
                                    if (goodInfo.shopProductStatus == 1) {
                                      // 上架状态 点击按钮下架商品操作
                                      goodDic = {
                                        "product_id": goodInfo.id,
                                        "status": "2"
                                      };
                                    } else {
                                      goodDic = {
                                        "product_id": goodInfo.id,
                                        "status": "1"
                                      };
                                    }
                                    await ApiGoods.setProductUpOffShelf(goodDic,
                                        (data) {
                                      if (data.ret == 1) {
                                        setState(() {
                                          if (goodInfo.shopProductStatus == 1) {
                                            // 上架状态 点击按钮下架商品操作
                                            goodInfo.shopProductStatus = 2;
                                            Util.showToast('下架成功');
                                          } else {
                                            goodInfo.shopProductStatus = 1;
                                            Util.showToast('上架成功');
                                          }
                                        });
                                      }
                                    }, (message) => null);
                                  },
                                  icon: (goodInfo.shopProductStatus == 1)
                                      ? ImageIcon(AssetImage(
                                          "assets/images/goods/OffShelves@2x.png"))
                                      : ImageIcon(AssetImage(
                                          "assets/images/goods/UpShelves@3x.png")),
                                  label: Expanded(
                                      child: Text(
                                    (goodInfo.shopProductStatus == 1)
                                        ? S.of(context).offShelves
                                        : S.of(context).upShelves,
                                    style: TextStyle(fontSize: 12),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ))))),
                      Expanded(
                          flex: 10,
                          child: Container(
                            color: AppColor.themeRed,
                            child: FlatButton.icon(
                                onPressed: () {
                                  Routers.push('/editGoodsPricePage', context,
                                      {"goodsId": goodInfo.id});
                                },
                                icon: ImageIcon(AssetImage(
                                    "assets/images/goods/YUAN@3x.png")),
                                label: Expanded(
                                    child: Text(
                                  S.of(context).editPrice,
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ))),
                          )),
                      showthirdBtn(),
                    ],
                  ),
                )
              : Container()),
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

  showthirdBtn() {
    var wid = Expanded(
      flex: this.goodInfo.shopProductStatus == 2 ? 0 : 11,
      child: this.goodInfo.shopProductStatus == 2
          ? Container()
          : Container(
              color: (goodInfo.number != 0)
                  ? AppColor.themeRed
                  : AppColor.textGrayC,
              child: FlatButton(
                  onPressed: () async {
                    if (goodInfo.number == 0) {
                      return;
                    }
                    if (!await LocalStorage.getCompleteInfo()) {
                      showAlertDialog(context);
                    } else {
                      _bottomSheet(context);
                    }
                  },
                  child: Text(
                    (goodInfo.number == 0)
                        ? "已售罄"
                        : S.of(context).placeTheOrder,
                    style: TextStyle(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ))),
    );

    return wid;
  }

  void showShareModal(BuildContext context) {
    showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        builder: (BuildContext context) {
          return ShareDialog(
            goodsInfo: goodInfo,
            qrCode: qrCode,
          );
        });
  }

  /**
   * 下部弹出框
   */
  Future<void> _bottomSheet(BuildContext context) async {
    buyNumber = 1;
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context1, setBottomSheetState) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              height: 350.0,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 70,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: _buildTopRow(),
                  ),
                  Gaps.line,
                  Gaps.line,
                  SingleChildScrollView(
                    child: Container(
                        color: AppColor.white,
                        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        height: 159,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ChoiceChipViewForSpec(
                                shapeNo: 0,
                                selectItem: toPayselectGoodSpec,
                                list: goodInfo.goods,
                                isHightLight: true,
                                onClick: (context) {
                                  setBottomSheetState(() {
                                    if (context.salable == 0) {
                                      return;
                                    }
                                    if (context == toPayselectGoodSpec) {
                                      // toPayselectGoodSpec = null;
                                    } else {
                                      toPayselectGoodSpec = context;
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        )),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          S.of(context).number,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w300),
                        ),
                        NumberControllerWidget(
                          numText: '1',
                          addValueChanged: (number) {
                            print(number);
                            buyNumber = number;
                          },
                          removeValueChanged: (number) {
                            print(number);
                            buyNumber = number;
                          },
                          updateValueChanged: (number) {},
                          inputValueChanged: (number) {
                            print(number);
                            buyNumber = number;
                          },
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().screenWidth / 2,
                        child: _buttom_Text(50, S.of(context).owerPays, "owner",
                            Colors.black, Color(0xffe4382d)),
                      ),
                      Container(
                        width: ScreenUtil().screenWidth / 2,
                        child: _buttom_Text(
                            50,
                            S.of(context).ordersForCustomers,
                            "helpOther",
                            Colors.black,
                            Color(0xFFD2B86F)),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Text(
                  S.of(context).originPrice,
                  style: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  (toPayselectGoodSpec == null)
                      ? "￥" + goodInfo.specPrice?.toStringAsFixed(2)
                      : "￥" + toPayselectGoodSpec.specPrice?.toStringAsFixed(2),
                  style: toPayselectGoodSpec?.discountPrice != 0
                      ? TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationStyle: TextDecorationStyle.wavy,
                          color: AppColor.mainTextColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500)
                      : TextStyle(
                          color: AppColor.mainTextColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ],
            )),
        (toPayselectGoodSpec?.discountPrice != 0)
            ? Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text(
                      "VIP价",
                      style: TextStyle(color: Color(0xFF999999), fontSize: 13),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      (toPayselectGoodSpec == null)
                          ? "￥" + goodInfo.totalPrice?.toStringAsFixed(2)
                          : "￥" +
                              toPayselectGoodSpec?.discountPrice
                                  ?.toStringAsFixed(2),
                      style: TextStyle(color: AppColor.textRed, fontSize: 17),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ))
            : SizedBox(
                width: 0,
              ),
        Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Text(
                  S.of(context).salePrice,
                  style: TextStyle(color: Color(0xFF999999), fontSize: 13),
                  textAlign: TextAlign.left,
                ),
                Text(
                  (toPayselectGoodSpec == null)
                      ? "￥" + goodInfo.totalPrice?.toStringAsFixed(2)
                      : "￥" +
                          toPayselectGoodSpec.totalPrice?.toStringAsFixed(2),
                  style: TextStyle(color: AppColor.mainTextColor, fontSize: 17),
                  textAlign: TextAlign.left,
                ),
              ],
            )),
        Expanded(
          flex: 1,
          child: Column(
            children: <Widget>[
              Text(
                S.of(context).inventory,
                style: TextStyle(color: Color(0xFF999999), fontSize: 13),
                textAlign: TextAlign.left,
              ),
              Text(
                (toPayselectGoodSpec == null)
                    ? goodInfo.number.toString()
                    : toPayselectGoodSpec.number.toString(),
                style: TextStyle(
                    color: AppColor.mainTextColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        SizedBox(width: 40),
      ],
    );
  }

  /**
   * 下部弹出普通组件
   */
  _buttom_Text(
      double heigh, String text, String type, Color color, Color backColor) {
    return GestureDetector(
        onTap: () {
          switch (type) {
            case "owner":
              {
                // 店主自付
                if (toPayselectGoodSpec == null) {
                  Util.showToast('请选择规格');
                  break;
                }
                if (buyNumber == 0) {
                  Util.showToast('商品下单数量不能为0');
                  break;
                }
                if (buyNumber > toPayselectGoodSpec.number) {
                  Util.showToast('商品下单数量不能为超过库存');
                  break;
                }
                if (goodInfo.shopProductStatus != 1) {
                  Util.showToast('先上架商品才能下单');
                  break;
                }

                if (toPayselectGoodSpec.isShow == 0) {
                  Util.showToast('先启用商品规格才能下单');
                  break;
                }
                Navigator.of(context).pop();
                Map postData = {
                  "num": buyNumber,
                  "specGoods": toPayselectGoodSpec,
                  "baseGoods": goodInfo,
                  "payState": 2
                };
                Routers.push("/orderSettlement", context, postData);
                // getImage(type);
                /*Navigator.of(context).push(
                  CustomRoute(EditGreenhouse(id: id), customRoute));*/
                break;
              }
            case "helpOther":
              {
                if (toPayselectGoodSpec == null) {
                  Util.showToast('请选择规格');
                  break;
                }
                if (buyNumber == 0) {
                  Util.showToast('商品下单数量不能为0');
                  break;
                }
                if (buyNumber > toPayselectGoodSpec.number) {
                  Util.showToast('商品下单数量不能为超过库存');
                  break;
                }
                if (goodInfo.shopProductStatus != 1) {
                  Util.showToast('先上架商品才能下单');
                  break;
                }
                if (toPayselectGoodSpec.isShow == 0) {
                  Util.showToast('先启用商品规格才能下单');
                  break;
                }
                // 帮客户下单
                Navigator.of(context).pop();
                Map postData = {
                  "num": buyNumber,
                  "specGoods": toPayselectGoodSpec,
                  "baseGoods": goodInfo,
                  "payState": 1
                };
                Routers.push("/orderSettlement", context, postData);
                break;
              }
            case "Cancel":
              {
                //取消
                Navigator.of(context).pop();
                break;
              }
          }
        },
        child: Container(
            color: backColor,
            height: heigh,
            width: ScreenUtil().screenWidth / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(fontSize: 14.0, color: color),
                ),
              ],
            )));
  }

  _getListData() {
    List imglist = [];
    for (String imgUrl in goodInfo.detailDescription) {
      var newImg = LoadImage(
        imgUrl,
        fit: BoxFit.fitWidth,
        holderImg: "home/banner@3x",
        format: "jpg",
      );
      imglist.add(newImg);
    }
    var row_colum = Container(
      child: ListView.builder(
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          itemCount: imglist.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return imglist[index];
          }),
    );
    return row_colum;
  }

  Widget buildProductSpecifications(List btnList) {
    return Column(
      children: <Widget>[
        Container(
          height: 40,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(S.of(context).goodsSpecifications,
                  style: TextStyle(
                    color: AppColor.mainTextColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ChoiceChipViewForSpec(
                  shapeNo: 0,
                  selectItem: selectGoodSpec,
                  list: btnList,
                  isHightLight: true,
                  onClick: (context) {
                    setState(() {
                      if (context == selectGoodSpec) {
                        // selectGoodSpec = null;
                      } else {
                        selectGoodSpec = context;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Gaps.lowBr5,
        Container(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  flex: 10,
                  child: Container(
                      height: 44,
                      child: FlatButton(
                          color: isSelectDetails
                              ? AppColor.themeRed
                              : Colors.white,
                          onPressed: () {
                            if (isSelectDetails) {
                              return;
                            }
                            setState(() {
                              isSelectDetails = !isSelectDetails;
                            });
                          },
                          child: Text(
                            S.of(context).goodsDetails,
                            style: TextStyle(fontSize: 15),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )))),
              SizedBox(
                width: 1,
                height: 44,
                child: const DecoratedBox(
                    decoration: BoxDecoration(color: AppColor.line)),
              ),
              Expanded(
                  flex: 10,
                  child: Container(
                    height: 44,
                    child: FlatButton(
                        color:
                            !isSelectDetails ? AppColor.themeRed : Colors.white,
                        onPressed: () {
                          if (!isSelectDetails) {
                            return;
                          }
                          setState(() {
                            isSelectDetails = !isSelectDetails;
                          });
                        },
                        child: Text(
                          S.of(context).mustKnow,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                  )),
            ],
          ),
        ),
        Gaps.lowBr5,
      ],
    );
  }

  Widget buildCommodityDescription(GoodsDetailInfo goodInfo) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              height: 40,
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Text(S.of(context).goodsDescription,
                  style: TextStyle(
                    color: AppColor.mainTextColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 10),
                child: Text(
                  goodInfo.description,
                  style: TextStyle(
                    color: AppColor.mainTextColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 100,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildGoodsMustKnow() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              height: 40,
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Text(S.of(context).mustKnow,
                  style: TextStyle(
                    color: AppColor.mainTextColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 10),
                child: Text(
                  goodsMustKnow,
                  style: TextStyle(
                    color: AppColor.mainTextColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 100,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

// 商品信息  价格
Widget buildColmun(Map dic) {
  bool isDisP = false;
  bool hasLine = false;
  if (dic["name"] == 'VIP价') {
    isDisP = true;
  }
  if (dic["hasDis"] != null) {
    hasLine = dic["hasDis"];
  }

  return Container(
    height: 60,
    padding: EdgeInsets.only(top: 10),
    width: ScreenUtil().screenWidth / 4,
    child: Column(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      "${dic["name"]}",
                      style: TextStyle(
                          fontSize: 14, fontFamily: "PingFang-SC-Regular"),
                    ))
              ],
            )),
        Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 12),
                    child: Text(
                      "${dic["price"]}",
                      style: hasLine
                          ? TextStyle(
                              decoration: TextDecoration.lineThrough,
                              decorationStyle: TextDecorationStyle.wavy,
                              color: isDisP
                                  ? AppColor.textRed
                                  : AppColor.mainTextColor,
                              fontSize: 14,
                              fontFamily: "PingFang-SC-Medium")
                          : TextStyle(
                              color: isDisP
                                  ? AppColor.textRed
                                  : AppColor.mainTextColor,
                              fontSize: 14,
                              fontFamily: "PingFang-SC-Medium"),
                    ))
              ],
            )),
      ],
    ),
  );
}

//banner 图
Widget buildStyle1(GoodsDetailInfo goodInfo) {
  return Container(
    padding: EdgeInsets.only(top: 0, bottom: 0),
    height: 280 * ScreenUtil().screenWidth / 375,
    // color: Color(0xFFF5F5F9),
    child: new Swiper(
      // 横向
      scrollDirection: Axis.horizontal,
      // 布局构建
      itemBuilder: (BuildContext context, int index) {
        // 轮播图图片地址
        String imgUrl = goodInfo?.majorPhoto[index];
        return LoadImage(
          imgUrl,
          fit: BoxFit.fitWidth,
          holderImg: "home/banner@3x",
          format: "png",
        );
      },
      //条目个数
      itemCount: goodInfo?.majorPhoto?.length,
      // 自动翻页
      autoplay: goodInfo?.majorPhoto?.length == 1 ? false : true,
      // 分页指示
      pagination: buildPlugin(),
      //点击事件
      onTap: (index) {
        print(" 点击 " + index.toString());
      },
      // 相邻子条目视窗比例
      viewportFraction: 1,
      // 布局方式
      //layout: SwiperLayout.STACK,
      // 用户进行操作时停止自动翻页
      autoplayDisableOnInteraction: true,
      // 无线轮播
      loop: true,
      //当前条目的缩放比例
      scale: 1,
    ),
  );
}

buildPlugin() {
  var dog = DotSwiperPaginationBuilder(
      activeColor: Color(0xFF1E1E1E), color: Color(0xFFE9E9E9), size: 8);
  return SwiperPagination(
    builder: dog,
  );
}

class ShareDialog extends StatefulWidget {
  ShareDialog(
      {Key key,
      this.createSimpleDialog,
      this.items,
      this.goodsInfo,
      this.qrCode})
      : super(key: key);
  final List<DropdownMenuItem> items;
  final Function createSimpleDialog;
  final GoodsDetailInfo goodsInfo;
  final Map qrCode;

  @override
  _ShareDialogState createState() =>
      new _ShareDialogState(goodInfo: goodsInfo, qrCode: qrCode);
}

class _ShareDialogState extends State<ShareDialog> {
  final GoodsDetailInfo goodInfo;
  final Map qrCode;
  _ShareDialogState({this.goodInfo, this.qrCode});

  @override
  void initState() {
    super.initState();
    setState(() {});
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
                      //     shareToWeChat(WeChatShareMiniProgramModel(
                      //       webPageUrl: 'https://esale.nle-tech.com/',
                      //       path: goodInfo.sharepath,
                      //       miniProgramType: WXMiniProgramType.RELEASE,
                      //       userName: 'gh_0b843255dd9c',
                      //       title: goodInfo?.name,
                      //       thumbnail: WeChatImage.asset(
                      //           'assets/images/common/user_logo.png'),
                      //     ));
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
                              style: TextStyle(fontSize: 10),
                            ))
                      ],
                    )),
                GestureDetector(
                    onTap: () {
                      // isWeChatInstalled.then((installed) {
                      //   if (installed) {
                      //     Navigator.of(context).pop();
                      //     shareToWeChat(WeChatShareWebPageModel(
                      //         widget.goodsInfo.shareurl.isEmpty
                      //             ? "www.baidu.com"
                      //             : widget.goodsInfo.shareurl,
                      //         title: widget.goodsInfo?.name,
                      //         thumbnail: WeChatImage.asset(
                      //             'assets/images/common/user_logo.png'),
                      //         scene: WeChatScene.TIMELINE));
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
                            child: Text('朋友圈', style: TextStyle(fontSize: 10)))
                      ],
                    )),
                GestureDetector(
                    onTap: () async {
                      EasyLoading.show(status: '保存图片...');
                      var response = await Dio().get(qrCode['qr_code'],
                          options: Options(responseType: ResponseType.bytes));
                      final result = await ImageGallerySaver.saveImage(
                          Uint8List.fromList(response.data));
                      EasyLoading.dismiss();
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
                              style: TextStyle(fontSize: 10),
                            ))
                      ],
                    )),
                GestureDetector(
                    onTap: () {
                      ClipboardData data = new ClipboardData(
                          text: widget.goodsInfo.shareurl.isNotEmpty
                              ? widget.goodsInfo.shareurl
                              : '');
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
                              style: TextStyle(fontSize: 10),
                            ))
                      ],
                    )),
              ],
            )),
      ],
    ));
  }
}
