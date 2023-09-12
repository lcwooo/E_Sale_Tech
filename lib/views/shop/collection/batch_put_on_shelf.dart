import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/model/shop/brand_info.dart';
import 'package:E_Sale_Tech/model/shop/category_info.dart';
import 'package:E_Sale_Tech/model/shop/products_info.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/shop/collection/batch_put_on_shelf_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:E_Sale_Tech/api/shop.dart';

class BatchPutOnShelf extends StatefulWidget {
  BatchPutOnShelf({this.arguments});
  final Map arguments;
  @override
  _BatchPutOnShelfState createState() =>
      _BatchPutOnShelfState(arguments: arguments);
}

class _BatchPutOnShelfState extends State<BatchPutOnShelf> {
  _BatchPutOnShelfState({this.arguments});
  final Map arguments;
  dynamic status;
  String keyword;
  String brandId;
  String categoryId;
  num sortby;

  String whetherSellSelect = '';
  ScrollController _scrollController = new ScrollController();

  final GlobalKey<_ChoiceChipViewState> childKey1 =
      GlobalKey<_ChoiceChipViewState>();
  final GlobalKey<_ChoiceChipViewBrandsState> childKey2 =
      GlobalKey<_ChoiceChipViewBrandsState>();

  List<ProductsItem> dataList = [];
  List<BrandList> selectList = [];
  List<int> selectedBrandList = [];
  List<int> selectedCategoryList = [];
  List<CategoryList> classificationList = []; // 分类数据
  List<BrandList> brandsList = []; // 品牌数据
  List upShelfSelectedList = [];
  List selectedSearchData = []; //选择的搜索数据
  dynamic selectedStock = '';
  List chipList = []; // 标签列表
  List<GlobalKey<_ChoiceChipViewCategriesState>> globalKey =
      []; // GlobalKey List
  int selectCategories = 0; //左侧分类按钮选择
  int pageIndex = 0;
  bool isPerformingRequest = false;
  List<String> titleList = [];
  bool isCanSelectGoods = true; // 是否可以批量上架
  int pushBy = 0; // 1 我的收藏 2商品管理 3选品
  bool isShowBackBtn = false;
// pushByGoods
  final Color iconColor = Color(0xffCBCBCB);
  final Color iconSelectedColor = Color(0xffe4382d);
  final GlobalKey<InnerDrawerState> _scaffoldKey =
      GlobalKey<InnerDrawerState>();

