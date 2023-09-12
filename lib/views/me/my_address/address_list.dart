import 'dart:convert';

import 'package:E_Sale_Tech/api/log_util.dart';
import 'package:E_Sale_Tech/api/me.dart';
import 'package:E_Sale_Tech/components/click_item.dart';
import 'package:E_Sale_Tech/components/list_refresh.dart' as listComp;
import 'package:E_Sale_Tech/model/goods/orderPreviewDetail.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/views/me/my_address/address_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressListPage extends StatefulWidget {
  AddressListPage({this.arguments});
  final Map arguments;
  @override
  _AddressListPageState createState() =>
      new _AddressListPageState(arguments: arguments);
}

class _AddressListPageState extends State<AddressListPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  _AddressListPageState({this.arguments});
  final Map arguments;
  @override
  bool get wantKeepAlive => true;

  bool isLoading = false;
  int pageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _nodeKeyword = FocusNode();

  AddressIndexProvider provider = AddressIndexProvider();
  TabController _tabController;
  PageController _pageController = PageController(initialPage: 0);
  TextEditingController _textKeywordController = new TextEditingController();
  GlobalKey _bodyKey = GlobalKey();
  List<Widget> receiveAddress = [];
  List<Widget> invoiceAddress = [];

  String keyword = '';
  final statusArr = [
    {'status': 1},
    {'status': 2},
  ];

  @override
  void initState() {
    super.initState();
    if (this.arguments != null) {
      setState(() {
        keyword = this.arguments["fromOrder"];
      });
    }
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<AddressIndexProvider>(
        create: (_) => provider,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            backgroundColor: Color(0xffF8F8F8),
            appBar: MyAppBar(
              centerTitle: "地址列表",
            ),
            bottomNavigationBar: Material(
              color: AppColor.themeRed,
              child: TextButton(
                child: new Padding(
                  padding: new EdgeInsets.all(10),
                  child: Text("新增地址",
                      style: TextStyle(
                        fontSize: 18.0, //textsize
                        color: AppColor.white,
                      )),
                ),
                onPressed: () async {
                  Routers.push('/me/myAddress/editAddress', context,
                      {'type': provider.index + 1});
                },
              ),
            ),
            body: keyword.isEmpty
                ? Column(
                    key: _bodyKey,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                top: BorderSide(
                                    color: Color(0xFFF2F2F7), width: 1))),
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
                            const _TabView("收货地址", "", 0),
                            const _TabView("发票地址", "", 1),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          key: const Key('pageView'),
                          itemCount: 2,
                          onPageChanged: _onPageChange,
                          controller: _pageController,
                          itemBuilder: (BuildContext context, int index) {
                            print(index);
                            return AddressManagerList(params: {
                              'status': statusArr[index]['status'],
                              'keyword': keyword,
                            });
                          },
                        ),
                      ),
                    ],
                  )
                : Column(
                    key: _bodyKey,
                    children: <Widget>[
                      Expanded(
                        child: PageView.builder(
                          key: const Key('pageView'),
                          itemCount: 1,
                          onPageChanged: _onPageChange,
                          controller: _pageController,
                          itemBuilder: (BuildContext context, int index) {
                            return AddressManagerList(params: {
                              'status': statusArr[index]['status'],
                              'keyword': keyword,
                            });
                          },
                        ),
                      ),
                    ],
                  )));
  }

  _onPageChange(int index) {
    _tabController.animateTo(index);
    provider.setIndex(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class AddressManagerList extends StatefulWidget {
  AddressManagerList({Key key, @required this.params});

  final Map<String, dynamic> params;

  @override
  _AddressManagerListState createState() => _AddressManagerListState();
}

class _AddressManagerListState extends State<AddressManagerList> {
  final GlobalKey<_AddressManagerListState> key = GlobalKey();

  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    return await ApiMe.getAddresses({
      'type': this.widget.params['status'],
      "page": (++pageIndex),
    });
  }

  Widget renderItem(index, Address address) {
    return GestureDetector(
        onTap: () {
          if (this.widget.params['keyword'].isNotEmpty) {
            Navigator.of(context).pop(address);
          } else {
            Routers.push('/me/myAddress/editAddress', context,
                {'address': address, 'type': this.widget.params['status']});
          }
        },
        child: Container(
          margin: EdgeInsets.only(top: 10),
          width: ScreenUtil().screenWidth,
          child: Column(
            children: <Widget>[
              Container(
                width: ScreenUtil().screenWidth,
                color: AppColor.white,
                child: ListTile(
                  title: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 11.5),
                              child: Text(address.name,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            Text(
                              address.mobile,
                              style: TextStyle(fontSize: 11.5),
                            ),
                            Container(
                              child: Text(
                                address.isDefault == 1 ? '默认' : '',
                                style: TextStyle(
                                    fontSize: 11.5, color: AppColor.themeRed),
                              ),
                              margin: EdgeInsets.only(left: 10.5),
                            ),
                          ],
                        ),
                        Text(address?.idCard ?? ''),
                        address.type == 1
                            ? Text((address?.provinces ?? '') +
                                ' ' +
                                address?.address)
                            : Text((address?.provinces?.replaceAll('+', '  ') ??
                                    '') +
                                ' ' +
                                address?.address),
                      ],
                    ),
                  ),
                  trailing: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.keyboard_arrow_right),
                  ),
                ),
              ),
            ],
          ),
        ));
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

///tab 标签栏
class _TabView extends StatelessWidget {
  const _TabView(this.tabName, this.tabSub, this.index);

  final String tabName;
  final String tabSub;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressIndexProvider>(
      builder: (_, provider, child) {
        return Tab(
            child: SizedBox(
          width: 88.0,
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
