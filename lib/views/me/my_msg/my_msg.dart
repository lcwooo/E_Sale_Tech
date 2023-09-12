import 'dart:convert';

import 'package:E_Sale_Tech/api/log_util.dart';
import 'package:E_Sale_Tech/api/me.dart';
import 'package:E_Sale_Tech/components/click_item.dart';
import 'package:E_Sale_Tech/components/list_refresh.dart' as listComp;
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/model/goods/orderPreviewDetail.dart';
import 'package:E_Sale_Tech/model/me/agent_msg_list.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/me/my_address/address_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:left_scroll_actions/cupertinoLeftScroll.dart';
import 'package:left_scroll_actions/global/actionListener.dart';
import 'package:left_scroll_actions/leftScroll.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyMsg extends StatefulWidget {
  MyMsg({this.arguments});
  final Map arguments;
  @override
  _MyMsgState createState() => new _MyMsgState(arguments: arguments);
}

class _MyMsgState extends State<MyMsg>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  _MyMsgState({this.arguments});
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
    {'status': 0},
    {'status': 1},
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
              centerTitle: "我的消息",
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
                      const _TabView("未读消息", "", 0),
                      const _TabView("已读消息", "", 1),
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
    Map<String, dynamic> params = {
      "page": (++pageIndex),
      "read": (widget.params['status'])
    };
    return await ApiMe.msgList(params);
  }

  Widget _buildMsgItem(index, AgentMsgList msg) {
    return CupertinoLeftScroll(
      closeOnPop: true,
      closeTag: LeftScrollCloseTag('$index'),
      bounce: true,
      child: ClickItem(
        title: msg.title,
        content: msg.createdAt,
        rightWidget: msg.isRead == 0
            ? ClipOval(
                child: Container(width: 8, height: 8, color: Color(0xFFFF6161)),
              )
            : null,
        hideArrow: true,
        onTap: () {
          if (msg.isRead == 0) {
            ApplicationEvent.event
                .fire(ListRefreshEvent('delete', index, 'isRead', 1));
            ApiMe.sendIsMessage(msg.id, (data) => null, (message) => null);
          }
          Routers.push("/me/myMsg/detail", context, {'msg': msg});
        },
      ),
      buttons: <Widget>[
        LeftScrollItem(
          text: '删除',
          color: Colors.red,
          onTap: () {
            ApiMe.deleteMessage(msg.id, (data) {
              if (data['ret'].toString() == '1') {
                Util.showToast('删除信息成功');
                ApplicationEvent.event.fire(ListRefreshEvent('refresh', index));
              }
            }, (message) {
              Util.showToast(message);
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return listComp.ListRefresh(
      renderItem: _buildMsgItem,
      more: loadMoreList,
      refresh: loadList,
      isCanRemoveCell: true,
    );
  }
}

class ClickItem extends StatelessWidget {
  const ClickItem({
    Key key,
    this.onTap,
    @required this.title,
    this.content: "",
    this.textAlign: TextAlign.start,
    this.style: AppText.textGray14,
    this.maxLines: 1,
    this.rightWidget = const Text(''),
    this.rightSmallWidget = const Icon(Icons.keyboard_arrow_right),
    this.hideArrow: false,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final String title;
  final String content;
  final TextAlign textAlign;
  final TextStyle style;
  final int maxLines;
  final Widget rightWidget;
  final Widget rightSmallWidget;
  final bool hideArrow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(15.0),
          constraints:
              BoxConstraints(maxHeight: double.infinity, minHeight: 50.0),
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColor.white,
              border: Border(
                bottom: Divider.createBorderSide(context,
                    color: AppColor.line, width: 1),
              )),
          child: Column(
            children: <Widget>[
              Row(
                //为了数字类文字居中
                crossAxisAlignment: maxLines == 1
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      flex: 13,
                      child: Text(
                        title,
                        style: AppText.textDark14,
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.topRight, child: rightWidget)),
                ],
              ),
              Row(
                //为了数字类文字居中
                crossAxisAlignment: maxLines == 1
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      flex: 13,
                      child: Text(
                        content,
                        style: AppText.textDark12,
                      )),
                ],
              ),
            ],
          )),
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
