import 'package:flutter/material.dart';
import 'platform_tap_widget.dart';

class IconTextButton extends StatelessWidget {
  final Image icon;
  final String text;
  final String price;
  final Function onTap;

  const IconTextButton({
    Key key,
    this.icon,
    this.text,
    this.onTap,
    this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformTapWidget(
      backgroundColor: Colors.transparent,
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Expanded(child: Container(
            height: 40,
            width: 40,
            color: Colors.transparent,
            child:this.icon,
          )),
          // icon,
          Text(text),
        ],
      ),
    );
  }
}