  @override
  void initState() {
    super.initState();
    // type  true 批量选择  false 单个选择
    if (this.arguments["type"] != null) {
      setState(() {
        pushBy = this.arguments["type"];
        isShowBackBtn = this.arguments["showBackBtn"];
      });
    }

    getBrands();
    getCategory();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadList();
      setState(() {
        if (this.arguments["type"] != 3) {
          isCanSelectGoods = true;
        } else {
          isCanSelectGoods = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getBrands() {
    ApiShop.getBrands((data) {
      if (data != null) {
        setState(() {
          List newlist = [];
          brandsList = data;
          chipList = data;
          for (BrandList item in brandsList) {
            newlist.add(item.name);
          }
          titleList = List<String>.from(newlist);
        });
      }
    }, (message) => EasyLoading.showError(message));
  }

  getCategory() {
    ApiShop.getCategory((data) {
      if (data != null) {
        setState(() {
          classificationList = data;
          for (var item in classificationList) {
            final GlobalKey<_ChoiceChipViewCategriesState> childKey3 =
                GlobalKey<_ChoiceChipViewCategriesState>();
            globalKey.add(childKey3);
          }
        });
      }
    }, (message) => EasyLoading.showError(message));
  }

  loadList() {
    setState(() {
      isPerformingRequest = false;
    });
    pageIndex = 0;
    loadMoreList('refresh');
  }

  loadMoreList(String type) async {
    if (!isPerformingRequest) {
      EasyLoading.show(status: '加载中');
      setState(() => isPerformingRequest = true);
      Map<String, dynamic> params = {
        "page": (++pageIndex),
        "is_up_shelf": 2,
        "sortby": sortby,
        "keyword": keyword,
        "brand_id": selectedBrandList.join(','),
        "category_id": selectedCategoryList.join(','),
        "has_stock": selectedStock,
        "only_collection": this.arguments["type"] == 1 ? "1" : "",
      };

      var data = await ApiShop.getProductsList(params);
      setState(() {
        if (data != null) {
          if (type == 'refresh') {
            dataList = data['list'];
          } else if (type == 'more') {
            dataList.addAll(data['list']);
          }
        }
        if (data['list'].length == 0) {
          isPerformingRequest = true;
        } else {
          isPerformingRequest = false;
        }
      });
      EasyLoading.dismiss();
    }
  }

  void createSimpleDialog() {
    ApplicationEvent.event.fire(new UpOrOffGoodsShelf());
    if (isCanSelectGoods) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            titlePadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            title: Column(
              children: <Widget>[
                Container(
                  transform: Matrix4.translationValues(0, -35, 0),
                  child: Image.asset('assets/images/shop/success@3x.png',
                      width: 90, height: 90),
                ),
                Container(
                    margin: EdgeInsets.only(top: 20),
                    transform: Matrix4.translationValues(0, -45, 0),
                    child: Text('商品已成功上架至您的店铺！',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400))),
                Container(
                    margin: EdgeInsets.only(top: 5, bottom: 20),
                    width: 187.5,
                    height: 40,
                    child: RaisedButtonCustom(
                        onPressed: () {
                          ApplicationEvent.event
                              .fire(ListRefreshEvent('refresh'));
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/main', (route) => false);
                          Routers.push('/goodsPage', context);
                        },
                        textStyle: TextStyle(color: Colors.white),
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(
                                color: AppColor.themeRed,
                                width: 1.0,
                                style: BorderStyle.solid),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        textColor: Colors.white,
                        color: AppColor.themeRed,
                        txt: '上架成功',
                        padding: EdgeInsets.only(left: 0, right: 0)))
              ],
            ),
          );
        },
      );
    } else {
      ApplicationEvent.event.fire(new UpOrOffGoodsShelf());
      Util.showToast('上架成功');
      loadList();
    }
  }

  void UpSingleGoods(ProductsItem item) {
    upShelfSelectedList.add(item.id);
    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: GoodsProfitDialog(
                      createSimpleDialog: createSimpleDialog,
                      upShelfSelectedList: upShelfSelectedList,
                      canSelectMore: isCanSelectGoods)));
        });
  }

  void showModal(BuildContext context) {
    if (upShelfSelectedList.isEmpty) {
      Util.showToast('请选择商品');
      return;
    }
    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: GoodsProfitDialog(
                      createSimpleDialog: createSimpleDialog,
                      upShelfSelectedList: upShelfSelectedList,
                      canSelectMore: isCanSelectGoods)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return InnerDrawer(
      key: _scaffoldKey,
      onTapClose: true, // default false
      swipe: false, // default true
      colorTransitionChild: Colors.white, // default Color.black54
      colorTransitionScaffold: Colors.black54, // default Color.black54
      offset: IDOffset.only(top: 0.0, bottom: 0.0, right: 0.6, left: 0.0),
      scale: IDOffset.horizontal(1.0),
      proportionalChildArea: true,
      leftAnimationType: InnerDrawerAnimation.static, // default static
      rightAnimationType: InnerDrawerAnimation.static,
      backgroundDecoration: BoxDecoration(
          color: Colors.white), // default  Theme.of(context).backgroundColor
      onDragUpdate: (double val, InnerDrawerDirection direction) {},
      innerDrawerCallback: (a) =>
          print(a), // return  true (open) or false (close)
      rightChild: buildRightVc(context), // required if leftChild is not set
      scaffold: buildBody(context),
    );
  }

  Widget buildRightVc(context) {
    Widget rightScrollView = Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text("筛选"),
          leading: Text(''),
        ),
        bottomNavigationBar: Material(
          child: Container(
            height: 49,
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 10,
                    child: TextButton(
                        onPressed: () {
                          _close('rest');
                        },
                        child: Text("重置", style: TextStyle(fontSize: 15)))),
                Expanded(
                  flex: 10,
                  child: Container(
                      color: AppColor.themeRed,
                      child: TextButton(
                          onPressed: () {
                            _close('load');
                          },
                          child: Text("确定", style: TextStyle(fontSize: 15)))),
                ),
              ],
            ),
          ),
        ),
        body: Material(
          child: SafeArea(
              top: true,
              bottom: true,
              child: SingleChildScrollView(
                child: getListView(),
              )),
        ));
    return rightScrollView;
  }

  ListView getListView() => new ListView.builder(
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      itemCount:
          (classificationList == null) ? 0 : classificationList.length + 2,
      itemBuilder: (BuildContext context, int position) {
        return _rightBtnView(position);
      });

  _rightBtnView(int index) {
    var newContainer;
    if (index == 0) {
      newContainer = Container(
        child: buildFirstCell(),
      );
    }
    if (index == 1) {
      newContainer = Container(
        child: buildBrandCell(),
      );
    }
    if (index != 0 && index != 1) {
      newContainer = Container(
        child: buildCategriesCell(index),
      );
    }
    return newContainer;
  }

  Widget buildBrandCell() {
    var newContainer = Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text("品牌",
                    style: TextStyle(
                        color: AppColor.mainTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          Row(children: <Widget>[
            Expanded(
                child: ChoiceChipViewBrands(
              key: childKey2,
              isSingle: false,
              shapeNo: 1,
              list: brandsList,
              isHightLight: true,
              onClick: (context) {
                if (selectedBrandList.contains(context.id)) {
                  selectedBrandList.remove(context.id);
                } else {
                  selectedBrandList.add(context.id);
                }
              },
            ))
          ])
        ],
      ),
    );
    return newContainer;
  }

  Widget buildCategriesCell(int index) {
    var newContainer = Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(classificationList[index - 2].name,
                    style: TextStyle(
                        color: AppColor.mainTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          Row(children: <Widget>[
            Expanded(
                child: ChoiceChipViewCategries(
              key: globalKey[index - 2],
              isSingle: false,
              shapeNo: 1,
              list: classificationList[index - 2].categories,
              isHightLight: true,
              onClick: (context) {
                if (selectedCategoryList.contains(context.id)) {
                  selectedCategoryList.remove(context.id);
                } else {
                  selectedCategoryList.add(context.id);
                }
              },
            )),
          ])
        ],
      ),
    );
    return newContainer;
  }

  Widget buildFirstCell() {
    var newContainer = Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text("库存",
                    style: TextStyle(
                        color: AppColor.mainTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: ChoiceChipView(
                key: childKey1,
                isSingle: true,
                shapeNo: 1,
                list: ["有库存", "无库存"],
                isHightLight: true,
                onClick: (context) {
                  selectedStock = context == '有库存' ? 1 : 2;
                },
              )),
            ],
          )
        ],
      ),
    );
    return newContainer;
  }

  void _open() {
    _scaffoldKey.currentState.open();
  }

  void _close(type) {
    if (type == 'rest') {
      childKey1.currentState.resetSelected();
      childKey2.currentState.resetSelected();
      for (GlobalKey<_ChoiceChipViewCategriesState> item in globalKey) {
        item.currentState.resetSelected();
      }
      setState(() {
        selectList = [];
        selectedBrandList = [];
        selectedCategoryList = [];
        selectedStock = '';
      });
    } else {
      _scaffoldKey.currentState.close();
      loadList();
    }
  }

  Widget buildBody(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: MyAppBar(
          isBack: isShowBackBtn ? true : false,
          centerTitle: isCanSelectGoods ? '批量上架' : "选货",
          actionIcon: Icon(Icons.search),
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    fullscreenDialog: false,
                    builder: (context) => BatchSearchPage())).then((res) {
              if (res['type'] == 'back') return;
              setState(() {
                keyword = res['value'];
              });
              loadList();
            });
          },
        ),
        bottomNavigationBar: Material(
          //底部栏整体的颜色
          child: isCanSelectGoods
              ? Row(
                  children: <Widget>[
                    Expanded(
                        child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      child: new Padding(
                        padding: new EdgeInsets.all(12),
                        child: Text("取消",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            )),
                      ),
                      color: Color(0xffCBCBCB),
                      onPressed: () async {
                        if (pushBy == 3) {
                          setState(() {
                            isCanSelectGoods = false;
                          });
                        } else {
                          Routers.pop(context);
                        }
                      },
                    )),
                    Expanded(
                        child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      child: new Padding(
                        padding: new EdgeInsets.all(12),
                        child: Text("确定上架",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            )),
                      ),
                      color: Color(0xffe4382d),
                      onPressed: () async {
                        showModal(context);
                      },
                    )),
                  ],
                )
              : Row(
                  children: <Widget>[
                    Expanded(
                        child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      child: new Padding(
                        padding: new EdgeInsets.all(12),
                        child: Text("批量上架",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            )),
                      ),
                      color: Color(0xffe4382d),
                      onPressed: () async {
                        setState(() {
                          isCanSelectGoods = true;
                        });
                      },
                    )),
                  ],
                ),
        ),
        body: new NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification &&
                  notification.depth == 0 &&
                  !isPerformingRequest) {
                if (notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent) {
                  loadMoreList('more');
                }
              }
              return false;
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  floating: true,
                  backgroundColor: Colors.white,
                  flexibleSpace: Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            sortby = 1;
                          });
                          loadList();
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              '销量',
                              style: TextStyle(
                                  color: sortby == 1
                                      ? Color(0xffe4382d)
                                      : Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (sortby == 3) {
                              sortby = 4;
                            } else {
                              sortby = 3;
                            }
                          });
                          loadList();
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              '价格',
                              style: TextStyle(
                                  color: sortby == 3 || sortby == 4
                                      ? Color(0xffe4382d)
                                      : Colors.grey),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Transform.scale(
                                    origin: Offset(-3, -1),
                                    scale: 2.3,
                                    child: Icon(
                                      Icons.arrow_drop_up,
                                      color: sortby == 3
                                          ? iconSelectedColor
                                          : iconColor,
                                      size: 12,
                                    )),
                                Transform.scale(
                                    origin: Offset(-3, 1),
                                    scale: 2.3,
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: sortby == 4
                                          ? iconSelectedColor
                                          : iconColor,
                                      size: 12,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            sortby = 2;
                          });
                          loadList();
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              '新品',
                              style: TextStyle(
                                  color: sortby == 2
                                      ? Color(0xffe4382d)
                                      : Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: 20,
                          child: VerticalDivider(color: Color(0xff1D1817))),
                      GestureDetector(
                        onTap: () {
                          _open();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text('筛选'),
                            Image.asset('assets/images/shop/filter.png',
                                width: 19, height: 19)
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
                SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return BatchPutOnShelfItem(
                        item: dataList[index],
                        upShelfSelectedList: upShelfSelectedList,
                        type: isCanSelectGoods,
                        index: index,
                        onClick: (context) {
                          UpSingleGoods(context);
                        },
                      );
                    }, childCount: dataList.length)),
                SliverToBoxAdapter(
                  child: new Visibility(
                    child: new Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: new Center(
                        child: new Text(
                          '没有更多数据了!',
                          style: AppText.textGray12,
                        ),
                      ),
                    ),
                    visible: isPerformingRequest,
                  ),
                ),
              ],
            )));
  }
}

