import 'package:E_Sale_Tech/api/common.dart';
import 'package:E_Sale_Tech/views/login/login_config.dart';
import 'package:E_Sale_Tech/views/login/phone_country_code_entity.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';

class PhoneCode extends StatefulWidget {
  PhoneCode({Key key}) : super(key: key);

  @override
  _PhoneCodeState createState() {
    return _PhoneCodeState();
  }
}

class _PhoneCodeState extends State<PhoneCode> {
  List<Country> data;
  ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  List<String> letters = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getPhoneCodeDataList();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getPhoneCodeDataList() async {
    EasyLoading.show(status: '加载中...');
    var a = await Api.getShipments();
    List<Country> list = a['list'];
    for (int i = 0; i < list.length; i++) {
      letters.add(list[i].name);
    }
    setState(() {
      data = list;
    });
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PublicView().initBar('选择国家或地区'),
      body: Stack(
        children: <Widget>[
          data == null || data.length == 0
              ? Text("")
              : Padding(
                  padding: EdgeInsets.only(left: 0, right: 50),
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            PhoneCodeIndexName(data[index].name.toUpperCase()),
                            ListView.builder(
                                itemBuilder:
                                    (BuildContext context, int index2) {
                                  return Container(
                                    height: 46,
                                    width: MediaQuery.of(context).size.width,
                                    child: GestureDetector(
//                      behavior: HitTestBehavior.translucent,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                  "    ${data[index].listData[index2].name}",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: HexToColor(
                                                          '#1C1717'))),
                                              flex: 2,
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  "+${data[index].listData[index2].code}",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: HexToColor(
                                                          '#1C1717')),
                                                ),
                                              ),
                                              flex: 1,
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop(data[index]
                                                .listData[index2]
                                                .code +
                                            "=" +
                                            data[index].listData[index2].name);
                                      },
                                    ),
                                  );
                                },
                                itemCount: data[index].listData.length,
                                shrinkWrap: true,
                                physics:
                                    NeverScrollableScrollPhysics()) //禁用滑动事件),
                          ],
                        );
                      }),
                ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 30,
              height: double.parse((24 * letters.length).toString()),
              //alignment: Alignment.center,
              child: ListView.builder(
                itemCount: letters.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: new Container(
                      height: 24,
                      child: Text(
                        letters[index],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                      });
                      var height = index * 45.0;
                      for (int i = 0; i < index; i++) {
                        height += data[i].listData.length * 46.0;
                      }
                      _scrollController.jumpTo(height);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PhoneCodeIndexName extends StatelessWidget {
  String indexName;

  PhoneCodeIndexName(this.indexName);

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      width: MediaQuery.of(context).size.width,
      height: 45,
      color: HexToColor('#F5F5F5'),
      child: Padding(
        child: Text(indexName,
            style: TextStyle(fontSize: 20, color: Color(0xff434343))),
        padding: EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}
