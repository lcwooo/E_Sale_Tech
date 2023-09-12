import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RaisedButtonCustom extends StatelessWidget {
  final String txt;
  final Color color;
  final Color splashColor;
  final Color textColor;
  final ShapeBorder shape;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final bool isRequest;
  final double elevation;
  final TextStyle textStyle;

  const RaisedButtonCustom(
      {this.txt = '自定义按钮', // 按钮文字
      this.textStyle = const TextStyle(color: AppColor.themeRed),
      this.color = Colors.blueAccent, //按钮颜色
      this.textColor = Colors.white, // 按钮文字颜色
      this.splashColor, // 按钮点击的水波纹颜色
      this.shape, // 边框etc...
      this.onPressed, // 点击事件
      this.elevation = 0, // 阴影
      this.padding =
          const EdgeInsets.only(bottom: 5.0, top: 5.0, left: 30.0, right: 30.0),
      this.isRequest = false})
      : super();
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        // 文本内容
        child: isRequest
            ? Container(
                width: 30,
                child: SpinKitRing(
                  color: AppColor.themeRed,
                  size: 16,
                  lineWidth: 3,
                ))
            : Text(txt,
                style: onPressed != null
                    ? textStyle
                    : TextStyle(color: Colors.white),
                semanticsLabel: 'FLAT BUTTON 2'),
        // child: Text(txt, semanticsLabel: 'FLAT BUTTON 2'),
        // 按钮颜色
        color: onPressed != null ? color : Colors.white,
        elevation: elevation,
        // 按钮亮度
        colorBrightness: Brightness.dark,
        // 高亮时的背景色
        // highlightColor: Theme.of(context).primaryColor,
        // 失效时的背景色
        disabledColor: Colors.transparent,
        disabledElevation: 0,
        // 该按钮上的文字颜色，但是前提是不设置字体自身的颜色时才会起作用
        textColor: textColor,
        // 按钮失效时的文字颜色，同样的不能使用文本自己的样式或者颜色时才会起作用
        disabledTextColor: Colors.white,
        // 按钮主题,主要用于与ButtonTheme和ButtonThemeData一起使用来定义按钮的基色,RaisedButton，RaisedButton，OutlineButton，它们是基于环境ButtonTheme配置的
        //ButtonTextTheme.accent，使用模版颜色的;ButtonTextTheme.normal，按钮文本是黑色或白色取决于。ThemeData.brightness;ButtonTextTheme.primary，按钮文本基于。ThemeData.primaryColor.
        textTheme: ButtonTextTheme.normal,
        // 按钮内部,墨汁飞溅的颜色,点击按钮时的渐变背景色，当你不设置高亮背景时才会看的更清楚
        splashColor: splashColor,
        // 抗锯齿能力,抗锯齿等级依次递增,none（默认),hardEdge,antiAliasWithSaveLayer,antiAlias
        clipBehavior: Clip.antiAlias,
        padding: padding,
        shape: (shape is ShapeBorder)
            ? shape
            : Border.all(
                // 设置边框样式
                color: Colors.grey,
                width: 1.5,
                style: BorderStyle.none,
              ),
        // RaisedButton 的点击事件
        onPressed: onPressed,
        // 改变高亮颜色回掉函数，一个按钮会触发两次，按下后改变时触发一次，松手后恢复原始颜色触发一次
        // 参数 bool，按下后true，恢复false
        onHighlightChanged: (isClick) {
          // print(isClick);
        });
  }
}