class GoodsProfitDialog extends StatefulWidget {
  GoodsProfitDialog(
      {Key key,
      this.createSimpleDialog,
      this.items,
      this.upShelfSelectedList,
      this.canSelectMore})
      : super(key: key);
  final List<DropdownMenuItem> items;
  final Function createSimpleDialog;
  final List upShelfSelectedList;
  final bool canSelectMore;

  @override
  _GoodsProfitDialogState createState() => new _GoodsProfitDialogState();
}

class _GoodsProfitDialogState extends State<GoodsProfitDialog> {
  num goodsProfitValue = 1;

  final Border goodsProfitSelected = Border.all(
    color: AppColor.themeRed,
    width: 1,
    style: BorderStyle.solid,
  );

  final Border goodsProfitUnSelected = Border.all(
    color: Color(0xffCCCCCC),
    width: 0.5,
    style: BorderStyle.solid,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textValueController.dispose();
    super.dispose();
  }

  dynamic countryId;
  TextEditingController _textValueController = new TextEditingController();
  final FocusNode _nodeValue = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 330,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                height: 44,
                color: Color(0xffe4382d),
                child: Text('请先设置商品利润', style: TextStyle(fontSize: 18))),
            Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        color: Color(0xffF8F8F8),
                        width: 123,
                        height: 33,
                        child: RaisedButtonCustom(
                            onPressed: () {
                              setState(() {
                                goodsProfitValue = 1;
                              });
                            },
                            shape: goodsProfitValue == 1
                                ? goodsProfitSelected
                                : goodsProfitUnSelected,
                            textColor: AppColor.themeRed,
                            color: Colors.white,
                            txt: '按照利润比例',
                            padding: EdgeInsets.all(0))),
                    Container(
                        color: Color(0xffF8F8F8),
                        width: 123,
                        height: 33,
                        child: RaisedButtonCustom(
                            onPressed: () {
                              setState(() {
                                goodsProfitValue = 2;
                              });
                            },
                            shape: goodsProfitValue == 2
                                ? goodsProfitSelected
                                : goodsProfitUnSelected,
                            textColor: AppColor.themeRed,
                            color: Colors.white,
                            txt: '按照利润净值',
                            padding: EdgeInsets.all(0))),
                  ],
                )),
            Container(
                width: 246,
                height: 44,
                child: TextField(
                    autofocus: true,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                        suffix: Container(
                            child: Text(
                          '${goodsProfitValue == 1 ? '%' : ''}',
                        )),
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide:
                              BorderSide(color: AppColor.themeRed, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide:
                              BorderSide(color: Color(0xffDCDCDC), width: 1.0),
                        ),
                        hintText: "请输入利润",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 16.0),
                        contentPadding: EdgeInsets.all(10.0),
                        disabledBorder: null),
                    controller: _textValueController)),
            Container(
              width: 246,
              alignment: Alignment.center,
              child: Text('若售卖价低于最低售价，将取最低售价',
                  style: TextStyle(color: Color(0xff999999), fontSize: 12)),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  child: new Padding(
                    padding: new EdgeInsets.all(12),
                    child: Text("取消",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        )),
                  ),
                  color: Color(0xffCBCBCB),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                )),
                Expanded(
                    child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  child: new Padding(
                    padding: new EdgeInsets.all(12),
                    child: Text("确定",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        )),
                  ),
                  color: Color(0xffe4382d),
                  onPressed: () async {
                    EasyLoading.show(status: "上架商品...");
                    Navigator.of(context).pop();
                    ApiShop.setProductsBatchUpShelf({
                      'product_ids': widget.upShelfSelectedList,
                      'type': goodsProfitValue,
                      'value': _textValueController.text
                    }, (data) {
                      EasyLoading.dismiss();
                      if (data.ret == 1) {
                        widget.createSimpleDialog();
                      }
                    }, (message) => EasyLoading.dismiss());
                  },
                )),
              ],
            )
          ],
        ));
  }
}

