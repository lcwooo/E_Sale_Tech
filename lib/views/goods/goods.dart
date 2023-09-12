import 'package:E_Sale_Tech/api/goods.dart';
import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/components/input/base_input.dart';
import 'package:E_Sale_Tech/components/load_image.dart';
import 'package:E_Sale_Tech/components/round_checkbox.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/model/goods/goodsDetailInfo.dart';
import 'package:E_Sale_Tech/model/goods/myGoodsInformation.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/views/goods/goods_index_provider.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:E_Sale_Tech/components/list_refresh.dart' as listComp;

class GoodsPage extends StatefulWidget {
  GoodsPage({this.arguments});
  final Map arguments;
  @override
  _GoodsPageState createState() => new _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool isEditing = false;
  bool isLoading = false;
  bool selectAll = false;
  bool upOrOffList = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _nodeKeyword = FocusNode();

  GoodsIndexProvider provider = GoodsIndexProvider();
  TabController _tabController;
  PageController _pageController = PageController(initialPage: 0);
  TextEditingController _textKeywordController = new TextEditingController();
  GlobalKey _bodyKey = GlobalKey();

  int pageIndex = 0;
  List<MyGoodsInformation> goodsList = [];
  Map<dynamic, dynamic> params;

  String keyword = '';
  final statusArr = [
    {'status': 1},
    {'status': 2},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    // ApplicationEvent.event.on<UpOrOffGoodsShelf>().listen((event) {
    //   setState(() {
    //     upOrOffList = true;
    //   });
    // });
  }

