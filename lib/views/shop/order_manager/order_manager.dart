import 'dart:io';

import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/components/input/base_input.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/model/shop/order_downLoad_info.dart';
import 'package:E_Sale_Tech/model/shop/orders_info.dart';
import 'package:E_Sale_Tech/utils/action_sheet.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/shop/order_manager/order_manager_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:fluwx/fluwx.dart';
import 'package:provider/provider.dart';

import 'package:E_Sale_Tech/components/common_app_bar.dart';

import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/components/list_refresh.dart' as listComp;
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';

class OrderManager extends StatefulWidget {
  @override
  _OrderManagerState createState() => _OrderManagerState();
}

class _OrderManagerState extends State<OrderManager>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final subtitleStyle = TextStyle(color: Color(0xff999999));
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController _pageController = PageController(initialPage: 0);
  OrderManagerIndexProvider provider = OrderManagerIndexProvider();
  TabController _tabController;
  GlobalKey _bodyKey = GlobalKey();
  TextEditingController _textKeywordController = new TextEditingController();
  final FocusNode _nodeKeyword = FocusNode();

  String keyword = '';
  //  201 待支付
  //  300 - 400 待发货
  //  401 已发货
  //  402 已清关
  //  403 待收货
  //  502 已完成
  final statusArr = [
    {'status': ''},
    {'status': 201},
    {'status': 300},
    {'status': 401},
    {'status': 402},
    {'status': 403},
    {'status': 502},
    {'status': 700},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 8);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    // _textKeywordController.dispose();
    super.dispose();
  }

  _onPageChange(int index) {
    _tabController.animateTo(index);
    provider.setIndex(index);
  }

  void showScopeSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => child,
    ).then((value) async {
      FocusScope.of(context).requestFocus(FocusNode());
      if (value == null) return;
      setState(() {
        provider.setOrderSource(value);
        keyword = '';
        _textKeywordController.text = '';
        ApplicationEvent.event.fire(ListRefreshEvent('refresh'));
      });
    });
  }

  Widget buildSearch(BuildContext context) {
    Widget widget = Container(
      height: 35,
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        color: Color(0xffF5F5F9),
      ),
      child: BaseInput(
        isSearchInput: true,
        maxLength: 50,
        prefixIcon: Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(vertical: 11.0),
        hintText: "请输入订单号/姓名/联系方式",
        controller: _textKeywordController,
        focusNode: _nodeKeyword,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.go,
        onSubmitted: (res) {
          if (ApplicationEvent.event != null) {
            setState(() {
              keyword = res;
            });
            ApplicationEvent.event.fire(ListRefreshEvent('refresh'));
          }
        },
        onChanged: (res) {
          setState(() {
            keyword = res;
          });
        },
      ),
    );
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<OrderManagerIndexProvider>(
        create: (_) => provider,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: MyAppBar(
              centerTitle: "订单管理",
              actionName: '订单来源',
              onPressed: () {
                showScopeSheet(
                  context: context,
                  child: CupertinoActionSheet(
                    title: const Text('订单来源'),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center, child: Text('全部')),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.done,
                                  color: provider.orderSource == 0
                                      ? AppColor.themeRed
                                      : Colors.transparent,
                                ))
                          ],
                        ),
                        onPressed: () {
                          Navigator.pop(context, 0);
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center, child: Text('店铺')),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.done,
                                  color: provider.orderSource == 2
                                      ? AppColor.themeRed
                                      : Colors.transparent,
                                ))
                          ],
                        ),
                        onPressed: () async {
                          Navigator.pop(context, 2);
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center, child: Text('我的')),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.done,
                                  color: provider.orderSource == 1
                                      ? AppColor.themeRed
                                      : Colors.transparent,
                                ))
                          ],
                        ),
                        onPressed: () async {
                          Navigator.pop(context, 1);
                        },
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text('取消'),
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context, null);
                      },
                    ),
                  ),
                );
              },
            ),
            backgroundColor: Color(0xffF8F8F8),
            body: Column(
              key: _bodyKey,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: buildSearch(context),
                ),
                Container(
                  color: Colors.white,
                  child: TabBar(
                    onTap: (index) {
                      if (!mounted) {
                        return;
                      }
                      _pageController.jumpToPage(index);
                    },
                    isScrollable: true,
                    controller: _tabController,
                    labelColor: AppColor.themeRed,
                    labelStyle: AppText.textBoldDark14,
                    unselectedLabelColor: AppColor.textDark,
                    unselectedLabelStyle: AppText.textDark14,
                    indicatorColor: AppColor.themeRed,
                    tabs: <Widget>[
                      _TabView("全部订单", "", null),
                      _TabView("待支付", "", 201),
                      _TabView("待发货", "", 300),
                      _TabView("已发货", "", 401),
                      _TabView("已清关", "", 402),
                      _TabView("待收货", "", 403),
                      _TabView("已收货", "", 502),
                      _TabView("退款售后", "", 700),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    key: const Key('pageView'),
                    itemCount: 8,
                    onPageChanged: _onPageChange,
                    controller: _pageController,
                    itemBuilder: (BuildContext context, int index) {
                      return OrderManagerList(params: {
                        'status': statusArr[index]['status'],
                        'keyword': keyword,
                      });
                    },
                  ),
                )
              ],
            )));
  }
}

