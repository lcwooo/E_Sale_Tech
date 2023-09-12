import 'package:E_Sale_Tech/api/goods.dart';
import 'package:E_Sale_Tech/components/round_checkbox.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/model/shop/products_info.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/utils/style.dart';

class BatchPutOnShelfList extends StatefulWidget {
  const BatchPutOnShelfList({
    Key key,
    @required this.list,
    @required this.upShelfSelectedList,
    this.type,
    this.onClick,
  }) : super(key: key);

  final dynamic list;
  final List upShelfSelectedList;
  final bool type;
  final ValueChanged<ProductsItem> onClick;

  @override
  _BatchPutOnShelfListState createState() => _BatchPutOnShelfListState();
}

class _BatchPutOnShelfListState extends State<BatchPutOnShelfList> {
  final GlobalKey<_BatchPutOnShelfListState> key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return BatchPutOnShelfItem(
            item: widget.list[index],
            upShelfSelectedList: widget.upShelfSelectedList,
            type: widget.type,
            index: index,
            onClick: widget.onClick,
          );
        }, childCount: widget.list.length));
  }
}

class BatchPutOnShelfItem extends StatefulWidget {
  const BatchPutOnShelfItem(
      {Key key,
      this.item,
      this.isShowbtn = true,
      this.upShelfSelectedList,
      this.type,
      this.index,
      this.onClick})
      : super(key: key);

  final ProductsItem item;
  final List upShelfSelectedList;
  final bool type;
  final bool isShowbtn;
  final int index;
  final ValueChanged<ProductsItem> onClick;

  @override
  _BatchPutOnShelfItemState createState() => _BatchPutOnShelfItemState();
}

class _BatchPutOnShelfItemState extends State<BatchPutOnShelfItem> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFF2F2F7), width: 0.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              flex: 4,
              child: GestureDetector(
                  onTap: () {
                    Routers.push('/goodsDetailPage', context,
                        {"goodsId": widget.item.id});
                  },
                  child: Container(
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: widget.item.majorThumb[0] ?? '',
                      placeholder: (context, url) =>
                          Image.asset('assets/images/goods/goodDefault@3x.png'),
                      imageBuilder: (context, image) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: image,
                          ),
                        ),
                      ),
                    ),
                  ))),
          Row(children: [
            Expanded(
              child: Text(
                widget.item.name,
                style: TextStyle(fontSize: 12, color: Color(0xff999999)),
                maxLines: 2,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ]),
          Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('￥' +
                          num.parse(widget?.item?.totalPrice)
                              .toStringAsFixed(2)),
                    ],
                  ),
                  widget.isShowbtn
                      ? widget.type
                          ? RoundCheckBox(
                              value: widget.item.checked,
                              onChanged: (value) {
                                setState(() {
                                  widget.item.checked = value;
                                  if (widget.upShelfSelectedList
                                      .contains(widget.item.id)) {
                                    widget.upShelfSelectedList
                                        .remove(widget.item.id);
                                  } else {
                                    widget.upShelfSelectedList
                                        .add(widget.item.id);
                                  }
                                });
                              },
                            )
                          : SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: ImageIcon(AssetImage(
                                      "assets/images/goods/UpShelves@3x.png")),
                                  onPressed: () {
                                    widget.onClick(widget.item);
                                  }))
                      : Container()
                ],
              )),
        ],
      ),
    );
  }
}
