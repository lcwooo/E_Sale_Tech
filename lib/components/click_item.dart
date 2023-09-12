import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/utils/style.dart';

class ClickItem extends StatelessWidget {
  const ClickItem({
    Key key,
    this.onTap,
    @required this.title,
    this.content: "",
    this.textAlign: TextAlign.start,
    this.style: AppText.textGray14,
    this.maxLines: 1,
    this.rightWidget = const Text(''),
    this.rightSmallWidget = const Icon(Icons.keyboard_arrow_right),
    this.hideArrow: false,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final String title;
  final String content;
  final TextAlign textAlign;
  final TextStyle style;
  final int maxLines;
  final Widget rightWidget;
  final Widget rightSmallWidget;
  final bool hideArrow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        constraints:
            BoxConstraints(maxHeight: double.infinity, minHeight: 50.0),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(
          bottom:
              Divider.createBorderSide(context, color: AppColor.line, width: 1),
        )),
        child: Row(
          //为了数字类文字居中
          crossAxisAlignment: maxLines == 1
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: AppText.textDark14,
            ),
            const Spacer(),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 16.0),
                child: Text(
                  content,
                  maxLines: maxLines,
                  textAlign: maxLines == 1 ? TextAlign.right : textAlign,
                  overflow: TextOverflow.ellipsis,
                  style: style ?? AppText.textDark14,
                ),
              ),
            ),
            Expanded(
                flex: 8,
                child:
                    Align(alignment: Alignment.topRight, child: rightWidget)),
            Opacity(
              // 无点击事件时，隐藏箭头图标
              opacity: onTap == null || hideArrow ? 0 : 1,
              child: Padding(
                padding: EdgeInsets.only(top: maxLines == 1 ? 0.0 : 2.0),
                child: rightSmallWidget,
              ),
            )
          ],
        ),
      ),
    );
  }
}