class ChoiceChipViewBrands extends StatefulWidget {
  ChoiceChipViewBrands({
    Key key,
    this.list,
    this.selectlist,
    this.isSingle,
    this.shapeNo,
    this.width,
    this.onClick,
    this.isHightLight,
  }) : super(key: key);

  final List<BrandList> list;

  final List<BrandList> selectlist;

  final bool isHightLight;

  final bool isSingle;

  final double shapeNo;

  final double width;

  // 点击键盘搜索回调 可选
  final ValueChanged<BrandList> onClick;

  State<StatefulWidget> createState() => _ChoiceChipViewBrandsState();
}

class _ChoiceChipViewBrandsState extends State<ChoiceChipViewBrands> {
  GlobalKey childKey = GlobalKey();

  BrandList _selected;

  List<BrandList> _selectedList = [];

  resetSelected() {
    setState(() {
      _selected = null;
      _selectedList = [];
    });
  }

  actorWidgets() {
    List<Widget> widgets = [];
    for (BrandList choiceSub in widget.list) {
      var container = Container(
        child: ChoiceChip(
          backgroundColor: Colors.white,
          disabledColor: Colors.blue,
          labelStyle: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 15.0,
              color: AppColor.mainTextColor),
          labelPadding: EdgeInsets.only(left: 2.0, right: 2.0),
          materialTapTargetSize: MaterialTapTargetSize.padded,
          label: Text(choiceSub.name),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.shapeNo),
            side: BorderSide(color: Color(0xFFE1E1E1), width: 1.0),
          ),
          onSelected: (bool value) {
            if (widget.onClick is Function) {
              widget.onClick(choiceSub);
            }
            if (widget.isHightLight) {
              setState(() {
                if (widget.isSingle) {
                  _selected = value ? choiceSub : "Colors.red";
                } else {
                  if (value) {
                    _selectedList.add(choiceSub);
                  } else {
                    _selectedList.remove(choiceSub);
                  }
                }
              });
            }
          },
          selected: widget.isSingle
              ? (_selected == choiceSub)
              : (_selectedList.contains(choiceSub)),
        ),
      );
      widgets.add(container);
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              textDirection: TextDirection.ltr,
              spacing: 5,
              runSpacing: 0,
              children: actorWidgets(),
            ),
          ],
        ));
  }
}

