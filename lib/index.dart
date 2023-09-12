import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/model/index.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/localstorage.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/views/shop/collection/batch_put_on_shelf.dart';
import 'package:flutter/material.dart';

// page
import 'package:E_Sale_Tech/views/home/home.dart';
import 'package:E_Sale_Tech/views/shop/shop.dart';
import 'package:E_Sale_Tech/views/goods/goods.dart';
import 'package:E_Sale_Tech/views/share/share.dart';
import 'package:E_Sale_Tech/views/me/me.dart';
import 'package:provider/provider.dart';

class MasterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  int _currentIndex = 0;
  String token;
  List tabData = [
    {
      'text': '首页',
      'icon': 'assets/images/common/home@3x.png',
      'activeIcon': 'assets/images/common/home-active@3x.png',
    },
    {
      'text': '店铺',
      'icon': 'assets/images/common/shop@3x.png',
      'activeIcon': 'assets/images/common/shop-active@3x.png',
    },
    {
      'text': '选品',
      'icon': 'assets/images/common/goods@3x.png',
      'activeIcon': 'assets/images/common/goods-active@3x.png',
    },
    {
      'text': '种草',
      'icon': 'assets/images/common/share@3x.png',
      'activeIcon': 'assets/images/common/share-active@3x.png',
    },
    {
      'text': '我的',
      'icon': 'assets/images/common/me@3x.png',
      'activeIcon': 'assets/images/common/me-active@3x.png',
    },
  ];
  List<BottomNavigationBarItem> _myTabs = [];

  final bodyList = [
    HomePage(),
    ShopPage(),
    BatchPutOnShelf(arguments: {
      "type": 3,
      "showBackBtn": false,
    }),
    SharePage(),
    MePage()
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    //创建tabbar
    for (int i = 0; i < tabData.length; i++) {
      _myTabs.add(BottomNavigationBarItem(
        icon: Image.asset(
          tabData[i]['icon'],
          width: 24,
          height: 24,
        ),
        activeIcon: Image.asset(
          tabData[i]['activeIcon'],
          width: 24,
          height: 24,
        ),
        title: Text(
          tabData[i]['text'],
        ),
      ));
    }
    ApplicationEvent.event.on<UnAuthenticateEvent>().listen((event) {
      Provider.of<Model>(context, listen: false).setToken('');
    });

    ApplicationEvent.event.on<ChangeKeepAlivePageIndex>().listen((event) {
      int index = jumpToIndex(event.pageName);
      _itemTapped(index);
      pageController.jumpToPage(index);
    });
  }

  void _itemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  int jumpToIndex(String pageName) {
    switch (pageName) {
      case 'home':
        return 0;
        break;
      case 'shop':
        return 1;
        break;
      case 'goods':
        return 2;
        break;
      case 'share':
        return 3;
        break;
      case 'me':
        return 4;
        break;
      default:
        return 0;
    }
  }

  void onTap(int index) async {
    // if (Provider.of<Model>(context, listen: false).token.isEmpty &&
    //     index != 0) {
    //   Routers.push('/login', context);
    //   return;
    // }
    // if (!await LocalStorage.getCompleteInfo() && index != 0 && index != 4) {
    //   Routers.push('/openShop', context);
    //   return;
    // }
    pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: PageView(
        controller: pageController,
        onPageChanged: _itemTapped,
        children: bodyList,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _myTabs,
        currentIndex: _currentIndex,
        onTap: onTap,
        selectedLabelStyle: TextStyle(color: AppColor.themeRed),
        selectedItemColor: AppColor.themeRed,
        type: BottomNavigationBarType.fixed,
        // fixedColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
