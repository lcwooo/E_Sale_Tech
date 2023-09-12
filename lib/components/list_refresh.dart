import 'package:E_Sale_Tech/api/me.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/model/me/agent_msg_list.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:E_Sale_Tech/components/loading.dart';
import 'package:flutter/foundation.dart';

class ListRefresh extends StatefulWidget {
  final renderItem;
  final headerView;
  final Function refresh;
  final Function more;
  final IndexedWidgetBuilder separator;
  final bool gridView;
  final String listType;
  final bool isCanRemoveCell;

  ListRefresh(
      {@required this.renderItem,
      this.headerView,
      this.gridView,
      this.isCanRemoveCell = false,
      this.listType = 'ListView',
      @required this.refresh,
      @required this.more,
      this.separator});

  @override
  State<StatefulWidget> createState() => _ListRefreshState();
}

class _ListRefreshState extends State<ListRefresh> {
  bool _isLoading = true; // 是否正在请求数据中
  bool _hasMore = true; // 是否还有更多数据可加载
  int _deleteIndex; // 待删除item索引
  int currentIndex;
  final dynamic _items = [];
  final ScrollController _scrollCtrl = ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  _refresh({String type = ''}) async {
    if (!mounted) {
      return;
    }
    final data = await widget.refresh(type: type);
    _refreshController.resetNoData();
    if (data != null) {
      _items.clear();
      if (!mounted) {
        return;
      }
      setState(() {
        _hasMore = data != null && data["list"] != null;
        if (_hasMore) {
          _items.addAll(data["list"]);
        }
        _hasMore = data['total'] - data['pageIndex'] == 0 ? false : true;
        if (_hasMore) {
          _refreshController.loadComplete();
        } else {
          _refreshController.loadNoData();
        }
      });
    }
    _isLoading = false;
    _refreshController.refreshCompleted();
  }

  _more() async {
    if (!mounted) {
      return;
    }
    final data = await widget.more();
    setState(() {
      _hasMore = data["list"] != null;
      if (_hasMore) {
        _items.addAll(data["list"]);
      }
      _hasMore = data['total'] - data['pageIndex'] == 0 ? false : true;
      if (_hasMore) {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.refresh is! Function) {
      throw ArgumentError("has no refresh function");
    }
    this._refresh();
    ApplicationEvent.event.on<ListRefreshEvent>().listen((event) {
      if (event.type == 'delete') {
        if (!mounted) {
          return;
        }
        setState(() {
          this._deleteIndex = event.index;
          _items.removeAt(this._deleteIndex);
        });
      } else if (event.type == 'operate') {
        setState(() {
          this.currentIndex = event.index;
          _items[event.index].isRead = event.value;
        });
      } else if (event.type == 'refresh') {
        this._refresh();
      } else if (event.type == 'reset') {
        this._refresh(type: 'reset');
      }
    });
  }

  Widget _buildProgressIndicator() {
    return SingleChildScrollView(
        child: ConstrainedBox(
            child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                    child: Column(children: <Widget>[
                  Opacity(
                    opacity: 1.0,
                    child: CupertinoActivityIndicator(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      '正在加载...',
                      style: AppText.textGray14,
                    ),
                  )
                ]))),
            constraints: BoxConstraints(minHeight: 50)));
  }

  IndexedWidgetBuilder _itemBuilder() {
    return (context, index) {
      if (widget.renderItem is Function) {
        return widget.isCanRemoveCell
            ? Dismissible(
                key: UniqueKey(),
                onDismissed: (msd) {
                  //参数暂时没有用到，则用下划线表示
                  // widget.
                  // Scaffold.of(context).showSnackBar(
                  //     new SnackBar(content: new Text("item dismissed")));
                  // print(msd);
                  // AgentMsgList msgList = _items[index];
                  // ApiMe.deleteMessage(msgList.id, (data) {
                  //   if (data['ret'].toString() == '1') {
                  //     Util.showToast('删除信息成功');
                  //     ApplicationEvent.event
                  //         .fire(ListRefreshEvent('refresh', index));
                  //   }
                  // }, (message) {
                  //   Util.showToast(message);
                  // });
                },
                background: Container(
                    padding: EdgeInsets.only(right: 15),
                    color: Color(0xffff0000),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '删除',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                      ],
                    )),
                // 监听
                movementDuration: Duration(milliseconds: 100),
                child: widget.renderItem(index, _items[index]))
            : widget.renderItem(index, _items[index]);
      } else {
        throw ArgumentError("renderItem is not function");
      }
    };
  }

  Widget get _child {
    switch (widget.listType) {
      case 'GirdView':
        return GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //一行的Widget数量
              childAspectRatio: 0.8,
            ),
            itemCount: _items.length,
            itemBuilder: _itemBuilder());
      default:
        return ListView.builder(
            itemCount: _items.length,
            cacheExtent: 0,
            itemBuilder: _itemBuilder(),
            controller: _scrollCtrl);
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  Widget _empty() {
    return Center(child: Text("暂无数据"));
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
        onNotification: (ScrollNotification note) {
          FocusScope.of(context).requestFocus(FocusNode());
          return false;
        },
        child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: ClassicHeader(
              refreshingIcon: CupertinoActivityIndicator(),
              height: 45.0,
              releaseText: '松开手刷新',
              refreshingText: '刷新中',
              completeText: '刷新完成',
              failedText: '刷新失败',
              idleText: '下拉刷新',
            ),
            footer: CustomFooter(
              height: _items.length < 10 ? 0 : 60,
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text(
                    "上拉加载",
                    style: AppText.textGray14,
                  );
                } else if (mode == LoadStatus.loading) {
                  body = _buildProgressIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text(
                    "加载失败！点击重试！",
                    style: AppText.textGray14,
                  );
                } else if (mode == LoadStatus.canLoading) {
                  body = Text(
                    "松手,加载更多!",
                    style: AppText.textGray14,
                  );
                } else {
                  body = Text(
                    "没有更多数据了!",
                    style: AppText.textGray14,
                  );
                }

                return Container(
                  height: _items.length < 10 ? 0 : 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: _refreshController,
            onRefresh: this._refresh,
            onLoading: this._more,
            child: _isLoading
                ? _buildProgressIndicator()
                : (_items.length == 0 ? _empty() : _child)));
  }
}
