import 'package:E_Sale_Tech/api/me.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/components/list_refresh.dart';
import 'package:E_Sale_Tech/model/me/agent_invoice_list.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/me/my_address/address_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvoiceListPage extends StatefulWidget {
  InvoiceListPage({this.arguments});
  final Map arguments;
  @override
  _InvoiceListPageState createState() => new _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _nodeKeyword = FocusNode();

  AddressIndexProvider provider = AddressIndexProvider();
  TabController _tabController;
  PageController _pageController = PageController(initialPage: 0);
  TextEditingController _textKeywordController = new TextEditingController();
  GlobalKey _bodyKey = GlobalKey();

  int pageIndex = 0;

  String keyword = '';

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    // life circle
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
              backgroundColor: Colors.white,
              centerTitle: "我的发票",
              isBack: true,
            ),
            body: Column(
              key: _bodyKey,
              children: <Widget>[
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
                      const _TabView("交易发票", "", 0),
                      const _TabView("提现发票", "", 1),
                      const _TabView("其他", "", 2),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    key: const Key('pageView'),
                    itemCount: 3,
                    onPageChanged: _onPageChange,
                    controller: _pageController,
                    itemBuilder: (BuildContext context, int index) {
                      // return ListView(children: this.pageData[index]);
                      return ListRefresh(
                        renderItem: _buildInvoiceItem,
                        more: loadMoreList,
                        refresh: loadList,
                      );
                    },
                  ),
                ),
              ],
            )));
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> params = {
      "page": (++pageIndex),
    };

    return await ApiMe.invoiceList(params);
  }

  Widget _buildInvoiceItem(int index, AgentInvoiceList invoiceItem) {
    return Container(
      width: ScreenUtil().screenWidth,
      child: new Column(
        children: <Widget>[
          Container(
            height: 10,
            width: ScreenUtil().screenWidth,
            color: Colors.transparent,
          ),
          Container(
            padding: EdgeInsets.only(left: 11.5),
            color: AppColor.white,
            height: 40,
            width: ScreenUtil().screenWidth,
            child: Row(
              children: <Widget>[
                Container(
                  width: 16,
                  height: 16,
                  child: Image.asset('assets/images/me/invoice_icon.png'),
                ),
                Text(invoiceItem.number),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppColor.themeRed,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(14.5, 14.5, 0, 0),
            color: AppColor.white,
            height: 83,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: AppColor.white,
                        height: 20,
                        width: ScreenUtil().screenWidth,
                        child: Row(
                          children: <Widget>[
                            Text('下单时间',
                                style: TextStyle(
                                  color: Color(0xff999999),
                                  fontSize: 14.5,
                                )),
                            Container(
                              width: 11.5,
                            ),
                            Text(invoiceItem.createdAt,
                                style: TextStyle(
                                  color: Color(0xff1c1717),
                                  fontSize: 11.5,
                                ))
                          ],
                        ),
                      ),
                      Container(
                        color: AppColor.white,
                        height: 40,
                        width: ScreenUtil().screenWidth,
                        child: Row(
                          children: <Widget>[
                            Text('开票金额',
                                style: TextStyle(
                                  color: Color(0xff999999),
                                  fontSize: 14.5,
                                )),
                            Container(
                              width: 11.5,
                            ),
                            Text(invoiceItem.amount.toString(),
                                style: TextStyle(
                                  color: Color(0xff1c1717),
                                  fontSize: 11.5,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: AppColor.white,
                    margin: EdgeInsets.only(left: 40, top: 20),
                    width: 16,
                    height: 16,
                    child: TextButton(
                      child:
                          Image.asset('assets/images/me/invoice_download.png'),
                      onPressed: () {
                        Util.showToast('暂无发票');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getListData(int index) {
    List<Widget> widgets = [];
    var num = 0;
    for (var i = 0; i < 2; i++) {
      var newRow = new Container(
        width: ScreenUtil().screenWidth,
        child: new Column(
          children: <Widget>[
            Container(
              height: 10,
              width: ScreenUtil().screenWidth,
              color: Colors.transparent,
            ),
            Container(
              padding: EdgeInsets.only(left: 11.5),
              color: AppColor.white,
              height: 40,
              width: ScreenUtil().screenWidth,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 16,
                    height: 16,
                    child: Image.asset('assets/images/me/invoice_icon.png'),
                  ),
                  Text('MES9389222'),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: AppColor.themeRed,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(14.5, 14.5, 0, 0),
              color: AppColor.white,
              height: 83,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: AppColor.white,
                          height: 20,
                          width: ScreenUtil().screenWidth,
                          child: Row(
                            children: <Widget>[
                              Text('下单时间',
                                  style: TextStyle(
                                    color: Color(0xff999999),
                                    fontSize: 14.5,
                                  )),
                              Container(
                                width: 11.5,
                              ),
                              Text('2020-09-09 09:09:30',
                                  style: TextStyle(
                                    color: Color(0xff1c1717),
                                    fontSize: 11.5,
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          color: AppColor.white,
                          height: 40,
                          width: ScreenUtil().screenWidth,
                          child: Row(
                            children: <Widget>[
                              Text('开票金额',
                                  style: TextStyle(
                                    color: Color(0xff999999),
                                    fontSize: 14.5,
                                  )),
                              Container(
                                width: 11.5,
                              ),
                              Text('2020-09-09 09:09:30',
                                  style: TextStyle(
                                    color: Color(0xff1c1717),
                                    fontSize: 11.5,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: AppColor.white,
                      margin: EdgeInsets.only(left: 40, top: 20),
                      width: 16,
                      height: 16,
                      child:
                          Image.asset('assets/images/me/invoice_download.png'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      widgets.add(newRow);
    }
    if (widgets.length != 0) {
      this.setState(() {
        // this.pageData[index].add();
      });
    }
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
