import 'package:E_Sale_Tech/api/home.dart';
import 'package:E_Sale_Tech/api/user.dart';
import 'package:E_Sale_Tech/components/home_search_app_bar.dart';
import 'package:E_Sale_Tech/components/input/base_input.dart';
import 'package:E_Sale_Tech/components/load_image.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/model/Share/pictures.dart';
import 'package:E_Sale_Tech/model/home/banner.dart';
import 'package:E_Sale_Tech/model/home/homeCategories.dart';
import 'package:E_Sale_Tech/model/shop/products_info.dart';
import 'package:E_Sale_Tech/model/user/is_reviewing.dart';
import 'package:E_Sale_Tech/utils/localstorage.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/shop/order_manager/order_manager_provider.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:E_Sale_Tech/model/home/homeData.dart';
import 'package:E_Sale_Tech/components/list_refresh.dart' as listComp;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({this.arguments});
  final Map arguments;
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Map pic = new Map();

  HomeDataInfo homeData;
  bool completeInfo = false;
  bool isLoading = false;
  bool isLoadingCategories = false;
  bool isShowLoading = false;
  bool hasMoreDate = true;
  List<ProductsItem> bottomGoodsList = [];
  List topCategoriesList = [];
  List categoriesList = [];
  int totalPage = 999;
  int index = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textKeywordController = new TextEditingController();
  final FocusNode _nodeKeyword = FocusNode();
  TabController _tabController;
  OrderManagerIndexProvider provider = OrderManagerIndexProvider();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _getCategories();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gethomeData();
    });

    ApplicationEvent.event.on<HomeRefresh>().listen((event) {
      gethomeData();
    });
    //获取是否正在审核状态  lcw
    getReviewing();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (hasMoreDate) {
          _getMoreData(); // 当滑到最底部时调用
        }
      }
    });
    _getMoreData();
  }

  _getCategories() async {
    ApiHome.getCategrise((data) {
      EasyLoading.dismiss();
      List<_TabView> tableList = [];
      tableList.add(_TabView("首页", "", 0));
      for (var i = 0; i < data.length; i++) {
        HomeCategories model = data[i];
        tableList.add(_TabView(model.name, "", i + 1));
      }
      setState(() {
        categoriesList = data;
        topCategoriesList = tableList;
        _tabController =
            new TabController(vsync: this, length: topCategoriesList.length);
        isLoadingCategories = true;
      });
    }, (message) {
      EasyLoading.dismiss();
      EasyLoading.showError(message);
    });
  }

  _getMoreData() async {
    if (!isShowLoading) {
      var result = await ApiHome.getHomeProductsList({"page": index});
      setState(() {
        isShowLoading = true;
        if (index == 1) {
          bottomGoodsList.clear();
          totalPage = result['total'];
          bottomGoodsList = result['list'];
        } else {
          bottomGoodsList = bottomGoodsList + result['list'];
        }
        index++;
        isShowLoading = false;
        if (index > totalPage) {
          hasMoreDate = false;
        } else {
          hasMoreDate = true;
        }
      });
    }
  }

  getReviewing() async {
    var bean = await ApiUser.isReviewing();
    IsReviewing bindBean = bean['bean'];
    int ret = bean['ret'];
    if (ret == 1) {
      LocalStorage.saveIsReviewing(bindBean.isReviewing);
      LocalStorage.saveDefaultPhoneCode(bindBean.defaultPhoneCode);
    }
  }

  gethomeData() async {
    EasyLoading.show(status: '加载中...');
    completeInfo = await LocalStorage.getCompleteInfo();
    ApiHome.home((data) {
      EasyLoading.dismiss();
      isLoading = true;
      setState(() {
        homeData = data;
      });
    }, (message) {
      EasyLoading.dismiss();
      EasyLoading.showError(message);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(750, 1334), allowFontScaling: false);
    super.build(context);
    return ChangeNotifierProvider<OrderManagerIndexProvider>(
        create: (_) => provider,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: MySearchAppBar(
            centerView: buildSearch(context),
            isBack: true,
            onPressed: () {
              print(completeInfo);
            },
          ),
          body: isLoading
              ? Column(
                  children: <Widget>[
                    Container(
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: isLoadingCategories
                                    ? TabBar(
                                        onTap: (index) {
                                          // Routers.push('/naviPage', context);
                                          if (index == 0) {
                                            return;
                                          }
                                          HomeCategories cateData =
                                              categoriesList[index - 1];
                                          Routers.push(
                                              '/categorieslistPage', context, {
                                            "categories":
                                                cateData.categories[0],
                                            "firstLevelCate": cateData
                                          });
                                          if (!mounted) {
                                            return;
                                          }
                                        },
                                        isScrollable: true,
                                        controller: _tabController,
                                        labelColor: AppColor.textDark,
                                        labelStyle: AppText.textDark14,
                                        unselectedLabelColor: AppColor.textDark,
                                        unselectedLabelStyle:
                                            AppText.textDark14,
                                        indicatorColor: AppColor.white,
                                        tabs: topCategoriesList,
                                      )
                                    : Container(
                                        height: 44,
                                      )),
                            IconButton(
                                icon: Icon(Icons.list),
                                onPressed: () {
                                  Routers.push('/naviPage', context);
                                }),
                          ],
                        )),
                    Expanded(
                      child: Container(
                        child: RefreshIndicator(
                          color: AppColor.themeRed,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            // physics: new NeverScrollableScrollPhysics(),
                            itemBuilder: buildBigestCll,
                            itemCount: 4,
                            controller: _scrollController,
                          ),
                          onRefresh: _handleRefresh,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ));
  }

  Widget buildBigestCll(BuildContext context, int index) {
    if (index == 0) {
      return ListView.builder(
        shrinkWrap: true,
        physics: new NeverScrollableScrollPhysics(),
        itemBuilder: buildCell,
        itemCount: 4,
      );
    } else if (index == 1) {
      return bottomGoodsList.isEmpty
          ? Container()
          : Container(
              height: 60,
              color: AppColor.line,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '——  商品推荐  ——',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            );
    } else if (index == 2) {
      return bottomGoodsList.isEmpty
          ? Container()
          : buildBottomGrideView(bottomGoodsList);
    } else {
      return bottomGoodsList.isEmpty ? Container() : _buildProgressIndicator();
    }
  }

  // 加载更多 Widget
  Widget _buildProgressIndicator() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 14.0),
        child: new Opacity(
            opacity: 1.0,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                hasMoreDate
                    ? new SpinKitChasingDots(
                        color: Colors.blueAccent, size: 26.0)
                    : Container(),
                new Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: hasMoreDate
                        ? new Text('正在加载中...')
                        : new Text('商品到底了!!!'))
              ],
            )));
  }

  // ignore: missing_return
  Widget buildCell(BuildContext context, int index) {
    if (index == 0) {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 0, bottom: 0),
          ),
          buildStyle1(homeData, context),
        ],
      );
    } else if (index != 4) {
      double width = ScreenUtil().screenWidth;
      List headImgData = [
        LoadImage(
          homeData?.pictures?.hotSale?.picturePath ?? '',
          fit: BoxFit.fitWidth,
          holderImg: "home/热销@3x",
        ),
        LoadImage(
          homeData?.pictures?.hotBrand?.picturePath ?? '',
          fit: BoxFit.fitWidth,
          holderImg: "home/推荐@3x",
        ),
        LoadImage(
          homeData?.pictures?.forSale?.picturePath ?? '',
          fit: BoxFit.fitWidth,
          holderImg: "home/特价@3x",
        ),
      ];
      List goodList = [];
      String imgLul = "";
      if (index == 1) {
        imgLul = homeData?.pictures?.hotSale?.picturePath ?? '';
        goodList = homeData.hotSale;
      }
      if (index == 2) {
        imgLul = homeData?.pictures?.hotBrand?.picturePath ?? '';
        goodList = homeData.brandsSale;
      }
      if (index == 3) {
        imgLul = homeData?.pictures?.forSale?.picturePath ?? '';
        goodList = homeData.forSale;
      }
      bool initView = true;
      if (goodList.length == 0) {
        initView = false;
      }
      var row_row = Container(
        height: width * 120 / 375 + width * 10 / 9,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            // flex: 1,
            GestureDetector(
              child: new Container(
                height: width * 120 / 375,
                color: Colors.white,
                padding: EdgeInsets.only(right: 0, top: 0, bottom: 0, left: 0),
                child: headImgData[index - 1],
              ),
              onTap: () {
                Routers.push('/tpyeListPage', context,
                    {"type": index, "imgUrl": imgLul});
              },
            ),
            new Container(
              height: width * 10 / 9,
              child: initView ? buildGride(goodList) : Container(),
            ),
          ],
        ),
      );
      return row_row;
    }
  }

  Future<Null> _handleRefresh() async {
    setState(() {
      index = 1;
      isShowLoading = false;
      gethomeData();
      _getMoreData();
    });
  }

  // 搜索框
  Widget buildSearch(BuildContext context) {
    Widget widget = Container(
      height: 35,
      width: ScreenUtil().screenWidth * 7 / 9,
      // margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F9),
      ),
      child: BaseInput(
        readOnly: true,
        maxLength: 50,
        prefixIcon: Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        hintText: S.of(context).homeSearchHint, //"搜索商品或品牌"
        controller: _textKeywordController,
        focusNode: _nodeKeyword,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.go,
        onSubmitted: (res) {},
        onTab: () {
          Routers.push('/searchPage', context);
        },
      ),
    );
    return widget;
  }

  Widget _getListData1(List goodList, index) {
    double width = ScreenUtil().screenWidth / 3;
    HotSale saleDate = goodList[index];
    //第二种设置数据：
    return new GestureDetector(
      onTap: () {
        //处理点击事件
        Routers.push('/goodsDetailPage', context, {"goodsId": saleDate.id});
      },
      child: Container(
        child: Column(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              height: width,
              width: width,
              color: Colors.white,
              child: LoadImage(
                saleDate.majorThumb.first,
                fit: BoxFit.fitWidth,
                holderImg: "goods/goodDefault@3x",
                format: "png",
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: width * 3.5 / 9,
              width: width,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      saleDate.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 12,
                        backgroundColor: Colors.white,
                        color: Color(0xff999999),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: width * 2 / 9,
              width: width,
              child: new Row(
                children: <Widget>[
                  Text(
                    "¥" + double.parse(saleDate.lowestPrice).toStringAsFixed(2),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      backgroundColor: Colors.white,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFF5F5F9), width: 0.5)),
      ),
    );
  }

  Widget buildGride(List date) {
    return GridView.builder(
      physics: new NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 0.0, //水平子Widget之间间距
        mainAxisSpacing: 0.0, //垂直子Widget之间间距
        crossAxisCount: 3, //一行的Widget数量
        childAspectRatio: 3 / 5, // 宽高比例
      ),
      itemCount: date.length,
      itemBuilder: (context, index) => _getListData1(date, index),
    );
  }

  Widget _getListData2(List goodList, index) {
    double width = ScreenUtil().screenWidth / 2;
    ProductsItem productGoods = goodList[index];
    //第二种设置数据：
    return new GestureDetector(
      onTap: () {
        //处理点击事件
        Routers.push('/goodsDetailPage', context, {"goodsId": productGoods.id});
      },
      child: Container(
        child: Column(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              height: width,
              width: width,
              color: Colors.white,
              child: LoadImage(
                productGoods.majorThumb.first,
                fit: BoxFit.fitWidth,
                holderImg: "goods/goodDefault@3x",
                format: "png",
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              height: width * 2 / 9,
              width: width,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      productGoods.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 12,
                        backgroundColor: Colors.white,
                        color: Color(0xff999999),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              height: width * 2 / 9,
              width: width,
              child: new Row(
                children: <Widget>[
                  Text(
                    "¥" + productGoods.lowestPrice.toStringAsFixed(2),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      backgroundColor: Colors.white,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFF5F5F9), width: 0.5)),
      ),
    );
  }

  Widget buildBottomGrideView(List date) {
    return GridView.builder(
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 0.0, //水平子Widget之间间距
        mainAxisSpacing: 0.0, //垂直子Widget之间间距
        crossAxisCount: 2, //一行的Widget数量
        childAspectRatio: 1 / 1.5, // 宽高比例
      ),
      itemCount: date.length,
      itemBuilder: (context, index) => _getListData2(date, index),
    );
  }
}

//banner 图
Widget buildStyle1(HomeDataInfo dic, context) {
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(top: 0, bottom: 0),
        height: 155 * ScreenUtil().screenWidth / 375,
        color: Color(0xFFF5F5F9),
        child: new Swiper(
          // 横向
          scrollDirection: Axis.horizontal,
          // 布局构建
          itemBuilder: (BuildContext context, int index) {
            return LoadImage(
              dic.pictures.banner[index].picturePath,
              fit: BoxFit.fitWidth,
              holderImg: "home/banner@3x",
              format: "png",
            );
          },
          //条目个数
          itemCount: dic.pictures.banner.length,
          // 自动翻页
          autoplay: true,
          // 分页指示
          pagination: buildPlugin(),
          //点击事件
          onTap: (index) {
            BannerModel bannerModel = dic.pictures.banner[index];
            if (bannerModel.linkType == 1) {
              // linkType  1 商品详情
              Routers.push('/goodsDetailPage', context,
                  {"goodsId": bannerModel.linkPath});
            }
            if (bannerModel.linkType == 2) {
              Routers.push(
                  '/searchPage', context, {"keyword": bannerModel.linkPath});
            }
            if (bannerModel.linkType == 3) {
              Routers.push(
                  '/searchPage', context, {"keyword": bannerModel.linkPath});
            }
            // linkType  1 商品详情   2 分类详情 3搜索关键字 关键字在 linkPath(所有的点击banner的值都在这里)
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
      )
    ],
  );
}

buildPlugin() {
  return SwiperPagination();
}

class Orange {
  var weight;
  var color;

  Orange(this.weight, this.color);

  void showWeight() {
    var num = weight + color;
    print("weight = $num");
  }

  void showColor() {
    print("color = $color");
  }
}

class Banana {
  var weight;
  Banana(this.weight);
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
              index == 0
                  ? Text(
                      tabName,
                      style: TextStyle(color: AppColor.themeRed),
                    )
                  : Text(tabName),
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

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
