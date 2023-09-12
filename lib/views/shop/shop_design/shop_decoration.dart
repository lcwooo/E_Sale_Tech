import 'package:E_Sale_Tech/components/skeloton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';

enum SingingCharacter { normal, senior }

class ShopDecoration extends StatefulWidget {
  @override
  _ShopDecorationState createState() => _ShopDecorationState();
}

class _ShopDecorationState extends State<ShopDecoration> {
  String version = "";

  final subtitleStyle = TextStyle(color: Color(0xff999999));

  SingingCharacter _character = SingingCharacter.normal;

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffF8F8F8),
      appBar: MyAppBar(
        centerTitle: '店铺装修',
      ),
      body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(14),
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('请选择店铺模板'))),
                  Row(
                    children: <Widget>[
                      Expanded(
                          flex: 5,
                          child: GestureDetector(
                              onTap: () {
                                Routers.push(
                                    '/shop/shopDesign/shopDecoration/shopTemplate',
                                    context);
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 80,
                                    margin: EdgeInsets.only(right: 7),
                                    color: Color(0xffe4382d),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Image.asset(
                                                'assets/images/shop/white_house@3x.png',
                                                width: 24,
                                                height: 24)),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  '店铺名称',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    padding: EdgeInsets.only(
                                                        left: 5, right: 5),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFFFFFFFF))),
                                                    child: Text('认证',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 9))),
                                                // Text('店铺签名'),
                                              ],
                                            ),
                                            Text('店铺签名',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(right: 7),
                                      padding:
                                          EdgeInsets.only(left: 5, right: 5),
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text('最新商品'))),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                  flex: 5,
                                                  child: Container(
                                                    height: 85.5,
                                                    margin: EdgeInsets.only(
                                                        right: 2.5),
                                                    color: Color(0xffF8F8F8),
                                                    child: Image.asset(
                                                        'assets/images/shop/white_gift@3x.png',
                                                        width: 12,
                                                        scale: 2,
                                                        height: 12),
                                                  )),
                                              Expanded(
                                                  flex: 5,
                                                  child: Container(
                                                    height: 85.5,
                                                    margin: EdgeInsets.only(
                                                        left: 2.5),
                                                    color: Color(0xffF8F8F8),
                                                    child: Image.asset(
                                                        'assets/images/shop/white_gift@3x.png',
                                                        width: 12,
                                                        scale: 2,
                                                        height: 12),
                                                  )),
                                            ],
                                          ),
                                          Skeleton.skeletonSubscription(
                                              left: 2.5, right: 20.0),
                                          Skeleton.skeletonSubscription(),
                                          Container(
                                              margin: EdgeInsets.only(top: 15),
                                              child: Text('通用模板')),
                                          Radio(
                                            activeColor: Color(0xffe4382d),
                                            value: SingingCharacter.normal,
                                            groupValue: _character,
                                            onChanged:
                                                (SingingCharacter value) {
                                              setState(() {
                                                _character = value;
                                              });
                                            },
                                          )
                                        ],
                                      )),
                                ],
                              ))),
                      Expanded(
                          flex: 5,
                          child: Column(
                            children: <Widget>[
                              // Container(
                              //   height: 80,
                              //   margin: EdgeInsets.only(right: 7),
                              //   color: Color(0xffe4382d),
                              //   child: Row(
                              //     children: <Widget>[
                              //       Container(
                              //           margin: EdgeInsets.only(
                              //               left: 10, right: 10),
                              //           child: Image.asset(
                              //               'assets/images/shop/white_house@3x.png',
                              //               width: 24,
                              //               height: 24)),
                              //       Column(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.center,
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //         children: <Widget>[
                              //           Row(
                              //             children: <Widget>[
                              //               Text(
                              //                 '店铺名称',
                              //                 style: TextStyle(
                              //                     color: Colors.white,
                              //                     fontSize: 14),
                              //               ),
                              //             ],
                              //           ),
                              //           Text('店铺签名',
                              //               style: TextStyle(
                              //                   color: Colors.white,
                              //                   fontSize: 12)),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Container(
                              //     margin: EdgeInsets.only(right: 7),
                              //     padding: EdgeInsets.only(left: 5, right: 5),
                              //     color: Colors.white,
                              //     child: Column(
                              //       children: <Widget>[
                              //         Padding(
                              //             padding: EdgeInsets.only(
                              //                 top: 5, bottom: 5),
                              //             child: Align(
                              //                 alignment: Alignment.centerLeft,
                              //                 child: Text('最新商品'))),
                              //         Row(
                              //           children: <Widget>[
                              //             Expanded(
                              //                 flex: 5,
                              //                 child: Container(
                              //                   height: 85.5,
                              //                   margin:
                              //                       EdgeInsets.only(right: 2.5),
                              //                   color: Color(0xffF8F8F8),
                              //                   child: Image.asset(
                              //                       'assets/images/shop/white_gift@3x.png',
                              //                       width: 12,
                              //                       scale: 2,
                              //                       height: 12),
                              //                 )),
                              //             Expanded(
                              //                 flex: 5,
                              //                 child: Container(
                              //                   height: 85.5,
                              //                   margin:
                              //                       EdgeInsets.only(left: 2.5),
                              //                   // color: Color(0xffF8F8F8),
                              //                   child: Column(
                              //                     children: <Widget>[
                              //                       Skeleton.skeletonTitle(
                              //                           right: 0.0, left: 0.0),
                              //                       Skeleton.skeletonSubscription(
                              //                           left: 0.0, right: 0.0),
                              //                       Skeleton.skeletonSubscription(
                              //                           left: 0.0, right: 0.0),
                              //                     ],
                              //                   ),
                              //                 )),
                              //           ],
                              //         ),
                              //         Skeleton.skeletonSubscription(display: true),
                              //         Skeleton.skeletonSubscription(display: true),
                              //         Container(
                              //             margin: EdgeInsets.only(top: 15),
                              //             child: Text('高级模板')),
                              //         Radio(
                              //           activeColor: Color(0xffe4382d),
                              //           value: SingingCharacter.senior,
                              //           groupValue: _character,
                              //           onChanged: (SingingCharacter value) {
                              //             setState(() {
                              //               _character = value;
                              //             });
                              //           },
                              //         )
                              //       ],
                              //     ))
                            ],
                          )),
                    ],
                  )
                ],
              ))),
    );
  }
}