class ChoiceChipView extends StatefulWidget {
  ChoiceChipView({
    Key key,
    this.list,
    this.selectlist,
    this.isSingle,
    this.shapeNo,
    this.width,
    this.onClick,
    this.isHightLight,
  }) : super(key: key);

  final List<String> list;

  final List<String> selectlist;

  final bool isHightLight;

  final bool isSingle;

  final double shapeNo;

  final double width;

  // 点击键盘搜索回调 可选
  final ValueChanged<String> onClick;

  State<StatefulWidget> createState() => _ChoiceChipViewState();
}

class _ChoiceChipViewState extends State<ChoiceChipView> {
  GlobalKey childKey = GlobalKey();

  String _selected = "";

  List<String> _selectedList = [];

  resetSelected() {
    setState(() {
      _selected = "";
      _selectedList = [];
    });
  }

  actorWidgets() {
    List<Widget> widgets = [];
    for (String choiceSub in widget.list) {
      var container = Container(
        child: ChoiceChip(
          backgroundColor: Colors.white,
          disabledColor: Colors.blue,
          labelStyle: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 15.0,
              color: AppColor.mainTextColor),
          labelPadding: EdgeInsets.only(left: 2.0, right: 2.0),
          materialTapTargetSize: MaterialTapTargetSize.padded,
          label: Text(choiceSub),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.shapeNo),
            side: BorderSide(color: Color(0xFFE1E1E1), width: 1.0),
          ),
          onSelected: (bool value) {
            if (widget.onClick is Function) {
              widget.onClick(choiceSub);
            }
            if (widget.isHightLight) {
              setState(() {
                if (widget.isSingle) {
                  _selected = value ? choiceSub : "Colors.red";
                } else {
                  if (value) {
                    _selectedList.add(choiceSub);
                  } else {
                    _selectedList.remove(choiceSub);
                  }
                }
              });
            }
          },
          selected: widget.isSingle
              ? (_selected == choiceSub)
              : (_selectedList.contains(choiceSub)),
        ),
      );
      widgets.add(container);
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              textDirection: TextDirection.ltr,
              spacing: 5,
              runSpacing: 0,
              children: actorWidgets(),
            ),
          ],
        ));
  }
}

