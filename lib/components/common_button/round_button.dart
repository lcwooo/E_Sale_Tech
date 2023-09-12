import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key key,
    this.width,
    this.height = 50,
    this.margin,
    this.padding,
    this.radius,
    this.bgColor,
    this.highlightColor,
    this.splashColor,
    this.child,
    this.text,
    this.style,
    this.onPressed,
  }) : super(key: key);

  final double width;
  final double height;

  /// Empty space to surround the [decoration] and [child].
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  final double radius;
  final Color bgColor;
  final Color highlightColor;
  final Color splashColor;

  final Widget child;

  final String text;
  final TextStyle style;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Color _bgColor = bgColor ?? AppColor.main;
    BorderRadius _borderRadius = BorderRadius.circular(radius ?? (height / 2));
    return new Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: new BoxDecoration(
        border: new Border.all(color: _bgColor, width: 0.5), // 边色与边宽度
        borderRadius: _borderRadius,
      ),
      child: new Material(
        borderRadius: _borderRadius,
        color: _bgColor,
        child: new InkWell(
          borderRadius: _borderRadius,
          onTap: () => onPressed(),
          child: child ??
              new Center(
                child: new Text(
                  text,
                  style:
                      style ?? new TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: true)),
                ),
              ),
        ),
      ),
    );
  }
}
