import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:E_Sale_Tech/utils/style.dart';

/// 自定义AppBar
class MySearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MySearchAppBar(
      {Key key,
      this.backgroundColor: Colors.white,
      this.title: "",
      this.centerView,
      this.actionName: "",
      this.actionIcon,
      this.onPressed,
      this.isBack: true})
      : super(key: key);

  final Color backgroundColor;
  final String title;
  final Container centerView;
  final String actionName;
  final Icon actionIcon;
  final VoidCallback onPressed;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(750, 1334), allowFontScaling: false);
    SystemUiOverlayStyle _overlayStyle =
        ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle,
      child: Material(
        color: backgroundColor,
        child: SafeArea(
            child: Container(
          padding: EdgeInsets.all(5),
          height: 44,
          child: centerView,
        )
            // Row(
            // // alignment: Alignment.center,
            // children: <Widget>[
            //   Expanded(
            //     flex: 1,
            //     child: isBack ? IconButton(
            //     onPressed: (){
            //       onPressed();
            //     },
            //     padding: const EdgeInsets.all(7.0),
            //     icon: Image.asset("assets/images/home/中文@3x.png"),
            //   ) : Gaps.empty,
            //   ),
            //   Expanded(
            //     flex: 7,
            //     child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       centerView,
            //     ],
            //   ),)
            // ],
            // ),
            ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48.0);
}