class ChoiceChipViewCategries extends StatefulWidget {
  ChoiceChipViewCategries({
    Key key,
    this.list,
    this.selectlist,
    this.isSingle,
    this.shapeNo,
    this.width,
    this.onClick,
    this.isHightLight,
  }) : super(key: key);

  final List<Categories> list;

  final List<Categories> selectlist;

  final bool isHightLight;

  final bool isSingle;

  final double shapeNo;

  final double width;

  // 点击键盘搜索回调 可选
  final ValueChanged<Categories> onClick;

  State<StatefulWidget> createState() => _ChoiceChipViewCategriesState();
}

class _ChoiceChipViewCategriesState extends State<ChoiceChipViewCategries> {
  GlobalKey childKey = GlobalKey();

  CategoryList _selected;

  List<Categories> _selectedList = [];

  resetSelected() {
    setState(() {
      _selected = null;
      _selectedList = [];
    });
  }

  actorWidgets() {
    List<Widget> widgets = [];
    for (Categories choiceSub in widget.list) {
      var container = Container(
        child: ChoiceChip(
          backgroundColor: Colors.white,
          disabledColor: Colors.blue,
          labelStyle: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 15.0,
              color: AppColor.mainTextColor),
          labelPadding: EdgeInsets.only(left: 2.0, right: 2.0),
          materialTapTargetSize: MaterialTapTargetSize.padded,
          label: Text(choiceSub.name),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.shapeNo),
            side: BorderSide(color: Color(0xFFE1E1E1), width: 1.0),
          ),
          onSelected: (bool value) {
            if (widget.onClick is Function) {
              widget.onClick(choiceSub);
            }
            if (widget.isHightLight) {
              setState(() {
                if (widget.isSingle) {
                  _selected = value ? choiceSub : "Colors.red";
                } else {
                  if (value) {
                    _selectedList.add(choiceSub);
                  } else {
                    _selectedList.remove(choiceSub);
                  }
                }
              });
            }
          },
          selected: widget.isSingle
              ? (_selected == choiceSub)
              : (_selectedList.contains(choiceSub)),
        ),
      );
      widgets.add(container);
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              textDirection: TextDirection.ltr,
              spacing: 5,
              runSpacing: 0,
              children: actorWidgets(),
            ),
          ],
        ));
  }
}

