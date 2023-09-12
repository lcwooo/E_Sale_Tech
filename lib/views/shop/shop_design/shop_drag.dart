import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/model/shop/product_sort_list.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:drag_list/drag_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:E_Sale_Tech/utils/style.dart';

class ShopDrag extends StatefulWidget {
  @override
  _ShopDragState createState() => _ShopDragState();
}

class _ShopDragState extends State<ShopDrag> {
  bool isSort = false;
  List<Data> listData = [];
  final subtitleStyle = TextStyle(color: Color(0xff999999));
  final _itemHeight = 80.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProductsSortList();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getProductsSortList() async {
    EasyLoading.show(status: '加载中...');
    ApiShop.getProductsSortList((data) {
      setState(() {
        listData = data.data;
        EasyLoading.dismiss();
      });
    }, (message) => EasyLoading.dismiss());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xffF8F8F8),
        appBar: MyAppBar(
          actionName: isSort ? '保存' : '开始排序',
          centerTitle: '商品排序',
          onPressed: () {
            if (isSort) {
              EasyLoading.show(status: '加载中...');
              List afterSort = [];
              for (var i = 0; i < listData.length; i++) {
                afterSort.add({'id': listData[i].id, 'index': i + 1});
              }
              ApiShop.setProductsSortList(
                  afterSort,
                  (data) => {
                        Util.showToast('保存成功'),
                        setState(() {
                          isSort = !isSort;
                        }),
                        EasyLoading.dismiss(),
                      },
                  (message) => EasyLoading.dismiss());
            } else {
              setState(() {
                isSort = !isSort;
              });
            }
          },
        ),
        body: Container(
            color: Colors.white,
            child: DragList<Data>(
              items: listData,
              itemExtent: _itemHeight,
              handleBuilder: (_) => AnimatedIcon(
                icon: AnimatedIcons.menu_arrow,
                progress: AlwaysStoppedAnimation(0.0),
              ),
              feedbackHandleBuilder: (_, transition) => AnimatedIcon(
                icon: AnimatedIcons.menu_arrow,
                progress: transition,
              ),
              itemBuilder: (_, item, handle) => Container(
                height: _itemHeight,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Color(0xFFE4E4E4), width: 1))),
                  child: Row(children: [
                    Expanded(
                      flex: 2,
                      child: CachedNetworkImage(
                        imageUrl: item.value.majorThumb,
                        placeholder: (context, url) => const CircleAvatar(
                          backgroundColor: AppColor.bgGray,
                        ),
                        imageBuilder: (context, image) => Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: image,
                              // fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(item.value.name,
                                overflow: TextOverflow.ellipsis, maxLines: 2),
                            Text('￥' + item.value?.price?.toStringAsFixed(2))
                          ],
                        )),
                    // Expanded(child: handle),
                    isSort
                        ? Expanded(child: handle)
                        : Expanded(child: Text('')),
                  ]),
                ),
              ),
            )));
  }
}