class OrderManagerList extends StatefulWidget {
  OrderManagerList({Key key, @required this.params});

  final Map<String, dynamic> params;

  @override
  _OrderManagerListState createState() => _OrderManagerListState();
}

class _OrderManagerListState extends State<OrderManagerList> {
  final GlobalKey<_OrderManagerListState> key = GlobalKey();

  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  loadList({type}) async {
    if (type == 'reset') {
      widget.params['keyword'] = '';
    }
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> params = {
      "page": (++pageIndex),
      "status": this.widget.params['status'],
      "keyword": this.widget.params['keyword'],
      "owner": Provider?.of<OrderManagerIndexProvider>(context, listen: false)
          ?.orderSource,
    };

    var data = ApiShop.getOrdersList(params);
    return data;
  }

  /// 每个item的样式
  Widget renderItem(index, OrdersListInfo item) {
    return OrderManagerItem(info: item, index: index);
  }

  @override
  Widget build(BuildContext context) {
    return listComp.ListRefresh(
      renderItem: renderItem,
      refresh: loadList,
      more: loadMoreList,
    );
  }
}

class OrderManagerItem extends StatelessWidget {
  const OrderManagerItem(
      {Key key, @required this.info, @required this.index, this.type})
      : super(key: key);

  final OrdersListInfo info;
  final String type;
  final int index;

  void share(String url) {
    // isWeChatInstalled.then((installed) {
    //   shareToWeChat(WeChatShareWebPageModel(url,
    //       title: "商品已经帮你选购好了，快来支付吧",
    //       thumbnail: WeChatImage.asset('assets/images/common/user_logo.png'),
    //       scene: WeChatScene.SESSION));
    // });
  }

  void confirmOrderCheck() {
    ApiShop.setOrdersCheck(info.id, (data) {
      print(data);
      if (data.ret == 1) {
        ApplicationEvent.event.fire(ListRefreshEvent('refresh'));
        Util.showToast('操作成功');
      }
    }, (message) => null);
  }

  void orderPayment() {
    // isWeChatInstalled.then((installed) {
    //   if (installed) {
    //     ApiShop.getOrderPaymentParams({'order_id': info.id}, (data) {
    //       if (info.type == 1) {
    //         share(data['code_url']);
    //       } else {
    //         Map appconfig = data["app_config"];
    //         payWithWeChat(
    //           appId: appconfig['appid'],
    //           partnerId: appconfig['partnerid'],
    //           prepayId: appconfig['prepayid'],
    //           packageValue: appconfig['package'],
    //           nonceStr: appconfig['noncestr'],
    //           timeStamp: appconfig['timestamp'],
    //           sign: appconfig['sign'],
    //         );
    //       }
    //     }, (message) => null);
    //   } else {
    //     Util.showToast("请先安装微信");
    //   }
    // });
  }