  // 搜索框
  Widget buildSearch(BuildContext context) {
    Widget widget = Container(
      height: 35,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F9),
      ),
      child: BaseInput(
        isSearchInput: true,
        maxLength: 50,
        prefixIcon: Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(vertical: 11.0),
        hintText: "搜索商品或品牌",
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
          if (ApplicationEvent.event != null) {
            setState(() {
              keyword = res;
            });
            ApplicationEvent.event.fire(ListRefreshEvent('refresh'));
          }
        },
      ),
    );
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<GoodsIndexProvider>(
        create: (_) => provider,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            appBar: MyAppBar(
              backgroundColor: Colors.white,
              centerTitle: "商品管理",
              isBack: true,
              actionName: isEditing ? '取消' : '管理',
              onPressed: () {
                setState(() {
                  if (isEditing) {
                    isEditing = false;
                  } else {
                    isEditing = true;
                  }
                });
              },
            ),
            bottomNavigationBar: isEditing
                ? Material(
                    color: Colors.white,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: FlatButton.icon(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () async {
                                    setState(() {
                                      selectAll = !selectAll;
                                      for (MyGoodsInformation item
                                          in goodsList) {
                                        item.select = selectAll;
                                      }
                                    });
                                  },
                                  icon: selectAll
                                      ? Icon(
                                          Icons.check_circle,
                                          size: 25.0,
                                          color: AppColor.themeRed,
                                        )
                                      : Icon(
                                          Icons.panorama_fish_eye,
                                          size: 25.0,
                                          color: Colors.grey,
                                        ),
                                  label: Expanded(
                                      child: Text(
                                    S.of(context).SelectAll,
                                    style: TextStyle(fontSize: 13),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )))),
                          Expanded(
                              flex: 1,
                              child: FlatButton.icon(
                                  onPressed: () async {
                                    // 删除多条数据
                                    bool selectGoods = false;
                                    for (MyGoodsInformation item in goodsList) {
                                      if (item.select) {
                                        selectGoods = true;
                                        // 有选中的商品
                                      }
                                    }
                                    if (selectGoods == false) {
                                      Util.showToast('请选择删除的商品');
                                      return;
                                    }
                                    deleteMoreGoods();
                                  },
                                  icon: Image(
                                    image: AssetImage(
                                      "assets/images/goods/delete@3x.png",
                                    ),
                                    width: 20.0,
                                    height: 20.0,
                                  ),
                                  label: Expanded(
                                      child: Text(
                                    S.of(context).delete,
                                    style: TextStyle(fontSize: 13),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )))),
                          Expanded(
                              flex: 1,
                              child: FlatButton.icon(
                                  onPressed: () async {
                                    bool selectGoods = false;
                                    for (MyGoodsInformation item in goodsList) {
                                      if (item.select) {
                                        selectGoods = true;
                                        // 有选中的商品
                                      }
                                    }
                                    if (selectGoods == false) {
                                      Util.showToast('请选择下架的商品');
                                      return;
                                    }
                                    offMoreGoods();
                                  },
                                  icon: Image(
                                    image: AssetImage(
                                      "assets/images/goods/OffShelves@2x.png",
                                    ),
                                    width: 20.0,
                                    height: 20.0,
                                  ),
                                  label: Expanded(
                                      child: Text(
                                    S.of(context).downShelves,
                                    style: TextStyle(fontSize: 13),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )))),
                        ],
                      ),
                    ))
                : Material(
                    //底部栏整体的颜色
                    color: AppColor.themeRed,
                    child: FlatButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: new Padding(
                        padding: new EdgeInsets.all(10),
                        child: Text("我要选货",
                            style: TextStyle(
                                color: AppColor.white,
                                fontWeight: FontWeight.w300)),
                      ),
                      color: AppColor.themeRed,
                      onPressed: () async {
                        Routers.push("/shop/collection/batchPutOnShelf",
                            context, {"type": 2, "showBackBtn": true});
                      },
                    ),
                  ),
            body: Column(
              key: _bodyKey,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: buildSearch(context),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(color: Color(0xFFF2F2F7), width: 1))),
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
                      const _TabView("销售中", "", 0),
                      const _TabView("已售罄", "", 1),
                    ],
                  ),
                ),
                Container(
                  child: Expanded(
                    child: PageView.builder(
                      key: const Key('pageView'),
                      itemCount: 2,
                      onPageChanged: _onPageChange,
                      controller: _pageController,
                      itemBuilder: (BuildContext context, int index) {
                        return GoodsManagerList(
                          params: {
                            'status': statusArr[index]['status'],
                            'keyword': keyword,
                            'isEdit': isEditing,
                            'isSelectAll': selectAll,
                          },
                          postList: (context) {
                            context.forEach((element) {
                              goodsList.add(element);
                            });
                          },
                          upOrOffloadList: upOrOffList,
                        );
                      },
                    ),
                  ),
                ),
              ],
            )));
  }

  // 多个商品下架
  void offMoreGoods() async {
    String offGoodsId = "";
    for (MyGoodsInformation item in goodsList) {
      if (item.select) {
        if (offGoodsId.isEmpty) {
          offGoodsId = item.id.toString();
        } else {
          offGoodsId = offGoodsId + "," + item.id.toString();
        }
      }
    }
    await ApiGoods.batchOffShelf(offGoodsId, (data) {
      if (data.ret == 1) {
        setState(() {
          setState(() {
            // isEditing = false;
            ApplicationEvent.event.fire(ListRefreshEvent('reset'));
          });
          Util.showToast('下架成功');
        });
      }
    }, (message) => null);
  }

  // 多个数据删除
  void deleteMoreGoods() async {
    List<MyGoodsInformation> deleteList = [];
    for (MyGoodsInformation item in goodsList) {
      if (item.select) {
        deleteList.add(item);
      }
    }
    await ApiGoods.setProductsDelete({"list": deleteList}, (data) {
      setState(() {
        // isEditing = false;
        ApplicationEvent.event.fire(ListRefreshEvent('reset'));
      });
      print("succeed");
    }, (message) {
      print("failed");
    });
  }

  _onPageChange(int index) {
    dataReduction();
    _tabController.animateTo(index);
    provider.setIndex(index);
  }

  dataReduction() {
    setState(() {
      goodsList.clear();
      isEditing = false;
      selectAll = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    // _textKeywordController.dispose();
    super.dispose();
  }
}

class GoodsManagerList extends StatefulWidget {
  GoodsManagerList(
      {Key key, @required this.params, this.postList, this.upOrOffloadList});

  final Map<String, dynamic> params;

  final ValueChanged<List<MyGoodsInformation>> postList;

  final bool upOrOffloadList;

  @override
  _GoodsManagerListState createState() => _GoodsManagerListState();
}

class _GoodsManagerListState extends State<GoodsManagerList> {
  final GlobalKey<_GoodsManagerListState> key = GlobalKey();

  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.upOrOffloadList) {
      loadList();
    }
  }

  loadList({type}) async {
    if (type == 'reset') {
      widget.params['keyword'] = '';
    }
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> params1 = {
      "page": (++pageIndex),
      "status": widget.params['status'],
      "keyword": widget.params['keyword'],
    };
    var data = await ApiGoods.myGoodsList(params1);
    Map dic = data;
    widget.postList(dic["list"]);
    if (widget.params['isSelectAll']) {
      dic["list"].forEach((v) {
        MyGoodsInformation goods = v;
        goods.select = true;
      });
    }
    return data;
  }

  /// 每个item的样式
  Widget renderItem(index, MyGoodsInformation item) {
    return GoodsManagerItem(
      info: item,
      index: index,
      isEdit: widget.params['isEdit'],
      isSelectAll: widget.params['isSelectAll'],
    );
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

class GoodsManagerItem extends StatelessWidget {
  const GoodsManagerItem(
      {Key key, this.info, this.index, this.isEdit, this.isSelectAll})
      : super(key: key);
  final MyGoodsInformation info;
  // final List<MyGoodsInformation> selectList;
  final bool isEdit;
  final bool isSelectAll;
  final int index;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context1, setListViewState) {
      return GestureDetector(
          onTap: () {
            if (!isEdit) {
              Routers.push('/goodsDetailPage', context, {"goodsId": info.id});
            }
          },
          child: new Container(
            height: 120,
            width: ScreenUtil().screenWidth,
            child: new Row(
              children: <Widget>[
                isEdit
                    ? new Container(
                        width: 60,
                        child: RoundCheckBox(
                          value: info.select,
                          onChanged: (value) {
                            setListViewState(() {
                              // if (value) {
                              //   selectList.add(info);
                              // }else{
                              //   selectList.remove(info);
                              // }
                              info.select = value;
                            });
                          },
                        ))
                    : Container(),
                new Container(
                    width: 120,
                    height: 120,
                    padding: EdgeInsets.all(18),
                    child: LoadImage(
                      (info.majorThumb == null) ? "" : info.majorThumb,
                      fit: BoxFit.fitWidth,
                      holderImg: "goods/goodDefault@3x",
                      format: "png",
                    )
                    // new Image.asset("assets/images/goods/rosebox@3x.png")
                    ),
                new Container(
                  width: isEdit
                      ? ScreenUtil().screenWidth - 130 - 60
                      : ScreenUtil().screenWidth - 130,
                  height: 100,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new SizedBox(height: 0),
                      Expanded(
                          flex: 3,
                          child: new Row(
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  info.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'PingFang-SC-Regular',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 2,
                                ),
                              )
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: new Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "¥" + info.price?.toStringAsFixed(2),
                                  style: TextStyle(),
                                ),
                              )
                            ],
                          )),
                      Expanded(
                          flex: 2,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "库存：" + info.number.toString(),
                                style: TextStyle(
                                  color: Color(0xFF999999),
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                "销量：" + info.saleNum.toString(),
                                style: TextStyle(
                                  color: Color(0xFF999999),
                                  fontSize: 10,
                                ),
                              ),
                              !isEdit
                                  ? PopupMenuButton(
                                      onSelected: (String value) async {
                                        if (value == "Collect") {
                                          changeCollectState(
                                              info, (info.isCollect == 1));
                                        }
                                        if (value == "Delete") {
                                          deleteMyGoods(info, index);
                                        }
                                        if (value == "OffShelf") {
                                          Map<String, dynamic> goodDic;
                                          goodDic = {
                                            "product_id": info.id,
                                            "status": "2"
                                          };
                                          await ApiGoods.setProductUpOffShelf(
                                              goodDic, (data) {
                                            if (data.ret == 1) {
                                              setListViewState(() {
                                                ApplicationEvent.event.fire(
                                                    ListRefreshEvent(
                                                        'delete', index));
                                                Util.showToast('下架成功');
                                              });
                                            }
                                          }, (message) => null);
                                        }
                                        if (value == "Edit") {
                                          Routers.push('/editGoodsPricePage',
                                              context, {"goodsId": info.id});
                                        }
                                        if (value == "Promote") {
                                          Routers.push("/promote/PromotePage",
                                              context, {"goodsId": info.id});
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        new PopupMenuItem<String>(
                                            height: 30,
                                            value: 'Delete',
                                            child: new Row(
                                              children: <Widget>[
                                                Icon(Icons.delete_outline,
                                                    color: Color(0xFFFF7070)),
                                                new Text(
                                                  '删除',
                                                  style: new TextStyle(
                                                      color: Color(0xFFFF7070),
                                                      fontSize: 12),
                                                )
                                              ],
                                            )),
                                        new PopupMenuDivider(height: 1.0),
                                        new PopupMenuItem<String>(
                                            height: 30,
                                            value: 'OffShelf',
                                            child: new Row(
                                              children: <Widget>[
                                                Icon(Icons.arrow_downward),
                                                new Text('下架',
                                                    style:
                                                        TextStyle(fontSize: 12))
                                              ],
                                            )),
                                        new PopupMenuDivider(height: 1.0),
                                        new PopupMenuItem<String>(
                                            height: 30,
                                            value: 'Edit',
                                            child: new Row(
                                              children: <Widget>[
                                                Icon(Icons.mode_edit),
                                                new Text('编辑',
                                                    style:
                                                        TextStyle(fontSize: 12))
                                              ],
                                            )),
                                        new PopupMenuDivider(height: 1.0),
                                        new PopupMenuItem<String>(
                                            height: 30,
                                            value: 'Promote',
                                            child: new Row(
                                              children: <Widget>[
                                                Icon(Icons.launch),
                                                new Text('推广',
                                                    style:
                                                        TextStyle(fontSize: 12))
                                              ],
                                            )),
                                        new PopupMenuDivider(height: 1.0),
                                        new PopupMenuItem<String>(
                                            height: 30,
                                            value: 'Collect',
                                            child: new Row(
                                              children: <Widget>[
                                                (info.isCollect == 1)
                                                    ? Image.asset(
                                                        "assets/images/goods/已收藏@3x.png",
                                                        width: 23,
                                                        height: 23,
                                                      )
                                                    : Image.asset(
                                                        "assets/images/goods/未收藏@3x.png",
                                                        width: 23,
                                                        height: 23,
                                                      ),
                                                new Text('收藏',
                                                    style:
                                                        TextStyle(fontSize: 12))
                                              ],
                                            ))
                                      ],
                                    )
                                  : Container(),
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ));
    });
  }
}

void deleteMyGoods(MyGoodsInformation info, int index) async {
  await ApiGoods.setProductsDelete({
    "list": [info]
  }, (data) {
    ApplicationEvent.event.fire(ListRefreshEvent('delete', index));
  }, (message) {});
}

void changeCollectState(MyGoodsInformation info, bool isLiked) async {
  String url = "";
  if (isLiked) {
    url = ApiShop.PRODUCTS_COLLECTIONS + '/${info.id}/collect-cancel';
  } else {
    url = ApiShop.PRODUCTS_COLLECTIONS + '/${info.id}/collect';
  }
  await ApiGoods.setProductsFavorite(url, (data) {
    if (isLiked) {
      info.isCollect = 0;
    } else {
      info.isCollect = 1;
    }
  }, (message) {});
}

class _TabView extends StatelessWidget {
  const _TabView(this.tabName, this.tabSub, this.index);

  final String tabName;
  final String tabSub;
  final int index;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final num finalTabWidth = ScreenUtil().screenWidth / 2;
    return Consumer<GoodsIndexProvider>(
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
