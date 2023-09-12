import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/utils/style.dart';

class ReadonlyTextItem extends StatefulWidget {
  const ReadonlyTextItem(
      {Key key,
      @required this.fieldName,
      @required this.fieldValue,
      this.onTap,
      this.height = 50,
      this.margin = const EdgeInsets.only(left: 16.0),
      this.padding = const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
      });

  final String fieldName;
  final String fieldValue;
  final GestureTapCallback onTap;
  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;

  @override
  _ReadonlyTextItemState createState() => _ReadonlyTextItemState();
}

class _ReadonlyTextItemState extends State<ReadonlyTextItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: widget.padding,
        margin: widget.margin,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(
          bottom: Divider.createBorderSide(context,
              color: AppColor.line, width: 0.6),
        )),
        child: InkWell(
            onTap: this.widget.onTap is GestureTapCallback
                ? this.widget.onTap
                : () {},
            child: Flex(direction: Axis.horizontal, children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Text(
                      widget.fieldName,
                      style: AppText.textDark14,
                      textAlign: TextAlign.justify,
                    ),
                  )),
              Expanded(
                  flex: 3,
                  child: Container(
                    // padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      widget.fieldValue,
                      style: AppText.textDark14,
                      textAlign: TextAlign.justify,
                    ),
                  ))
            ])));
  }
}