import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:E_Sale_Tech/utils/style.dart';

class InputTextItem extends StatefulWidget {
  const InputTextItem(
      {Key key,
      @required this.title,
      @required this.inputText,
      this.padding,
      this.margin,
      this.hideArrow: false,
      this.rightWidget = const Icon(Icons.keyboard_arrow_right),
      this.height = 55.0});

  final String title;
  final Widget inputText;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double height;
  final Widget rightWidget;
  final bool hideArrow;

  @override
  _InputTextItemState createState() => _InputTextItemState();
}

class _InputTextItemState extends State<InputTextItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        padding: (widget.padding is EdgeInsets)
            ? widget.padding
            : const EdgeInsets.all(15),
        margin: (widget.margin is EdgeInsets)
            ? widget.margin
            : const EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(
          bottom:
              Divider.createBorderSide(context, color: AppColor.line, width: 1),
        )),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                    // padding: EdgeInsets.all(15),
                    child: Text(
                      widget.title,
                      style: AppText.textDark14,
                      textAlign: TextAlign.justify,
                    ),
                  )),
              Expanded(
                  flex: 8,
                  child: Container(
                    child: widget.inputText,
                  )),
              Opacity(
                // 无点击事件时，隐藏箭头图标
                opacity: widget.hideArrow ? 1 : 0,
                child: Padding(
                  padding: EdgeInsets.only(right: 0.0),
                  child: widget.rightWidget,
                ),
              )
            ]));
  }
}
