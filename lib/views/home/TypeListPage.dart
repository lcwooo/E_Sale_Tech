import 'package:E_Sale_Tech/api/openShop.dart';
import 'package:E_Sale_Tech/components/load_image.dart';
import 'package:E_Sale_Tech/views/home/TypePage_List.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:E_Sale_Tech/routers/routers.dart';

import 'search_result_list.dart';

class TpyeListPage extends StatefulWidget {
  TpyeListPage({this.arguments});
  final Map arguments;
  @override
  _TpyeListPageState createState() =>
      new _TpyeListPageState(arguments: arguments);
}

class _TpyeListPageState extends State<TpyeListPage>
    with AutomaticKeepAliveClientMixin {
  final Map arguments;
  _TpyeListPageState({this.arguments});
  @override
  bool get wantKeepAlive => true;

  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String title = "";

  @override
  void initState() {
    super.initState();
    if (this.arguments["type"] == 1) {
      title = '热销商品';
    } else if (this.arguments["type"] == 2) {
      title = '品牌推荐';
    } else if (this.arguments["type"] == 3) {
      title = '特价商品';
    }
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
      appBar: MyAppBar(
        centerTitle: title,
        isBack: true,
      ),
      body: Container(
          // height: ScreenUtil.screenHeightDp,
          width: ScreenUtil().screenWidth,
          child: Container(
            width: ScreenUtil().screenWidth,
            child: Column(
              children: <Widget>[
                LoadImage(
                  this.arguments["imgUrl"],
                  fit: BoxFit.fill,
                  holderImg: "home/banner@3x",
                  format: "png",
                ),
                Expanded(
                  child:
                      TypePageList(arguments: {"type": this.arguments["type"]}),
                ),
              ],
            ),
          )),
    );
  }
}
