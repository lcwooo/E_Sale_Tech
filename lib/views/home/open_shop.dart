import 'package:E_Sale_Tech/api/openShop.dart';
import 'package:E_Sale_Tech/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:E_Sale_Tech/routers/routers.dart';

class OpenShopPage extends StatefulWidget {
  OpenShopPage({this.arguments});
  final Map arguments;
  @override
  _OpenShopPageState createState() => new _OpenShopPageState();
}

class _OpenShopPageState extends State<OpenShopPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isLoading = false;
  String imgUrl = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getImgUrl();
    // life circle
  }

  _getImgUrl() {
    ApiOpenShop.getOpenShopImg((data) {
      setState(() {
        imgUrl = data;
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
        appBar: MyAppBar(
          centerTitle: "我要开店",
          isBack: true,
        ),
        body: Container(
          // height: ScreenUtil.screenHeightDp,
          width: ScreenUtil().screenWidth,
          child: SingleChildScrollView(
            physics: new NeverScrollableScrollPhysics(),
            child: LoadImage(
              imgUrl,
              fit: BoxFit.fitWidth,
              holderImg: "home/banner@3x",
              format: "png",
            ),
          ),
        ),
        floatingActionButtonLocation: CustomFloatingActionButtonLocation(
            FloatingActionButtonLocation.centerFloat, 0, -30),
        floatingActionButton: new Container(
          // color: Colors.yellow,
          height: 44,
          width: ScreenUtil().screenWidth / 2,
          child: RaisedButton(
              color: AppColor.themeRed,
              padding: EdgeInsets.all(0),
              child: Text("我要开店",
                  style: TextStyle(
                      color: Color(0xFF1C1717),
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                      fontFamily: "SourceHanSansSC-Regular")),
              onPressed: () {
                Routers.push('/fillInformation', context);
              }),
        ));
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