  void showActionSheet(context) {
    showCupertinoDialog<int>(
        context: context,
        builder: (cxt) {
          return CupertinoAlertDialog(
            title: Text("提示"),
            content: Text('确认取消订单？'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(cxt, 2);
                },
              ),
              CupertinoDialogAction(
                child: Text("确认"),
                onPressed: () {
                  Navigator.pop(cxt, 1);
                },
              ),
            ],
          );
        }).then((value) => {
          if (value == 1) {cancelOrder()}
        });
  }

  Future<File> createFileOfPdfUrl(String url) async {
    EasyLoading.show(status: "下载发票...");
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  void cancelOrder() {
    ApiShop.cancelOrderPayment(info.id, (data) {
      if (data.ret == 1) {
        Util.showToast('取消成功');
        ApplicationEvent.event.fire(ListRefreshEvent('refresh'));
      }
    }, (message) => null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Routers.push(
            "/shop/orderManager/detail", context, {"id": this.info.id});
      },
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: Divider.createBorderSide(context,
                    color: AppColor.line, width: 0.8),
              )),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Image.asset('assets/images/shop/file-text@3x.png'),
                      width: 16,
                      height: 16),
                  Expanded(
                    child: Text('${info?.orderSn ?? 0}'),
                    flex: 4,
                  ),
                  Expanded(
                    child: new Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          info?.statusName ?? '',
                          style: TextStyle(color: Color(0xFFE45151)),
                        )),
                    flex: 2,
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.all(5),
                child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                            height: 100.9,
                            child: CachedNetworkImage(
                                imageUrl: info.ordersOrderItem[0].imageUrl,
                                placeholder: (context, url) =>
                                    const CircleAvatar(
                                      backgroundColor: Color(0xffF8F8F8),
                                    ),
                                imageBuilder: (context, image) => Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: image,
                                        ),
                                      ),
                                    ))),
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 10, right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  info?.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                      '规格: ${info?.ordersOrderItem != null ? info?.ordersOrderItem[0]?.specName : ''}',
                                      style: TextStyle(
                                          color: Color(0xFF999999),
                                          fontSize: 12),
                                    )),
                                    Text(
                                      '   x${info?.ordersOrderItem != null ? info?.ordersOrderItem[0]?.qty : ''}',
                                      style: TextStyle(
                                          color: Color(0xFF999999),
                                          fontSize: 12),
                                    )
                                  ],
                                )
                              ],
                            )),
                        flex: 8,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '￥${info?.ordersPayment?.paymentFee?.toStringAsFixed(2) ?? 0}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text('共${info?.qty ?? 0}件',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff999999))))
                          ],
                        ),
                        flex: 3,
                      ),
                    ],
                  ),
                  // Gaps.vGap5,
                ])),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border(
                top: Divider.createBorderSide(context,
                    color: AppColor.line, width: 1),
              )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ((info.status > 500 && info.status < 600) ||
                          info.status == 702)
                      ? Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          width: 95,
                          height: 30,
                          child: RaisedButtonCustom(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: AppColor.textBlack),
                            onPressed: () {
                              showActionSheetWithDownLoadInvoice(context);
                            },
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.8, style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            textColor: Colors.black,
                            padding: EdgeInsets.all(0),
                            color: Colors.white,
                            txt: '下载发票',
                          ))
                      : SizedBox(),
                  info.status == 300
                      ? Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          width: 95,
                          height: 30,
                          child: RaisedButtonCustom(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: AppColor.textBlack),
                            onPressed: () {
                              Routers.push('/me/myCustomerService', context);
                            },
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.8, style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            textColor: Colors.black,
                            padding: EdgeInsets.all(0),
                            color: Colors.white,
                            txt: '申请退款',
                          ))
                      : SizedBox(),
                  info.status == 201
                      ? Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          width: 95,
                          height: 30,
                          child: RaisedButtonCustom(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: AppColor.textBlack),
                            onPressed: () {
                              showActionSheet(context);
                            },
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.8, style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            textColor: Colors.black,
                            padding: EdgeInsets.all(0),
                            color: Colors.white,
                            txt: '取消订单',
                          ))
                      : SizedBox(),
                  info?.status == 201
                      ? Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          width: 95,
                          height: 30,
                          child: RaisedButtonCustom(
                            onPressed: () {
                              orderPayment();
                            },
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(
                                    color: AppColor.themeRed,
                                    width: 1.0,
                                    style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            textColor: AppColor.themeRed,
                            padding: EdgeInsets.all(0),
                            color: Colors.white,
                            txt: '立即支付',
                          ))
                      : SizedBox(),
                  info?.status == 403 && info?.owner == 1
                      ? Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          width: 95,
                          height: 30,
                          child: RaisedButtonCustom(
                            onPressed: () {
                              showCupertinoDialog<int>(
                                  context: context,
                                  builder: (cxt) {
                                    return CupertinoAlertDialog(
                                      title: Text("提示"),
                                      content: Text('确认收货？'),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          child: Text("取消"),
                                          onPressed: () {
                                            Navigator.pop(cxt, 2);
                                          },
                                        ),
                                        CupertinoDialogAction(
                                          child: Text("确认"),
                                          onPressed: () {
                                            Navigator.pop(cxt, 1);
                                          },
                                        ),
                                      ],
                                    );
                                  }).then((value) => {
                                    if (value == 1) {confirmOrderCheck()}
                                  });
                            },
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(
                                    color: AppColor.themeRed,
                                    width: 1.0,
                                    style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            textColor: AppColor.themeRed,
                            padding: EdgeInsets.all(0),
                            color: Colors.white,
                            txt: '确认收货',
                          ))
                      : SizedBox(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showActionSheetWithDownLoadInvoice(context) {
    List<OrderDownLoadInfo> listData = [];
    ApiShop.getOrderInfoWithInvoice(info.id, (data) {
      if (data.ret == 1) {
        data.data.forEach((order) {
          listData.add(OrderDownLoadInfo.fromJson(order));
        });
        // 使用方式
// enum Fruit { APPLE, BANANA, ORANGE }
        new ActionSheet<OrderDownLoadInfo>(
          context: context,
          // 显示取消选项
          showCancel: true,
          // 选中事件
          onClickItem: (fruit) {
            createFileOfPdfUrl(fruit.url).then((value) {
              EasyLoading.dismiss();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PDFScreen(value.path)),
              );
            });
          },
          // 选项
          children: getActionSheetList(listData),
        ).show();
        // BottomActionSheet.show(context, listData, title: '请选择下载面单',
        //     callBack: (i) {
        //   OrderDownLoadInfo model = listData[i];
        //   createFileOfPdfUrl(model.url).then((value) {
        //     EasyLoading.dismiss();
        //     Navigator.pop(context);
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => PDFScreen(value.path)),
        //     );
        //   });
        //   return;
        // });
      }
    }, (message) => null);
  }
}

