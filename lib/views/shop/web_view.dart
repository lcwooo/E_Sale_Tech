import 'dart:core';

import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage({this.arguments});
  final Map arguments;
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage>
    with TickerProviderStateMixin {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  WebViewController _webViewController;
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
    Map map = widget.arguments;
    var url = map["url"];
    var title = map["title"];
    return new Scaffold(
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: ((WebViewController vc) {
          _webViewController = vc;
        }),
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
        title: Text(title),
      ),
    );
    //     new WebviewScaffold(
    //   url: widget.arguments["url"],
    //   appBar: new MyAppBar(
    //     centerTitle: 'Q&A答疑',
    //   ),
    //   withZoom: true,
    //   withLocalStorage: true,
    //   hidden: true,
    //   useWideViewPort: true,
    //   displayZoomControls: true,
    //   withOverviewMode: true,
    //   withJavascript: true,
    //   initialChild: Container(
    //     child: const Center(
    //       child: Text('加载中...', style: AppText.textGray14),
    //     ),
    //   ),
    // );
  }
}
