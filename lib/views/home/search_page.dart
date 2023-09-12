import 'package:E_Sale_Tech/api/home.dart';
import 'package:E_Sale_Tech/api/search.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/home/search_result_list.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/search_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/views/home/choice_chip.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SearchPage extends StatefulWidget {
  SearchPage({this.arguments});

  final Map arguments;

  @override
  _SearchPageState createState() => new _SearchPageState(arguments: arguments);
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  final Map arguments;
  _SearchPageState({this.arguments});
  @override
  bool get wantKeepAlive => true;
  String keyword = "";
  int pageIndex = 0;
  List<String> hotList = [];
  List<String> historyList = [];
  List<String> blurryStrList = [];

  bool isLoading = false;
  bool isSearched = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (this.arguments != null) {
      keyword = this.arguments["keyword"];
      _controller.text = keyword;
      isSearched = true;
      isLoading = true;
    }
    print("$this.widget.arguments");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gethomeData();
    });
  }

  gethomeData() async {
    ApiHome.searchKeyWords((data) {
      isLoading = true;
      setState(() {
        hotList = List<String>.from(data["hot"]);
        historyList = List<String>.from(data["history"]);
        // homeData = data;
      });
    }, (message) => null);
  }

  blurry_search() async {
    ApiHome.searchblurrySearch({"keyword": keyword}, (data) {
      setState(() {
        blurryStrList = [];
        blurryStrList = List<String>.from(data["data"]);
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
    return Scaffold(
        key: _scaffoldKey,
        appBar: SearchBar(
          controller: _controller,
          focusNode: _focusNode,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Routers.pop(context);
              }),
          onSearch: (context) {
            setState(() {
              if (context.isEmpty) {
                gethomeData();
                isSearched = false;
              }
              keyword = context;
            });
            blurryStrList = [];
            blurry_search();
          },
          onSearchClick: (context) {
            setState(() {
              isSearched = true;
            });
          },
        ),
        body: isLoading ? getChild() : Container());
  }

  getChild() {
    if (isSearched) {
      print("object");
      return SearchResultList(
          arguments: {"keyWord": keyword, "isSearch": true});
    } else {
      if (keyword.isEmpty) {
        return buildChildNoSearch();
      } else {
        return blurryStrList.isNotEmpty
            ? buildInputKeyWordSearch()
            : Container();
      }
    }
  }

  Widget buildInputKeyWordSearch() {
    return new ListView.builder(
      itemCount: blurryStrList.length,
      itemBuilder: (context, ieindex) {
        return buildCellView(ieindex, blurryStrList);
      },
    );
  }

  Widget buildCellView(int index, List<String> strList) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isLoading = true;
          isSearched = true;
          _controller.text = strList[index];
          keyword = strList[index];
          getChild();
        });
      },
      child: Container(
        padding: EdgeInsets.only(right: 15, left: 15, top: 5, bottom: 5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                strList[index],
                style: TextStyle(fontSize: 13, color: AppColor.mainTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 没有搜索时的页面
  Widget buildChildNoSearch() {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Container(
          height: 50,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(S.of(context).topSearch,
                  style: TextStyle(
                    color: AppColor.mainTextColor,
                    fontSize: 16.0,
                  )),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ChoiceChipView(
                  selectlist: [],
                  isSingle: true,
                  shapeNo: 20,
                  list: hotList,
                  isHightLight: false,
                  onClick: (context) {
                    setState(() {
                      isSearched = true;
                      _controller.text = context;
                      keyword = context;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 50,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(S.of(context).historySearch,
                  style: TextStyle(
                    color: AppColor.mainTextColor,
                    fontSize: 16.0,
                  )),
              FlatButton(
                color: Colors.white,
                child: Text(S.of(context).clear),
                onPressed: () {
                  ApiHome.deleteSearchHistory((data) {
                    if (data.ret == 1) {
                      setState(() {
                        Util.showToast("删除成功");
                        historyList = [];
                      });
                    }
                  }, (message) => null);
                },
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ChoiceChipView(
                  selectlist: [],
                  isSingle: true,
                  shapeNo: 20,
                  list: historyList,
                  isHightLight: false,
                  onClick: (context) {
                    setState(() {
                      isSearched = true;
                      _controller.text = context;
                      keyword = context;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
