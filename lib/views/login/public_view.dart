import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/views/login/public.dart';

class PublicView {
  Widget getText(String tittle, String colors, double size) {
    return Text(
      tittle,
      style: TextStyle(
        color: HexToColor(colors),
        fontSize: size,
      ),
    );
  }

  PreferredSizeWidget initBar(String tittle) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      brightness: Brightness.light,
      //设置为白色字体
      iconTheme: IconThemeData(
        color: Colors.black, //修改颜色
      ),
      title: Text(
        tittle,
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
