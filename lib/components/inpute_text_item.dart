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
      this.leftFlex : 1,
      this.rightFlex : 3,
      this.height = 55.0});

  final String title;
  final int leftFlex;
  final int rightFlex;
  final Widget inputText;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double height;

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
            : const EdgeInsets.all(0),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                flex: widget.leftFlex,
                  child: Container(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  top: 15.0,
                  bottom: 15.0,
                ),
                child: Text(
                  widget.title,
                  style: AppText.textDark14,
                  textAlign: TextAlign.justify,
                ),
              )),
              Expanded(
                  flex: widget.rightFlex,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: widget.inputText,
                  ))
            ]));
  }
}
