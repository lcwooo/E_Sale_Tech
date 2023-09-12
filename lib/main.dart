// official
import 'dart:async';
import 'dart:io';

import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/model/shop/app_start_ad_indo.dart';
import 'package:E_Sale_Tech/views/me/agent_provider.dart';
import 'package:E_Sale_Tech/views/shop/shop_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// library
import 'package:provider/provider.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'generated/l10n.dart';

// page
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/model/index.dart';
import 'package:E_Sale_Tech/utils/localstorage.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/index.dart';
import 'package:E_Sale_Tech/utils/style.dart';
// import 'package:fluwx/fluwx.dart' as fluwx;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var token = await LocalStorage.getToken();
  var userName = await LocalStorage.getUserName();
  var environment = await LocalStorage.getEnvironment();
  var language = await LocalStorage.getLanguage();
  HttpClient.enableTimelineLogging = true;
  runApp(new MyApp(token, userName, environment, language));
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  configLoading();
  initWX();
}

void initWX() async {
  // await fluwx.registerWxApi(
  //     appId: "wx7babf31e1fa9b793",
  //     doOnAndroid: true,
  //     doOnIOS: true,
  //     universalLink: "https://esale.nle-tech.com/app/");
  // var result = await fluwx.isWeChatInstalled;
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.cubeGrid
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.yellow
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true;
}

class MyApp extends StatefulWidget {
  final String token;

  final String userName;

  final String environment;

  final String language;

  MyApp(this.token, this.userName, this.environment, this.language);

  @override
  _MyAppState createState() =>
      _MyAppState(this.token, this.userName, this.environment, this.language);
}

class _MyAppState extends State<MyApp> {
  final String token;
  Locale _locale = Locale('zh', 'CN');
  final String userName;
  final String environment;
  final String language;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _MyAppState(this.token, this.userName, this.environment, this.language) {
    //监听事件
    final eventBus = new EventBus(sync: true);
    ApplicationEvent.event = eventBus;
  }

  @override
  void initState() {
    super.initState();
    initLanguage();

    ApplicationEvent.event.on<ChangeLanguage>().listen((event) {
      onLocaleChange(event.local);
    });
  }

  initLanguage() {
    var languageArr = this.language.split('_');
    setState(() {
      _locale = Locale(languageArr[0], languageArr[1]);
    });
  }