getActionSheetList(List dataList) {
  List<ActionSheetItem> listData123 = [];
  for (OrderDownLoadInfo item in dataList) {
    listData123.add(ActionSheetItem(label: item.type, value: item));
  }
  return listData123;
}

List actionSheetList2(List actionSheetList) => actionSheetList;

Future<File> createFileOfPdfUrl(String url) async {
  EasyLoading.show(status: "下载发票...");
  final filename = url.substring(url.lastIndexOf("/") + 1);
  var request = await HttpClient().getUrl(Uri.parse(url));
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response);
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = new File('$dir/$filename');
  await file.writeAsBytes(bytes);
  return file;
}

/// /////////////////////////// 显示 pdf 图文件 //////////////////////////// ///
class PDFScreen extends StatelessWidget {
  String pathPDF = "";

  PDFScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("发票文档"),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.share),
          //   onPressed: () {},
          // ),
        ],
      ),
      path: pathPDF,
    );
  }
}

class _TabView extends StatelessWidget {
  const _TabView(this.tabName, this.tabSub, this.index);

  final String tabName;
  final String tabSub;
  final int index;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final num finalTabWidth = size.width > 450 ? size.width / 5 : 50;
    return Consumer<OrderManagerIndexProvider>(
      builder: (_, provider, child) {
        return Tab(
            child: Container(
          constraints: BoxConstraints(
            minWidth: finalTabWidth.toDouble(),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(tabName),
              Offstage(
                  offstage: provider.index != index,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: Text(tabSub,
                        style: TextStyle(fontSize: AppText.smallSize)),
                  )),
            ],
          ),
        ));
      },
    );
  }
}
