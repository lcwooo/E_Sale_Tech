import 'package:E_Sale_Tech/api/home.dart';
import 'package:E_Sale_Tech/api/search.dart';
import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/model/shop/products_collection_info.dart';
import 'package:E_Sale_Tech/model/shop/products_info.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/list_refresh.dart' as listComp;
import 'package:like_button/like_button.dart';
import 'package:E_Sale_Tech/utils/style.dart';

class TypePageList extends StatefulWidget {
  final Map arguments;
  TypePageList({this.arguments});
  @override
  _TypePageListState createState() => _TypePageListState(arguments: arguments);
}

class _TypePageListState extends State<TypePageList> {
  final GlobalKey<_TypePageListState> key = GlobalKey();
  final Map arguments;
  _TypePageListState({this.arguments});
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    print(this.arguments);
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> params = {
      "page": (++pageIndex),
      "type": this.arguments["type"],
    };
    var data = await ApiHome.getProductsList(params);
    return data;
  }

  Widget renderItem(index, ProductsItem item) => CollectionItem(item: item);

  @override
  Widget build(BuildContext context) {
    return listComp.ListRefresh(
      listType: 'GirdView',
      renderItem: renderItem,
      refresh: loadList,
      more: loadMoreList,
    );
  }
}

class CollectionItem extends StatefulWidget {
  const CollectionItem({Key key, this.item}) : super(key: key);

  final ProductsItem item;

  @override
  _CollectionItemState createState() => _CollectionItemState();
}

class _CollectionItemState extends State<CollectionItem> {
  final GlobalKey<_CollectionItemState> key = GlobalKey();
  bool isFavorite = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFF2F2F7), width: 0.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Routers.push(
                  '/goodsDetailPage', context, {"goodsId": widget.item.id});
            },
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 140,
                  child: CachedNetworkImage(
                    imageUrl: widget.item.majorThumb[0],
                    placeholder: (context, url) => const CircleAvatar(
                      backgroundColor: AppColor.bgGray,
                    ),
                    imageBuilder: (context, image) => Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: image,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
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
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('￥' + widget.item.lowestPrice?.toStringAsFixed(2)),
                  GestureDetector(
                      onTap: () {
                        Routers.push('/editGoodsPricePage', context,
                            {"goodsId": widget.item.id});
                      },
                      child: Image.asset(
                        'assets/images/shop/editor@3x.png',
                        width: 24,
                        height: 24,
                      ))
                ],
              ),
              widget.item.checked
                  ? Image.asset(
                      'assets/images/shop/put_on_the_shelf@3x.png',
                      width: 16,
                      height: 22,
                    )
                  : Text('')
            ],
          )
        ],
      ),
    );
  }
}
