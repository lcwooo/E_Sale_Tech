import 'package:flutter/material.dart';

class Skeleton {
  static Widget skeletonSubscription({right: 2.5, left: 2.5, display: false}) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 5,
            child: Container(
              height: 7.5,
              margin: EdgeInsets.only(top: 5, right: right),
              color: display ? Colors.white : Color(0xffF8F8F8),
              child: Text(''),
            )),
        Expanded(
            flex: 5,
            child: Container(
              height: 7.5,
              margin: EdgeInsets.only(top: 5, left: left, right: right),
              color: display ? Colors.white : Color(0xffF8F8F8),
              child: Text(''),
            )),
      ],
    );
  }

  static Widget skeletonTitle({dynamic right: 2.5, dynamic left: 2.5}) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 2,
            child: Container(
              height: 7.5,
              margin: EdgeInsets.only(top: 5, right: right),
              color: Color(0xffF8F8F8),
              child: Text(''),
            )),
        Expanded(
            flex: 3,
            child: Container(
              height: 7.5,
              margin: EdgeInsets.only(top: 5, right: right),
              color: Color(0xffF8F8F8),
              child: Text(''),
            )),
        Expanded(
            flex: 2,
            child: Container(
              height: 7.5,
              margin: EdgeInsets.only(top: 5, left: left),
              color: Color(0xffF8F8F8),
              child: Text(''),
            )),
        Expanded(
            flex: 3,
            child: Container(
              height: 7.5,
              margin: EdgeInsets.only(top: 5, right: right),
              child: Text(''),
            )),
      ],
    );
  }
}
