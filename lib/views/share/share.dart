import 'package:E_Sale_Tech/api/share.dart';
import 'package:E_Sale_Tech/model/Share/articles_bean.dart';
import 'package:E_Sale_Tech/model/Share/pictures.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/login/Refresh.dart';
import 'package:E_Sale_Tech/views/login/login_config.dart';
import 'package:E_Sale_Tech/views/login/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SharePage extends StatefulWidget {
  SharePage({this.arguments});

  final Map arguments;

  @override
  _SharePageState createState() => new _SharePageState();
}

class _SharePageState extends State<SharePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String keyword = "";
  int _count = 0;
  int page = 1;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textKeywordController = new TextEditingController();
  final FocusNode _nodeKeyword = FocusNode();
  bool isnomore = false;
  List<ArticlesBean> data;
  String imgUrl = "";

  @override
  void initState() {
    super.initState();
    getDataList();
    getPictures();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getPictures() async {
    var bean = await ApiShare.pictures();
    if (bean['ret'] == 0) {
      return;
    }
    Pictures pictures = bean['bean'];
    setState(() {
      imgUrl = pictures.share.linkPath;
    });
  }

  void getDataList() async {
    Map<String, dynamic> map = {'keyword': keyword, 'page': page};
    var bean = await ApiShare.getArticles(map);
    if (page == 1) {
      List<ArticlesBean> list = bean['list'];
      if (bean['ret'] == 0) {
        Util.showToast(bean['msg']);
        return;
      }
      setState(() {
        data = list;
        _count = data.length;
      });
    } else {
      List<ArticlesBean> list = bean['list'];
      if (list.length <= 0) {
        isnomore = true;
        if (page == 1) {
          Util.showToast('没有搜索到任何资讯');
        } else {
          Util.showToast('没有更多资讯了');
        }
        return;
      }
      data.addAll(list);
      setState(() {
        _count = data.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          //CustomScrollView
          RefreshLayout(
              child: refreshView(),
              canloading: !isnomore,
              onRefresh: (boo) {
                if (!boo) {
                  print('===加载更多===');
                  page++;
                  return reset();
                } else {
                  print('===刷新===$_count');
                  page = 1;
                  keyword = _textKeywordController.text;
                  Util.showToast("刷新成功");
                  return reset();
                }
              }),
          so(),
        ],
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  Widget so() {
    return GestureDetector(
      child: Container(
        height: 40,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 40, right: 20, left: 20),
        decoration: new BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          //设置四周边框
          border: new Border.all(width: 1, color: Colors.white),
        ),
        child: Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 2, right: 2)),
            GestureDetector(
              child: Icon(
                Icons.search,
                color: HexToColor('#A8A8A8'),
              ),
              onTap: () {
                return;
              },
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width - 120,
              child: TextField(
                maxLines: 1,
                cursorColor: Theme.of(context).primaryColor,
                controller: _textKeywordController,
                autocorrect: true,
                scrollPadding: EdgeInsets.all(10),
                maxLengthEnforced: true,
                textInputAction: TextInputAction.search,
                decoration: new InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  hintText: '搜索品牌资讯',
                  hintStyle: TextStyle(
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                ),
                onEditingComplete: () {
                  if (_textKeywordController.text.isEmpty) {
                    return;
                  }
                  keyword = _textKeywordController.text.trim();
                  FocusScope.of(context).requestFocus(FocusNode());
                  reset();
                },
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '   取消',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        page = 1;
        _textKeywordController.text = "";
        keyword = "";
        reset();
      },
    );
  }

  Future<Null> getData() {
    setState(() {
      _count += 10;
      if (_count > 40) {
        isnomore = true;
      }
    });
    return Future.delayed(Duration(milliseconds: 1000), () {});
  }

  Future<Null> reset() {
    setState(() {
      getDataList();
      isnomore = false;
    });
    return Future.delayed(Duration(milliseconds: 1000), () {});
  }

  Widget refreshView() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          // 展开的高度
          expandedHeight: 155.0,
          pinned: true,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Image.network(
              imgUrl,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: grass(),
        ),
        buildSliverFixedExtentList(),
      ],
    );
  }

  Widget grass() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/common/fabulousLeft.png',
            height: 16,
            width: 16,
            fit: BoxFit.cover,
          ),
          PublicView().getText("品牌种草", "#1C1717", 18),
          Image.asset(
            'assets/images/common/fabulousRight.png',
            height: 16,
            width: 16,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget inputText() {
    return TextField(
        style: TextStyle(fontSize: 10),
        autocorrect: true,
        autofocus: false,
        maxLines: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          hintText: "搜索品牌资讯",
          hintMaxLines: 1,
          hintStyle: TextStyle(color: Colors.black38, fontSize: 12),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            size: 15,
            color: Colors.black,
          ),
        ));
  }

  Widget buildSliverFixedExtentList() {
    return SliverFixedExtentList(
      itemExtent: 120, //child的长度或者宽度,取决于滚动方向.
      delegate: SliverChildBuilderDelegate(
        (context, int index) {
          return GestureDetector(
            child: getItem(index),
            onTap: () {
              Routers.push('/articleDetails', context, {
                "url": data[index].shareUrl,
                'img': data[index].cover,
                "title": data[index].title,
                'id': data[index].id.toString()
              });
            },
          );
        },
        childCount: _count,
      ),
    );
  }

  Widget getItem(int index) {
    return Row(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 10, left: 10),
          child: Image.network(
            data[index].cover,
            height: 100,
            width: 100,
            fit: BoxFit.fill,
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 10)),
              Container(
                child: Text(
                  data[index].title,
                  maxLines: 1,
                  style: TextStyle(fontSize: 15, color: HexToColor('#1C1717')),
                ),
                alignment: Alignment.topLeft,
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Container(
                margin: EdgeInsets.only(right: 5),
                alignment: Alignment.topLeft,
                child: Text(
                  data[index].abstract,
                  maxLines: 3,
                  style: TextStyle(fontSize: 12, color: HexToColor('#999999')),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 10, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.share,
                      size: 11,
                      color: HexToColor('#CCCCCC'),
                    ),
                    Padding(padding: EdgeInsets.only(right: 2)),
                    PublicView().getText(
                        data[index].shareCount.toString(), '#CCCCCC', 12),
                    Padding(padding: EdgeInsets.only(right: 5)),
                    Icon(
                      Icons.thumb_up,
                      size: 11,
                      color: HexToColor('#CCCCCC'),
                    ),
                    Padding(padding: EdgeInsets.only(right: 2)),
                    PublicView().getText(
                        data[index].likeCount.toString(), '#CCCCCC', 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
