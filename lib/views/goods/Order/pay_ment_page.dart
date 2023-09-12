import 'package:E_Sale_Tech/model/goods/orderPreviewDetail.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:E_Sale_Tech/routers/routers.dart';

// import 'package:fluwx/fluwx.dart' as fluwx;
// import 'package:fluwx/fluwx.dart';

class PayMentPage extends StatefulWidget {
  PayMentPage({this.arguments});
  final Map arguments;
  @override
  _PayMentPageState createState() =>
      new _PayMentPageState(arguments: arguments);
}

class _PayMentPageState extends State<PayMentPage>
    with AutomaticKeepAliveClientMixin {
  final Map arguments;
  _PayMentPageState({this.arguments});
  @override
  bool get wantKeepAlive => true;
  OrderPreviewDetail orderPreviewData;
  Map appconfig;
  bool isLoading = false;
  String _newValue = '1';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    print(this.arguments);
    setState(() {
      isLoading = true;
      orderPreviewData = this.arguments["orderData"];
      appconfig = this.arguments["appconfig"];
      _newValue = orderPreviewData.paymentList.first.id.toString();
    });
    // life circle
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: MyAppBar(
        centerTitle: "确认付款",
        isBack: true,
        backToRoot: true,
        backBtnPress: () {
          Navigator.popAndPushNamed(context, '/shop/orderManager');
        },
      ),
      body: new Column(
        children: <Widget>[
          buildHeadPriceView(),
          buildBottomView(),
          buildGroupedCheckBox()
        ],
      ),
      bottomNavigationBar: Material(
        //底部栏整体的颜色
        color: AppColor.themeRed,
        child: FlatButton(
          child: new Padding(
            padding: new EdgeInsets.all(0),
            child: Text("确认支付",
                style: TextStyle(
                    color: AppColor.mainTextColor,
                    fontWeight: FontWeight.w300)),
          ),
          color: AppColor.themeRed,
          onPressed: () async {
            // fluwx.isWeChatInstalled.then((installed) {
            //   if (installed) {
            //     fluwx
            //         .payWithWeChat(
            //       appId: appconfig['appid'],
            //       partnerId: appconfig['partnerid'],
            //       prepayId: appconfig['prepayid'],
            //       packageValue: appconfig['package'],
            //       nonceStr: appconfig['noncestr'],
            //       timeStamp: appconfig['timestamp'],
            //       sign: appconfig['sign'],
            //     )
            //         .then((data) {
            //       print("pay then result: $data");
            //     });
            //     Navigator.pushNamedAndRemoveUntil(
            //         context, '/main', (route) => false);
            //     Routers.push('/shop/orderManager', context);
            //   } else {
            //     Util.showToast("请先安装微信");
            // }
            // });
          },
        ),
      ),
    );
  }

  Widget buildGroupedCheckBox() {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          itemCount: orderPreviewData.paymentList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return _returnLietCell(orderPreviewData.paymentList[index]);
          }),
    );
  }

  _returnLietCell(PaymentList payMent) {
    return Center(
      child: RadioListTile<String>(
        value: payMent.id.toString(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              "assets/images/common/weChat.png",
              width: 30,
              height: 30,
            ),
            SizedBox(width: 10),
            Text(payMent.name)
          ],
        ),
        activeColor: Colors.red,
        groupValue: _newValue,
        onChanged: (value) {
          setState(() {
            _newValue = value;
          });
        },
      ),
    );
  }

  Widget buildBottomView() {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 15),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "付款方式",
                style: TextStyle(color: Color(0xFF5A5A5A), fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeadPriceView() {
    return Container(
      color: Colors.white,
      height: 150,
      padding: EdgeInsets.only(top: 40),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "付款金额",
                style: TextStyle(color: Color(0xFF656565), fontSize: 15),
              ),
            ],
          ),
          Gaps.vGap12,
          Gaps.vGap12,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "￥" +
                    (orderPreviewData.itemFee + orderPreviewData.taxFee)
                        .toStringAsFixed(2),
                style: TextStyle(
                    color: AppColor.mainTextColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w600),
              ),
            ],
          )
        ],
      ),
    );
  }
}