class BatchSearchPage extends StatefulWidget {
  BatchSearchPage({this.arguments});

  final Map arguments;

  @override
  _BatchSearchPageState createState() => new _BatchSearchPageState();
}

class _BatchSearchPageState extends State<BatchSearchPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isLoading = false;
  String keyword = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
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
        appBar: BatchSearchBar(
          placeholder: '请输入商品名',
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, {'type': 'back'});
              }),
          onSearch: (value) {
            setState(() {
              keyword = value;
            });
            Navigator.pop(context, {'type': 'keyword', 'value': keyword});
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[],
          ),
        ));
  }
}

class BatchSearchBar extends StatefulWidget implements PreferredSizeWidget {
  BatchSearchBar(
      {Key key,
      this.leading,
      this.title,
      this.onCancel,
      this.onSearch,
      this.placeholder})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  // 头部组件 可选
  final Widget leading;

  // 标题 可选
  final String title;

  // 点击取消回调 可选
  final VoidCallback onCancel;

  // 点击键盘搜索回调 可选
  final ValueChanged<String> onSearch;

  final String placeholder;

  @override
  _BatchSearchBarState createState() => _BatchSearchBarState();
}

class _BatchSearchBarState extends State<BatchSearchBar> {
  TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String _title = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  // 搜索面板 默认返回标题
  Widget _searchPanel() {
    return Container(
      width: ScreenUtil().screenWidth * 4 / 4,
      height: kToolbarHeight - 20,
      child: TextField(
        cursorColor: AppColor.themeRed,
        focusNode: _focusNode,
        controller: _controller,
        autofocus: true,
        style: TextStyle(fontSize: 15),
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          setState(() {
            _title = value;
          });
        },
        decoration: InputDecoration(
          filled: true,
          hintText: widget.placeholder != null
              ? widget.placeholder
              : S.of(context).homeSearchHint,
          hintStyle: AppText.textGray14,
          fillColor: AppColor.bgGray,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  // 搜索/取消按钮
  Widget _action() {
    return Container(
      color: Colors.white,
      width: 50,
      margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
      child: RawMaterialButton(
        padding: EdgeInsets.all(0),
        child: Text(S.of(context).search),
        onPressed: () {
          widget.onSearch(_title);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      elevation: 3,
      centerTitle: false,
      backgroundColor: Colors.white,
      leading: widget.leading,
      title: _searchPanel(),
      actions: <Widget>[_action()],
    );
  }
}