  onLocaleChange(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  loadPage() {
    return MasterPage();
  }

  PageTransitionsBuilder createTransition() {
    return CupertinoPageTransitionsBuilder();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => Model(token, userName, environment)),
        ChangeNotifierProvider(create: (_) => ShopInfoProvider()),
        ChangeNotifierProvider(create: (_) => AgentInfoProvider()),
      ],
      child: Consumer<Model>(
        builder: (context, model, widget) {
          return MaterialApp(
            builder: (BuildContext context, Widget child) {
              return Material(
                  child: FlutterEasyLoading(
                child: child,
              ));
            },
            color: Colors.white,
            theme: ThemeData(
              pageTransitionsTheme: PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.iOS: createTransition(),
                  TargetPlatform.android: createTransition(),
                },
              ),
              primaryColor: AppColor.themeRed,
              backgroundColor: Colors.white,
              canvasColor: Colors.white,
            ),
            // 监听路由跳转
            onGenerateRoute: (RouteSettings settings) {
              return Routers.run(settings);
            },
            showSemanticsDebugger: false,
            debugShowCheckedModeBanner: false,
            home:
                //  Scaffold(
                //         key: _scaffoldKey,
                //         backgroundColor: Colors.white,
                //         resizeToAvoidBottomInset: false,
                //         body: loadPage(),
                //       ),
                SplashScreen(),
            routes: <String, WidgetBuilder>{
              '/main': (BuildContext context) => Scaffold(
                    key: _scaffoldKey,
                    backgroundColor: Colors.white,
                    resizeToAvoidBottomInset: false,
                    body: loadPage(),
                  )
            },
            locale: _locale,
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  startTime() async {
    //设置启动图生效时间
    var _duration = new Duration(seconds: 3);
    _timer = new Timer(_duration, navigationPage);
    return _timer;
  }

  void navigationPage() {
    _timer.cancel();
    Navigator.of(context).pushReplacementNamed('/main');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: new Image.asset(
          "assets/images/common/LaunchImage@2x.png",
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => new _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   Timer _timer;
//   int count = 3;
//   AppStartAd appStartAd = new AppStartAd();
//   bool isRequest = false;

//   startTime() async {
//     var _duration = new Duration(seconds: 1);
//     new Timer(_duration, () {
//       _timer = new Timer.periodic(const Duration(milliseconds: 1000), (v) {
//         count--;
//         if (count == 0) {
//           navigationPage();
//           // MasterPage();
//         } else {
//           setState(() {});
//         }
//       });
//       return _timer;
//     });
//   }

//   void navigationPage() {
//     _timer?.cancel();
//     Navigator?.of(context)?.pushReplacementNamed('/main');
//   }

//   @override
//   void initState() {
//     super.initState();
//     getStartImage();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _timer?.cancel();
//   }

//   getStartImage() {
//     Timer.periodic(const Duration(seconds: 7), (timer) {
//       if (!isRequest) {
//         navigationPage();
//       }
//     });
//     ApiShop.getAppStartImage((data) {
//       if (mounted) {
//         setState(() {
//           appStartAd = data;
//           isRequest = true;
//         });
//       }
//       startTime();
//     }, (message) {
//       startTime();
//       if (mounted) {
//         setState(() {
//           isRequest = true;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         GestureDetector(
//             onTap: () {
//               // if (!isRequest) return;
//               // Navigator.of(context).pushReplacementNamed('/main');
//               // Routers.push('/goodsDetailPage', context,
//               //     {"goodsId": appStartAd.linkPath});
//             },
//             child: ConstrainedBox(
//               constraints: BoxConstraints.expand(),
//               child: CachedNetworkImage(
//                 useOldImageOnUrlChange: true,
//                 imageUrl: appStartAd.path,
//                 placeholder: (context, url) => Image.asset(
//                   'assets/images/common/LaunchImage@2x.png',
//                 ),
//                 imageBuilder: (context, image) => Container(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: image,
//                     ),
//                   ),
//                 ),
//               ),
//             )),
//         // Positioned(
//         //     bottom: 10,
//         //     right: 10,
//         //     child: Opacity(
//         //         opacity: isRequest ? 1 : 0,
//         //         child: GestureDetector(
//         //             onTap: () {
//         //               navigationPage();
//         //             },
//         //             child: Container(
//         //                 width: 80,
//         //                 alignment: Alignment.center,
//         //                 padding: EdgeInsets.all(6.0),
//         //                 child: new Text(
//         //                   ' $count 跳过广告',
//         //                   style: new TextStyle(
//         //                       fontSize: 12.0, color: Colors.white),
//         //                 ),
//         //                 decoration: new BoxDecoration(
//         //                   color: Color(0x66000000),
//         //                   borderRadius: BorderRadius.all(Radius.circular(60.0)),
//         //                 )))))
//       ],
//     );
//   }
// }

// class RestartWidget extends StatefulWidget {
//   final Widget child;

//   RestartWidget({Key key, @required this.child})
//       : assert(child != null),
//         super(key: key);

//   static restartApp(BuildContext context) {
//     final _RestartWidgetState state = context.findAncestorStateOfType();
//     state.restartApp();
//   }

//   @override
//   _RestartWidgetState createState() => _RestartWidgetState();
// }

// class _RestartWidgetState extends State<RestartWidget> {
//   Key key = UniqueKey();

//   void restartApp() {
//     setState(() {
//       key = UniqueKey();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       key: key,
//       child: widget.child,
//     );
//   }
// }
