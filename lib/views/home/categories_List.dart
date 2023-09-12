import 'package:E_Sale_Tech/api/openShop.dart';
import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/components/load_image.dart';
import 'package:E_Sale_Tech/model/home/homeCategories.dart';
import 'package:E_Sale_Tech/model/shop/products_info.dart';
import 'package:E_Sale_Tech/views/shop/collection/batch_put_on_shelf.dart';
import 'package:E_Sale_Tech/views/shop/collection/batch_put_on_shelf_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:E_Sale_Tech/routers/routers.dart';

class CategoriesListPage extends StatefulWidget {
  CategoriesListPage({this.arguments});
  final Map arguments;
  @override
  _CategoriesListPageState createState() =>
      new _CategoriesListPageState(arguments: arguments);
}

class _CategoriesListPageState extends State<CategoriesListPage>
    with AutomaticKeepAliveClientMixin {
  final Map arguments;
  _CategoriesListPageState({this.arguments});
  @override
  bool get wantKeepAlive => true;

  bool isLoading = false;
  String imgUrl = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  int pageIndex = 0;
  Categories selectCategories; //选中的二级分类信息
  int sortBy = 0; // 默认0 无须排序
  final Color iconColor = Color(0xffCBCBCB);
  final Color iconSelectedColor = Color(0xffe4382d);
  List<ProductsItem> dataList = [];
  List upShelfSelectedList = [];
  HomeCategories titleName = HomeCategories();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        selectCategories = this.arguments["categories"];
        titleName = this.arguments["firstLevelCate"];
      });
      loadList();
    });
  }

  @override
  void dispose() {
    super.dispose();
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
        "is_up_shelf": 0,
        "sortby": sortBy, // 1销量降序  5销量升序 3价格升序 4价格降序
        "category_id": selectCategories.id,
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: MyAppBar(
            isBack: true,
            centerTitle: titleName.name,
            actionIcon: Icon(Icons.search),
            onPressed: () {
              Routers.push('/searchPage', context);
            }),
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
                      PopupMenuButton(
                        child: Text(
                          selectCategories.name,
                          style: TextStyle(color: AppColor.themeRed),
                        ),
                        // icon: Icon(Icons.arrow_drop_down),
                        onSelected: (value) async {
                          setState(() {
                            selectCategories =
                                titleName.categories[int.parse(value)];
                            sortBy = 0;
                          });
                          loadList();
                        },
                        itemBuilder: (BuildContext context) => creatWidget(),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (sortBy == 5) {
                              sortBy = 1;
                            } else {
                              sortBy = 5;
                            }
                          });
                          loadList();
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              '销量',
                              style: TextStyle(
                                  color: (sortBy == 1 || sortBy == 5)
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
                                      color: sortBy == 5
                                          ? iconSelectedColor
                                          : iconColor,
                                      size: 12,
                                    )),
                                Transform.scale(
                                    origin: Offset(-3, 1),
                                    scale: 2.3,
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: sortBy == 1
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
                            if (sortBy == 3) {
                              sortBy = 4;
                            } else {
                              sortBy = 3;
                            }
                          });
                          loadList();
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              '价格',
                              style: TextStyle(
                                  color: (sortBy == 3 || sortBy == 4)
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
                                      color: sortBy == 3
                                          ? iconSelectedColor
                                          : iconColor,
                                      size: 12,
                                    )),
                                Transform.scale(
                                    origin: Offset(-3, 1),
                                    scale: 2.3,
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: sortBy == 4
                                          ? iconSelectedColor
                                          : iconColor,
                                      size: 12,
                                    )),
                              ],
                            )
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
                        type: false,
                        isShowbtn: false,
                        index: index,
                        onClick: (context) {},
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

  creatWidget() {
    List<PopupMenuEntry<String>> children = [];
    for (var i = 0; i < titleName.categories.length; i++) {
      Categories model = titleName.categories[i];
      bool select = (model.id == selectCategories.id);
      var view = new PopupMenuItem<String>(
          height: 30,
          value: '$i',
          child: new Row(
            children: <Widget>[
              new Text(
                model.name,
                style: new TextStyle(
                    color: select ? AppColor.themeRed : AppColor.mainTextColor,
                    fontSize: 15),
              )
            ],
          ));
      children.add(view);
      if (i != titleName.categories.length - 1) {
        var secondView = new PopupMenuDivider(height: 1.0);
        children.add(secondView);
      }
    }
    return children;
  }
}
