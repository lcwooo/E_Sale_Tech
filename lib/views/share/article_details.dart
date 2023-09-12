import 'package:E_Sale_Tech/api/share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:fluwx/fluwx.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:E_Sale_Tech/views/login/public.dart';

class ArticleDetails extends StatefulWidget {
  final Map arguments;

  ArticleDetails({this.arguments});

  //ArticleDetails({Key key}) : super(key: key);

  @override
  _ArticleDetailsState createState() {
    return _ArticleDetailsState(arguments: arguments);
  }
}

class _ArticleDetailsState extends State<ArticleDetails> {
  final Map arguments;

  _ArticleDetailsState({this.arguments});

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: WebView(
        initialUrl: arguments['url'],
        javascriptMode: JavascriptMode.unrestricted,
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        //设置为白色字体
        iconTheme: IconThemeData(
          color: Colors.black, //修改颜色
        ),
        title: Text('文章详情页'),
        actions: <Widget>[
          IconButton(
            icon: new Image.asset(
              'assets/images/common/share_open.png',
              width: 24,
              height: 24,
            ),
            tooltip: "Alarm",
            onPressed: () {
              _modalBottomSheetMenu();
            },
          ),
        ],
      ),
    );
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 320.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: new Column(
                  children: <Widget>[
                    Container(
                      height: 80,
                      alignment: Alignment.center,
                      child: Text(
                        '选择要分享到的平台',
                        style: TextStyle(
                          color: HexToColor('#1C1717'),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new GestureDetector(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Image.asset(
                                  'assets/images/common/wechat_friends.png',
                                  width: 40,
                                  height: 40,
                                ),
                                Text('微信好友'),
                              ],
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              var bean = await ApiShare.share(arguments['id']);
                              // shareToWeChat(WeChatShareWebPageModel(
                              //     arguments['url'],
                              //     title: arguments['title'],
                              //     thumbnail:
                              //         WeChatImage.network(arguments['img']),
                              //     scene: WeChatScene.SESSION));
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          ),
                          new GestureDetector(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Image.asset(
                                  'assets/images/common/wechat_moments.png',
                                  width: 40,
                                  height: 40,
                                ),
                                Text('朋友圈'),
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              // shareToWeChat(WeChatShareWebPageModel(
                              //     arguments['url'],
                              //     title: arguments['title'],
                              //     thumbnail:
                              //         WeChatImage.network(arguments['img']),
                              //     scene: WeChatScene.TIMELINE));
                            },
                          )
                        ],
                      ),
                    ),
                    new GestureDetector(
                      child: Container(
                        height: 80,
                        alignment: Alignment.center,
                        child: Text(
                          '取消分享',
                          style: TextStyle(
                            color: HexToColor('#1C1717'),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                )),
          );
        });
  }
}
