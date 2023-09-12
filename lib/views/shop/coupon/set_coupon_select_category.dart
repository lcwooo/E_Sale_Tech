import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/components/round_checkbox.dart';
import 'package:E_Sale_Tech/model/shop/category_info.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SetCouponSelectCategory extends StatefulWidget {
  final Map arguments;
  SetCouponSelectCategory({this.arguments});
  @override
  _SetCouponSelectCategoryState createState() =>
      _SetCouponSelectCategoryState();
}

class _SetCouponSelectCategoryState extends State<SetCouponSelectCategory> {
  List<CategoryList> categoryList = [];
  List selectedList = [];
  Map arg = {'type': '', 'id': ''};

  @override
  void initState() {
    super.initState();
    if (widget.arguments != null) {
      setState(() {
        arg = widget.arguments;
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (arg['type'] == 'view') {
        getCategoryDetail();
      } else {
        getCategory();
      }
    });
  }

  getCategoryDetail() {
    EasyLoading.show(status: '加载中');
    ApiShop.getCouponCategoryDetail(arg['id'], (data) {
      if (data != null) {
        setState(() {
          categoryList = data;
        });
      }
      EasyLoading.dismiss();
    }, (message) => EasyLoading.dismiss());
  }

  getCategory() {
    EasyLoading.show(status: '加载中');
    ApiShop.getCategory((data) {
      if (data != null) {
        setState(() {
          categoryList = data;
        });
      }
      EasyLoading.dismiss();
    }, (message) => EasyLoading.dismiss());
  }

  onChange(index, id) {
    setState(() {
      categoryList[index].checked = !categoryList[index].checked;
      if (selectedList.contains(id)) {
        selectedList.remove(id);
      } else {
        selectedList.add(id);
      }
    });
  }

  selectedAll() {
    setState(() {
      categoryList.forEach((element) {
        element.checked = true;
        if (!selectedList.contains(element.id)) {
          selectedList.add(element.id);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: MyAppBar(
        centerTitle: '指定分类可用',
      ),
      bottomNavigationBar: arg['type'] == 'view'
          ? SizedBox(height: 0)
          : Material(
              //底部栏整体的颜色
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    child: new Padding(
                      padding: new EdgeInsets.all(12),
                      child: Text("全选",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          )),
                    ),
                    color: Color(0xffCBCBCB),
                    onPressed: () async {
                      selectedAll();
                    },
                  )),
                  Expanded(
                      child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    child: new Padding(
                      padding: new EdgeInsets.all(12),
                      child: Text("确定",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          )),
                    ),
                    color: Color(0xffe4382d),
                    onPressed: () async {
                      if (selectedList.length < 1) {
                        Util.showToast('请选择');
                        return;
                      }
                      Routers.pop(context, {'category_id': selectedList});
                    },
                  )),
                ],
              ),
            ),
      body: SingleChildScrollView(
          child: Container(
              color: Colors.white,
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                ),
                itemCount: categoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  return SetCouponSelectCategoryItem(
                      type: arg['type'],
                      item: categoryList[index],
                      onChange: onChange,
                      index: index);
                },
              ))),
    );
  }
}

class SetCouponSelectCategoryItem extends StatefulWidget {
  const SetCouponSelectCategoryItem(
      {@required this.item,
      @required this.onChange,
      @required this.type,
      @required this.index});
  final CategoryList item;
  final int index;
  final Function onChange;
  final String type;
  @override
  SetCouponSelectCategoryItemState createState() =>
      SetCouponSelectCategoryItemState();
}

class SetCouponSelectCategoryItemState
    extends State<SetCouponSelectCategoryItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (widget.type == 'view') return;
          widget.onChange(widget.index, widget.item.id);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 60.9,
                child: CachedNetworkImage(
                  imageUrl: widget.item.icon ?? '',
                  placeholder: (context, url) => const CircleAvatar(
                    backgroundColor: AppColor.bgGray,
                  ),
                  imageBuilder: (context, image) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: image,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: Text(
                    widget.item.name,
                    style: TextStyle(fontSize: 14, color: Color(0xff999999)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              widget.type == 'view'
                  ? Text('')
                  : Align(
                      alignment: Alignment.centerRight,
                      child: RoundCheckBox(
                        padding: EdgeInsets.all(0),
                        value: widget.item.checked,
                        onChanged: (value) {
                          if (widget.type == 'view') return;
                          widget.onChange(widget.index, widget.item.id);
                        },
                      )),
            ],
          ),
        ));
  }
}
