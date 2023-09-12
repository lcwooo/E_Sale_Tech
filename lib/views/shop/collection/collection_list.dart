import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/model/shop/products_collection_info.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/list_refresh.dart' as listComp;
import 'package:like_button/like_button.dart';
import 'package:E_Sale_Tech/utils/style.dart';

class CollectionList extends StatefulWidget {
  const CollectionList({Key key}) : super(key: key);

  @override
  _CollectionListState createState() => _CollectionListState();
}

class _CollectionListState extends State<CollectionList> {
  final GlobalKey<_CollectionListState> key = GlobalKey();

  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
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
    };

    var data = await ApiShop.getProductsCollectionList(params);
    return data;
  }

  Widget renderItem(index, ProductsCollection item) =>
      CollectionItem(item: item);

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

  final ProductsCollection item;

  @override
  _CollectionItemState createState() => _CollectionItemState();
}

class _CollectionItemState extends State<CollectionItem> {
  final GlobalKey<_CollectionListState> key = GlobalKey();
  bool isFavorite = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    String url = '';
    if (isLiked) {
      url = ApiShop.PRODUCTS_COLLECTIONS + '/${widget.item.id}/collect-cancel';
    } else {
      url = ApiShop.PRODUCTS_COLLECTIONS + '/${widget.item.id}/collect';
    }
    ApiShop.setProductsFavorite(url, (data) {
      setState(() {
        isFavorite = !isLiked;
      });
    }, (message) {
      setState(() {
        isFavorite = isLiked;
      });
    });
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
          color:
              widget.item.isOffShelves == 1 ? Color(0xFFF2F2F7) : Colors.white,
          border: Border.all(color: Color(0xFFF2F2F7), width: 0.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          LikeButton(
            size: 24,
            mainAxisAlignment: MainAxisAlignment.end,
            isLiked: isFavorite,
            onTap: onLikeButtonTapped,
          ),
          Expanded(
              flex: 4,
              child: GestureDetector(
                onTap: () {
                  if (widget.item.isOffShelves == 1) {
                    return;
                  }
                  Routers.push(
                      '/goodsDetailPage', context, {"goodsId": widget.item.id});
                },
                child: Container(
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.item.majorThumb[0],
                    placeholder: (context, url) =>
                        Image.asset('assets/images/goods/goodDefault@3x.png'),
                    imageBuilder: (context, image) => Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: image,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
          Expanded(
              flex: 1,
              child: Text(
                widget.item.name,
                style: TextStyle(fontSize: 12, color: Color(0xff999999)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('￥${widget.item?.lowestPrice?.toStringAsFixed(2)}'),
                  GestureDetector(
                      onTap: () {
                        if (widget.item.isOffShelves == 1) {
                          return;
                        }
                        Routers.push('/editGoodsPricePage', context,
                            {"goodsId": widget.item.id});
                      },
                      child: Image.asset(
                        'assets/images/shop/editor@3x.png',
                        width: 24,
                        height: 24,
                      ))
                ],
              )),
              widget.item.upShelf == 1
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
