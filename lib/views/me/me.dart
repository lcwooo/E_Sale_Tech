import 'package:E_Sale_Tech/api/me.dart';
import 'package:E_Sale_Tech/components/me_click_item.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/click_upload_image.dart';
import 'package:E_Sale_Tech/views/me/agent_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MePage extends StatefulWidget {
  MePage({this.arguments});
  final Map arguments;
  @override
  _MePageState createState() => new _MePageState();
}

class _MePageState extends State<MePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isLoading = false;

  final titleStyle = TextStyle(color: Color(0xff907D47), fontSize: 14);
  final titleValueStyle = TextStyle(color: Color(0xffe4382d), fontSize: 20);

  final subtitleStyle = TextStyle(color: Color(0xff999999));

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initShopInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initShopInfo() async {
    var data = await ApiMe.getAgentInfo();
    setState(() {
      Provider.of<AgentInfoProvider>(context, listen: false).setAgentInfo(data);
    });
  }

  Widget menuWidget(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Gaps.vGap5,
          MeClickItem(
            title: '我的资产',
            leftWidget: Container(
              width: ScreenUtil().setWidth(48),
              child: Image.asset(
                'assets/images/me/my_property@3x.png',
                width: ScreenUtil().setWidth(48),
              ),
            ),
            onTap: () {
              Routers.push('/me/myProperty', context);
            },
          ),
          MeClickItem(
              title: '我的地址',
              leftWidget: Container(
                width: ScreenUtil().setWidth(48),
                child: Image.asset(
                  'assets/images/me/my_address@3x.png',
                  width: ScreenUtil().setWidth(48),
                ),
              ),
              onTap: () {
                Routers.push('/me/myAddress', context);
                // _showUpdateDialog();
              }),
          // MeClickItem(
          //     title: '我的发票',
          //     leftWidget: Container(
          //       width: ScreenUtil().setWidth(48),
          //       child: Image.asset(
          //         'assets/images/me/my_invoice@3x.png',
          //         width: ScreenUtil().setWidth(48),
          //       ),
          //     ),
          //     onTap: () {
          //       Routers.push('/me/myInvoice', context);
          //     }),
          MeClickItem(
              title: '我的客服',
              leftWidget: Container(
                width: ScreenUtil().setWidth(48),
                child: Image.asset(
                  'assets/images/me/my_support@3x.png',
                  width: ScreenUtil().setWidth(48),
                ),
              ),
              onTap: () {
                Routers.push('/me/myCustomerService', context);
              }),
          MeClickItem(
              title: '我的消息',
              leftWidget: Container(
                width: ScreenUtil().setWidth(48),
                child: Image.asset(
                  'assets/images/me/my_msg@3x.png',
                  width: ScreenUtil().setWidth(48),
                ),
              ),
              onTap: () {
                Routers.push("/me/myMsg", context);
              }),
          MeClickItem(
              title: '完善资料',
              leftWidget: Container(
                width: ScreenUtil().setWidth(48),
                child: Image.asset(
                  'assets/images/me/complate_profile@3x.png',
                  width: ScreenUtil().setWidth(48),
                ),
              ),
              onTap: () {
                Routers.push("/me/myProfile", context);
              }),
          MeClickItem(
              title: '设置',
              leftWidget: Container(
                width: ScreenUtil().setWidth(48),
                child: Image.asset(
                  'assets/images/me/setting@3x.png',
                  width: ScreenUtil().setWidth(48),
                ),
              ),
              onTap: () {
                Routers.push("/me/setting", context);
              }),
          MeClickItem(
              title: '关于',
              leftWidget: Container(
                width: ScreenUtil().setWidth(48),
                child: Image.asset(
                  'assets/images/me/careabout@3x.png',
                  width: ScreenUtil().setWidth(48),
                ),
              ),
              onTap: () {
                Routers.push('/me/setting/aboutUs', context);
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.init(context,
        designSize: Size(750, 1334), allowFontScaling: false);
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      key: _scaffoldKey,
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/me/bg_banner.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(''),
                      ),
                      GestureDetector(
                        child: Container(
                          width: 60,
                          height: 60,
                          child: CachedNetworkImage(
                            imageUrl: Provider?.of<AgentInfoProvider>(context,
                                        listen: true)
                                    ?.agentInfo
                                    ?.avatar ??
                                '',
                            placeholder: (context, url) => const CircleAvatar(
                              backgroundColor: AppColor.bgGray,
                              radius: 60,
                            ),
                            imageBuilder: (context, image) => Container(
                                child: CircleAvatar(
                              backgroundImage: image,
                              backgroundColor: Colors.white,
                              radius: 60,
                            )),
                          ),
                        ),
                        onTap: () {
                          ClickUploadImage.showDemoActionSheet(
                            //成功回调
                            onSuccessCallback: (image) async {
                              if (image != null) {
                                ApiMe.updateAvatar({'avatar': image},
                                    (data) async {
                                  Provider.of<AgentInfoProvider>(context,
                                          listen: false)
                                      .getAgentInfo();
                                });
                              }
                            },
                            context: context,
                            child: CupertinoActionSheet(
                              title: const Text('请选择上传方式'),
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  child: const Text('相册'),
                                  onPressed: () {
                                    Navigator.pop(context, 'gallery');
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('照相机'),
                                  onPressed: () {
                                    Navigator.pop(context, 'camera');
                                  },
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text('取消'),
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context, 'Cancel');
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      Text('   '),
                      Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                  '${Provider?.of<AgentInfoProvider>(context, listen: true)?.agentInfo?.name ?? ''}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                              Text(
                                'ID ${Provider?.of<AgentInfoProvider>(context, listen: true)?.agentInfo?.id ?? ''}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
          menuWidget(context)
        ],
      )),
    );
  }
}
