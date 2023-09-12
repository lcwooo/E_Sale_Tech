import 'package:E_Sale_Tech/model/goods/goodsDetailInfo.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/utils/style.dart';

class ChoiceChipViewForSpec extends StatefulWidget {
  ChoiceChipViewForSpec({
    Key key,
    this.list,
    this.selectItem,
    this.shapeNo,
    this.width,
    this.onClick,
    this.isHightLight,
  }) : super(key: key);

  final List<Goods> list;

  final Goods selectItem;

  final bool isHightLight;

  final double shapeNo;

  final double width;

  // 点击键盘搜索回调 可选
  final ValueChanged<Goods> onClick;

  _ChoiceChipViewForSpecState createState() => _ChoiceChipViewForSpecState();
}

class _ChoiceChipViewForSpecState extends State<ChoiceChipViewForSpec> {
  Goods _selected;

  actorWidgets() {
    List<Widget> widgets = [];
    bool isSelect = false;
    for (Goods choiceSub in widget.list) {
      isSelect = (widget.selectItem == choiceSub);
      var container = Container(
        child: Stack(
          children: <Widget>[
            ChoiceChip(
              backgroundColor:
                  choiceSub.salable == 0 ? Color(0xFFE1E1E1) : Colors.white,
              disabledColor: Color(0xFFE1E1E1),
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 13.0,
                  color: AppColor.mainTextColor),
              labelPadding: EdgeInsets.only(left: 20.0, right: 20.0),
              materialTapTargetSize: MaterialTapTargetSize.padded,
              label: Text(choiceSub.specName),
              shape: isSelect
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(widget.shapeNo),
                      side: BorderSide(color: AppColor.themeRed, width: 1.0),
                    )
                  : RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(widget.shapeNo),
                      side: BorderSide(color: Color(0xFFE1E1E1), width: 1.0),
                    ),
              selectedColor: Colors.white,
              onSelected: (bool value) {
                print("$choiceSub");
                if (widget.onClick is Function) {
                  widget.onClick(choiceSub);
                }
                if (widget.isHightLight) {
                  setState(() {
                    _selected = value ? choiceSub : null;
                  });
                }
              },
              selected: isSelect,
            ),
            new Positioned(
              //方法二
              right: 3.0,
              bottom: 10.0,
              child: isSelect
                  ? Image.asset(
                      "assets/images/goods/规格选中@3x.png",
                      width: 13,
                      height: 13,
                    )
                  : Container(),
            ),
          ],
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
              crossAxisAlignment: WrapCrossAlignment.center,
              textDirection: TextDirection.ltr,
              spacing: 5,
              runSpacing: 0,
              children: actorWidgets(),
            ),
          ],
        ));
  }
}
