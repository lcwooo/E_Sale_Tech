import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/utils/style.dart';

class ChoiceChipView extends StatefulWidget {
  ChoiceChipView({
    Key key,
    this.list,
    this.selectlist,
    this.isSingle,
    this.shapeNo,
    this.width,
    this.onClick,
    this.isHightLight,
  }) : super(key: key);

  final List<String> list;

  final List<String> selectlist;

  final bool isHightLight;

  final bool isSingle;

  final double shapeNo;

  final double width;

  // 点击键盘搜索回调 可选
  final ValueChanged<String> onClick;

  State<StatefulWidget> createState() => _ChoiceChipViewState();
}

class _ChoiceChipViewState extends State<ChoiceChipView> {
  GlobalKey childKey = GlobalKey();

  String _selected = "";

  List<String> _selectedList = [];

  resetSelected() {
    setState(() {
      _selected = "";
      _selectedList = [];
    });
  }

  actorWidgets() {
    List<Widget> widgets = [];
    for (String choiceSub in widget.list) {
      var container = Container(
        child: ChoiceChip(
          backgroundColor: Colors.white,
          disabledColor: Colors.blue,
          labelStyle: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 13.0,
              color: AppColor.mainTextColor),
          labelPadding: EdgeInsets.only(left: 20.0, right: 20.0),
          materialTapTargetSize: MaterialTapTargetSize.padded,
          label: Text(choiceSub),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.shapeNo),
            side: BorderSide(color: Color(0xFFE1E1E1), width: 1.0),
          ),
          onSelected: (bool value) {
            if (widget.onClick is Function) {
              widget.onClick(choiceSub);
            }
            if (widget.isHightLight) {
              setState(() {
                if (widget.isSingle) {
                  _selected = value ? choiceSub : "Colors.red";
                } else {
                  if (value) {
                    _selectedList.add(choiceSub);
                  } else {
                    _selectedList.remove(choiceSub);
                  }
                }
              });
            }
          },
          selected: widget.isSingle
              ? (_selected == choiceSub)
              : (_selectedList.contains(choiceSub)),
        ),
      );
      widgets.add(container);
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.start,
              textDirection: TextDirection.ltr,
              spacing: 5,
              runSpacing: 0,
              children: actorWidgets(),
            ),
          ],
        ));
  }
}
