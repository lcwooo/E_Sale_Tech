import 'package:E_Sale_Tech/components/round_checkbox.dart';
import 'package:E_Sale_Tech/model/shop/brand_info.dart';
import 'package:E_Sale_Tech/model/shop/category_info.dart';
import 'package:E_Sale_Tech/model/shop/products_info.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

class SetCouponSelectGoods extends StatefulWidget {
  final Map arguments;
  SetCouponSelectGoods({this.arguments});
  @override
  _SetCouponSelectGoodsState createState() => _SetCouponSelectGoodsState();
}

class _SetCouponSelectGoodsState extends State<SetCouponSelectGoods> {
  Map arg = {'type': '', 'id': ''};

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
  List<String> selectList = [];
  List<int> selectedBrandList = [];
  List<int> selectedCategoryList = [];
  List<CategoryList> classificationList = []; // 分类数据
  List<BrandList> brandsList = []; // 品牌数据
  List upShelfSelectedList = [];
  List selectedSearchData = []; //选择的搜索数据
  dynamic selectedStock = '';
  List chipList = []; // 标签列表
  List<GlobalKey<_ChoiceChipViewCategriesState>> globalKey = []; // Glo
  int selectCategories = 0; //左侧分类按钮选择
  int pageIndex = 0;
  bool isPerformingRequest = false;
  List<String> titleList = [];

  final Color iconColor = Color(0xffCBCBCB);
  final Color iconSelectedColor = Color(0xffe4382d);
  final GlobalKey<InnerDrawerState> _scaffoldKey =
      GlobalKey<InnerDrawerState>();

  @override
  void initState() {
    super.initState();
    getBrands();
    getCategory();
    if (widget.arguments != null) {
      setState(() {
        arg = widget.arguments;
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadList();
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
        "is_up_shelf": 1,
        "sortby": sortby,
        "keyword": keyword,
        "brand_id": selectedBrandList.join(','),
        "category_id": selectedCategoryList.join(','),
        "has_stock": selectedStock
      };
      var data;
      if (arg['type'] == 'view') {
        data = await ApiShop.getCouponGoodsDetail(arg['id']);
      } else {
        data = await ApiShop.getProductsList(params);
      }
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

  selectedAll() {
    setState(() {
      dataList.forEach((element) {
        element.checked = true;
        if (!upShelfSelectedList.contains(element.id)) {
          upShelfSelectedList.add(element.id);
        }
      });
    });
  }

  void showModal(BuildContext context) {
    if (upShelfSelectedList.isEmpty) {
      Util.showToast('请选择商品');
      return;
    }
    Routers.pop(context, {'goods_id': upShelfSelectedList});
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
                    child: FlatButton(
                        onPressed: () {
                          _close('rest');
                        },
                        child: Text("重置", style: TextStyle(fontSize: 15)))),
                Expanded(
                  flex: 10,
                  child: Container(
                      color: AppColor.themeRed,
                      child: FlatButton(
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
                print(context);
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
          centerTitle: '指定商品可用',
          actionIcon: Icon(
            Icons.search,
            color: arg['type'] == 'view' ? Colors.white : Colors.black,
          ),
          onPressed: () {
            if (arg['type'] == 'view') return;
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
        bottomNavigationBar: arg['type'] == 'view'
            ? SizedBox(height: 0)
            : Material(
                //底部栏整体的颜色
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      child: new Padding(
                        padding: new EdgeInsets.all(12),
                        child: Text("全选",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            )),
                      ),
                      color: Color(0xffCBCBCB),
                      onPressed: () async {
                        selectedAll();
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
                        showModal(context);
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
                  if (arg['type'] == 'view') {
                    return false;
                  }
                  loadMoreList('more');
                }
              }
              return false;
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                arg['type'] == 'view'
                    ? SliverToBoxAdapter(child: SizedBox(height: 0))
                    : SliverAppBar(
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
                                child:
                                    VerticalDivider(color: Color(0xff1D1817))),
                            GestureDetector(
                              onTap: () {
                                _open();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                SetCouponSelectGoodsList(
                    type: arg['type'],
                    list: dataList,
                    upShelfSelectedList: upShelfSelectedList),
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

class SetCouponSelectGoodsList extends StatefulWidget {
  const SetCouponSelectGoodsList(
      {Key key,
      @required this.list,
      @required this.type,
      @required this.upShelfSelectedList})
      : super(key: key);

  final dynamic list;
  final List upShelfSelectedList;
  final String type;

  @override
  _SetCouponSelectGoodsListState createState() =>
      _SetCouponSelectGoodsListState();
}

class _SetCouponSelectGoodsListState extends State<SetCouponSelectGoodsList> {
  final GlobalKey<_SetCouponSelectGoodsListState> key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  onChange(index, id) {
    setState(() {
      widget.list[index].checked = !widget.list[index].checked;
      if (widget.upShelfSelectedList.contains(id)) {
        widget.upShelfSelectedList.remove(id);
      } else {
        widget.upShelfSelectedList.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return BatchPutOnShelfItem(
              type: widget.type,
              item: widget.list[index],
              index: index,
              onChange: onChange,
              upShelfSelectedList: widget.upShelfSelectedList);
        }, childCount: widget.list.length));
  }
}

class BatchPutOnShelfItem extends StatefulWidget {
  const BatchPutOnShelfItem(
      {Key key,
      this.item,
      this.index,
      this.type,
      this.onChange,
      this.upShelfSelectedList})
      : super(key: key);

  final ProductsItem item;
  final List upShelfSelectedList;
  final int index;
  final Function onChange;
  final String type;

  @override
  _BatchPutOnShelfItemState createState() => _BatchPutOnShelfItemState();
}

class _BatchPutOnShelfItemState extends State<BatchPutOnShelfItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (widget.type == 'view') return;
          widget.onChange(widget.index, widget.item.id);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFF2F2F7), width: 0.5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    // margin: EdgeInsets.only(bottom: 5),
                    child: CachedNetworkImage(
                      imageUrl: widget.item.majorThumb[0],
                      placeholder: (context, url) => const CircleAvatar(
                        backgroundColor: AppColor.bgGray,
                      ),
                      imageBuilder: (context, image) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: image,
                          ),
                        ),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text(
                        widget.item.name,
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff999999)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                          '￥${widget.type == 'view' ? widget?.item?.lowestPrice : widget?.item?.totalPrice}'),
                    ],
                  ),
                  widget.type == 'view'
                      ? Text('')
                      : RoundCheckBox(
                          value: widget.item.checked,
                          onChanged: (value) {
                            setState(() {
                              if (widget.type == 'view') return;
                              widget.onChange(widget.index, widget.item.id);
                            });
                          },
                        )
                ],
              )),
            ],
          ),
        ));
  }
}
