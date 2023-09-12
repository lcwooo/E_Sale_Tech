import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:E_Sale_Tech/utils/style.dart';

/// 自定义AppBar
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar(
      {Key key,
      this.backgroundColor: Colors.white,
      this.title: "",
      this.centerTitle: "",
      this.actionName: "",
      this.actionIcon,
      this.onPressed,
      this.backToRoot: false,
      this.backBtnPress,
      this.isBack: true})
      : super(key: key);

  final Color backgroundColor;
  final String title;
  final String centerTitle;
  final String actionName;
  final Icon actionIcon;
  final VoidCallback onPressed;
  final VoidCallback backBtnPress;
  final bool isBack;
  final bool backToRoot;
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
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: centerTitle.isEmpty
                        ? Alignment.centerLeft
                        : Alignment.center,
                    width: double.infinity,
                    child: Text(title.isEmpty ? centerTitle : title,
                        style: TextStyle(
                          fontSize: ScreenUtil()
                              .setSp(36, allowFontScalingSelf: true),
                          color: _overlayStyle == SystemUiOverlayStyle.light
                              ? Colors.white
                              : AppColor.textDark,
                        )),
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  )
                ],
              ),
              isBack
                  ? IconButton(
                      onPressed: () {
                        if (backToRoot) {
                          backBtnPress();
                        } else {
                          EasyLoading.dismiss();
                          FocusScope.of(context).unfocus();
                          Navigator.maybePop(context);
                        }
                      },
                      tooltip: 'Back',
                      padding: const EdgeInsets.all(12.0),
                      icon: Icon(Icons.arrow_back),
                    )
                  : Gaps.empty,
              Positioned(
                right: 5.0,
                child: Theme(
                  data: ThemeData(
                      buttonTheme: ButtonThemeData(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    minWidth: 60.0,
                  )),
                  child: FlatButton(
                    child: actionName.isEmpty
                        ? actionIcon
                        : Text(actionName, key: const Key('actionName')),
                    textColor: _overlayStyle == SystemUiOverlayStyle.light
                        ? Colors.white
                        : AppColor.textDark,
                    highlightColor: Colors.transparent,
                    onPressed: onPressed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48.0);
}
