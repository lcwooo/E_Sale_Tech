import 'package:E_Sale_Tech/api/home.dart';
import 'package:E_Sale_Tech/api/openShop.dart';
import 'package:E_Sale_Tech/components/load_image.dart';
import 'package:E_Sale_Tech/model/home/homeCategories.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:E_Sale_Tech/routers/routers.dart';

class NaviPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NaviPageState();
  }
}

class _NaviPageState extends State<NaviPage> {
  List<HomeCategories> _datas = []; //一级分类集合
  List<Categories> articles = []; //二级分类集合
  int index; //一级分类下标
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    _getHttp();
  }

  _getHttp() {
    ApiHome.getCategrise((data) {
      EasyLoading.dismiss();
      setState(() {
        isLoading = true;
        _datas = data;
        index = 0;
      });
    }, (message) {
      EasyLoading.dismiss();
      EasyLoading.showError(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: MyAppBar(
          centerTitle: "全部分类",
          isBack: true,
        ),
        body: !isLoading
            ? Container()
            : Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: AppColor.line,
                        child: ListView.builder(
                          itemCount: _datas.length,
                          itemBuilder: (BuildContext context, int position) {
                            return getRow(position);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: ListView(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.all(10),
                              color: AppColor.white,
                              child: getChip(index), //传入一级分类下标
                            ),
                          ],
                        )),
                  ],
                ),
              ));
  }

  Widget getRow(int i) {
    Color textColor = Theme.of(context).primaryColor; //字体颜色
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//Container下的color属性会与decoration下的border属性冲突，所以要用decoration下的color属性
        decoration: BoxDecoration(
          color: index == i ? Colors.white : AppColor.line,
          border: Border(
            left: BorderSide(
                width: 5,
                color:
                    index == i ? Theme.of(context).primaryColor : Colors.white),
          ),
        ),
        child: Text(
          _datas[i].name,
          style: TextStyle(
            color: index == i ? textColor : AppColor.textBlack,
            fontWeight: index == i ? FontWeight.w600 : FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          index = i; //记录选中的下标
          textColor = AppColor.themeRed;
        });
      },
    );
  }

  Widget getChip(int i) {
//更新对应下标数据
    HomeCategories cate = _datas[i];
    return GridView.builder(
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 0.0, //水平子Widget之间间距
        mainAxisSpacing: 0.0, //垂直子Widget之间间距
        crossAxisCount: 3, //一行的Widget数量
        childAspectRatio: 1 / 1, // 宽高比例
      ),
      itemCount: cate.categories.length,
      itemBuilder: (context, index) => _getListData2(cate, index),
    );
//     Wrap(
//       spacing: 10.0, //两个widget之间横向的间隔
//       direction: Axis.horizontal, //方向
//       alignment: WrapAlignment.start, //内容排序方式
//       children: List<Widget>.generate(
//         articles.length,
//         (int index) {
//           Categories catModel = articles[index];
//           return ActionChip(
// //标签文字
//             label: Container(
//               child: Column(
//                 children: <Widget>[
//                   Icon(Icons.ac_unit),
//                   Text(
//                     catModel.name,
//                     style: TextStyle(fontSize: 16, color: AppColor.textBlack),
//                   ),
//                 ],
//               ),
//             ),
// //点击事件
//             onPressed: () {},
//             elevation: 3,
//             backgroundColor: Colors.grey.shade200,
//           );
//         },
//       ).to[],
//     );
  }

  Widget _getListData2(HomeCategories cateData, index) {
    double width = ScreenUtil().screenWidth * 5 / 7 / 3;
    Categories productGoods = cateData.categories[index];
    //第二种设置数据：
    return new GestureDetector(
      onTap: () {
        //处理点击事件
        Routers.push('/categorieslistPage', context,
            {"categories": productGoods, "firstLevelCate": cateData});
      },
      child: Container(
        child: Column(
          children: <Widget>[
            new Container(
              height: width * 1 / 2,
              width: width * 1 / 2,
              color: Colors.white,
              child: LoadImage(
                productGoods.icon,
                fit: BoxFit.fitWidth,
                holderImg: "goods/goodDefault@3x",
                format: "png",
              ),
            ),
            new Container(
              padding: EdgeInsets.only(top: 5),
              width: width,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      productGoods.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        backgroundColor: Colors.white,
                        color: Color.fromRGBO(109, 109, 109, 1),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // decoration: BoxDecoration(
        //     border: Border.all(color: Color(0xFFF5F5F9), width: 0.5)),
      ),
    );
  }

  ///
  /// 根据一级分类下标更新二级分类集合
  ///
  List<Categories> _updateArticles(int i) {
    HomeCategories cate = _datas[i];
    setState(() {
      articles = cate.categories;
    });
    return articles;
  }
}
