import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/model/shop/coupons_info.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/shop/coupon/coupon_manager_provider.dart';
import 'package:E_Sale_Tech/views/shop/coupon/coupon_status_util.dart';
import 'package:E_Sale_Tech/views/shop/shop_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:fluwx/fluwx.dart';
import 'package:provider/provider.dart';

import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/components/list_refresh.dart' as listComp;
import 'package:intl/intl.dart';

class CouponManager extends StatefulWidget {
  @override
  _CouponManagerState createState() => _CouponManagerState();
}

class _CouponManagerState extends State<CouponManager>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController _pageController = PageController(initialPage: 0);
  CouponManagerIndexProvider provider = CouponManagerIndexProvider();
  TabController _tabController;
  GlobalKey _bodyKey = GlobalKey();
  TextEditingController _textKeywordController = new TextEditingController();
  final FocusNode _nodeKeyword = FocusNode();

  String keyword = '';
  final statusArr = [
    {'status': ''},
    {'status': 1},
    {'status': 2},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    _textKeywordController.dispose();
    super.dispose();
  }

  _onPageChange(int index) {
    _tabController.animateTo(index);
    provider.setIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<CouponManagerIndexProvider>(
        create: (_) => provider,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: MyAppBar(
              centerTitle: "优惠券管理",
            ),
            backgroundColor: Color(0xffF8F8F8),
            bottomNavigationBar: Material(
              //底部栏整体的颜色
              color: Color(0xffe4382d),
              child: FlatButton(
                child: new Padding(
                  padding: new EdgeInsets.all(10),
                  child: Text("创建优惠券",
                      style: TextStyle(
                        fontSize: 18.0, //textsize
                        color: Colors.white, // textcolor
                      )),
                ),
                color: Color(0xffe4382d),
                onPressed: () {
                  Routers.push('/shop/coupon/setCoupon', context);
                },
              ),
            ),
            body: Column(
              key: _bodyKey,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: TabBar(
                    onTap: (index) {
                      if (!mounted) {
                        return;
                      }
                      _pageController.jumpToPage(index);
                    },
                    isScrollable: false,
                    controller: _tabController,
                    labelColor: AppColor.themeRed,
                    labelStyle: AppText.textBoldDark14,
                    unselectedLabelColor: AppColor.textDark,
                    unselectedLabelStyle: AppText.textDark14,
                    indicatorColor: AppColor.themeRed,
                    tabs: <Widget>[
                      _TabView("全部", "", null),
                      _TabView("已投放", "", 1),
                      _TabView("已失效", "", 2),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    key: const Key('pageView'),
                    itemCount: 3,
                    onPageChanged: _onPageChange,
                    controller: _pageController,
                    itemBuilder: (BuildContext context, int index) {
                      return CouponManagerList(params: {
                        'status': statusArr[index]['status'],
                      });
                    },
                  ),
                )
              ],
            )));
  }
}

class CouponManagerList extends StatefulWidget {
  CouponManagerList({Key key, @required this.params});

  final Map<String, dynamic> params;

  @override
  _CouponManagerListState createState() => _CouponManagerListState();
}

class _CouponManagerListState extends State<CouponManagerList> {
  final GlobalKey<_CouponManagerListState> key = GlobalKey();

  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> params = {
      "page": (++pageIndex),
      "status": this.widget.params['status'],
    };

    var data = ApiShop.getCouponsList(params);
    return data;
  }

  void launchCoupon(id, idx) {
    EasyLoading.show(status: '加载中');
    ApiShop.getCouponShareUrl(id, (data) {
      EasyLoading.dismiss();
      if (data?.data['share_url'] != null) {
        // isWeChatInstalled.then((installed) {
        //   if (installed) {
        //     String shopName =
        //         Provider?.of<ShopInfoProvider>(context, listen: false)
        //             ?.shopInfo
        //             ?.name;
        //     shareToWeChat(WeChatShareWebPageModel(data.data['share_url'],
        //         title: '${shopName}分享给你一张优惠券，正品好货等你买，超值划算，快来选购吧',
        //         thumbnail:
        //             WeChatImage.asset('assets/images/common/user_logo.png'),
        //         scene: WeChatScene.SESSION));
        //   } else {
        //     Util.showToast("请先安装微信");
        //   }
        // });
      }
    }, (message) => EasyLoading.dismiss());
  }

  Widget renderItem(index, CouponsList item) {
    return CouponManagerItem(
        info: item, idx: index, launchCoupon: launchCoupon);
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

class CouponManagerItem extends StatelessWidget {
  const CouponManagerItem({Key key, this.info, this.idx, this.launchCoupon})
      : super(key: key);

  final CouponsList info;
  final int idx;
  final Function launchCoupon;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                border: Border(
              bottom: Divider.createBorderSide(context,
                  color: AppColor.line, width: 1),
            )),
            padding: const EdgeInsets.only(
                top: 10, bottom: 10, left: 15.0, right: 15.0),
            child: Row(
              children: <Widget>[
                Image.asset('assets/images/shop/icon_discount@3x.png',
                    width: 16, height: 16),
                Expanded(
                  child: Text(info.type == 1
                      ? '抵用券'
                      : info.type == 2
                          ? '折扣券'
                          : ''),
                  flex: 4,
                ),
                Expanded(
                  child: new Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        info?.statusName,
                        style: TextStyle(color: Color(0xFFE45151)),
                      )),
                  flex: 2,
                ),
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.all(15),
              child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '优惠券名称',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            info?.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        info?.type == 1 ? '使用门槛' : '折扣率',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            info?.type == 1
                                ? ((num.parse(info?.threshold) ?? 0) == 0
                                    ? '无门槛'
                                    : '满' + info?.threshold + '可用')
                                : (num.parse(info?.amount).toStringAsFixed(0) ??
                                        '0') +
                                    '%',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '适用范围',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            CouponStatus.scopeFunc(info?.scope),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '发放总量',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            info?.dispatchAmount.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '每人限领',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            info?.customerLimit.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '有效期',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            DateFormat('yyyy-MM-dd')
                                    .format(DateTime.parse(info?.beginTime)) +
                                '-' +
                                DateFormat('yyyy-MM-dd')
                                    .format(DateTime.parse(info?.endTime)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
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
                info.scope != 0
                    ? Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        width: 95,
                        height: 30,
                        child: RaisedButtonCustom(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColor.textBlack),
                          onPressed: () {
                            var url = '';
                            if (info.scope == 1) {
                              url = '/shop/coupon/setCouponSelectGoods';
                            } else if (info.scope == 2) {
                              url = '/shop/coupon/setCouponSelectBrand';
                            } else if (info.scope == 3) {
                              url = '/shop/coupon/setCouponSelectCategory';
                            }
                            Routers.push(
                                url, context, {'type': 'view', 'id': info.id});
                          },
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 0.8, style: BorderStyle.solid),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          textColor: Colors.black,
                          padding: EdgeInsets.all(0),
                          color: Colors.white,
                          txt: '查看',
                          // padding: EdgeInsets.all(0)
                        ))
                    : SizedBox(),
                info?.shareEnabled == 1
                    ? Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        width: 95,
                        height: 30,
                        child: RaisedButtonCustom(
                          onPressed: () {
                            launchCoupon(info.id, idx);
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
                          txt: '投放',
                        ))
                    : SizedBox(),
              ],
            ),
          )
        ],
      ),
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
    return Consumer<CouponManagerIndexProvider>(
      builder: (_, provider, child) {
        return Tab(
            child: Container(
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
