import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/model/shop/order_detail_tracking.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/utils/time_axis.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OrderManagerLogisticsDetail extends StatefulWidget {
  final Map arguments;
  OrderManagerLogisticsDetail({this.arguments});

  @override
  _OrderManagerLogisticsDetailState createState() =>
      _OrderManagerLogisticsDetailState();
}

class _OrderManagerLogisticsDetailState
    extends State<OrderManagerLogisticsDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final addressTextStyle =
      new TextStyle(color: Color(0xff1C1717), fontSize: 15);

  final ScrollController _scrollCtrl = ScrollController();
  OrdersDetailTracking trackingInfo = OrdersDetailTracking();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getTracking();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getTracking() {
    EasyLoading.show(status: '加载中...');
    ApiShop.getOrdersDetailTracking(this.widget.arguments['id'].toString(),
        (data) {
      EasyLoading.dismiss();
      if (data == "没有数据") {
        return;
      }
      setState(() {
        trackingInfo = data;
      });
    }, (message) => EasyLoading.dismiss());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xffF8F8F8),
        appBar: MyAppBar(
          centerTitle: "物流详情",
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Align(alignment: Alignment.centerLeft, child: Text('物流信息')),
                    Container(
                        margin: EdgeInsets.only(bottom: 5, top: 5),
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(right: 15.5),
                                child: Text(
                                  '快递公司',
                                  style: TextStyle(color: Color(0xff999999)),
                                )),
                            Text(trackingInfo?.company ?? ''),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(right: 15.5),
                                child: Text(
                                  '物流单号',
                                  style: TextStyle(color: Color(0xff999999)),
                                )),
                            GestureDetector(
                                onTap: () {
                                  ClipboardData data = new ClipboardData(
                                      text: trackingInfo?.number ?? '');
                                  Clipboard.setData(data);
                                  Util.showToast("单号复制成功");
                                },
                                child: Text(trackingInfo?.number ?? '')),
                          ],
                        )),
                  ],
                )),
            Container(
              padding: EdgeInsets.only(top: 20),
              color: Colors.white,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: trackingInfo?.trackingData?.length ?? 0,
                controller: _scrollCtrl,
                itemBuilder: (context, index) {
                  return PaintCirLineItem(
                    12,
                    index,
                    listLength: trackingInfo?.trackingData?.length,
                    leftWidget: Container(
                      width: 12.0,
                      height: 12.0,
                      decoration: BoxDecoration(
                        color:
                            index == 0 ? Color(0xffe4382d) : Color(0xffA2A2A2),
                        border: Border.all(
                          color: index == 0
                              ? Color(0xffe4382d)
                              : Color(0xffA2A2A2),
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    isDash: false,
                    marginLeft: 25,
                    contentLeft: 20,
                    leftLineColor: Color(0xffEDEDED),
                    alignment: Alignment.centerLeft,
                    cententWight: Container(
                        transform: Matrix4.translationValues(0.0, -15.0, 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(trackingInfo?.trackingData[index]?.context ??
                                ''),
                            Text(trackingInfo?.trackingData[index]?.time ?? ''),
                          ],
                        )),
                    timeAxisLineWidth: 1,
                  );
                },
              ),
            )
          ],
        )));
  }
}
