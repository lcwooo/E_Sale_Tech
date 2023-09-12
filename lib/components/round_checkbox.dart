import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter/material.dart';

class RoundCheckBox extends StatefulWidget {
  var value = false;

  Function(bool) onChanged;

  Color activeColor;

  EdgeInsets padding;

  RoundCheckBox(
      {Key key,
      @required this.value,
      this.onChanged,
      this.padding = const EdgeInsets.all(10.0),
      this.activeColor: AppColor.themeRed})
      : super(key: key);

  @override
  _RoundCheckBoxState createState() => _RoundCheckBoxState();
}

class _RoundCheckBoxState extends State<RoundCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onTap: () {
            widget.value = !widget.value;
            widget.onChanged(widget.value);
          },
          child: Padding(
            padding: widget.padding,
            child: widget.value
                ? Icon(
                    Icons.check_circle,
                    size: 25.0,
                    color: widget.activeColor,
                  )
                : Icon(
                    Icons.panorama_fish_eye,
                    size: 25.0,
                    color: Colors.grey,
                  ),
          )),
    );
  }
}
