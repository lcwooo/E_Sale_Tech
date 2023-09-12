import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/input/normal_input.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/shop/shop_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModifyShopName extends StatefulWidget {
  @override
  _ModifyShopNameState createState() => _ModifyShopNameState();
}

class _ModifyShopNameState extends State<ModifyShopName> {
  final subtitleStyle = TextStyle(color: Color(0xff999999));

  TextEditingController _textGoodsNameController = new TextEditingController();
  final FocusNode _nodeGoodsName = FocusNode();

  @override
  void initState() {
    super.initState();
    _textGoodsNameController.text =
        Provider.of<ShopInfoProvider>(context, listen: false).shopInfo.name;
  }

  @override
  void dispose() {
    _textGoodsNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xffF8F8F8),
        appBar: MyAppBar(
          actionName: '保存',
          centerTitle: '修改店铺名称',
          onPressed: () {
            if (_textGoodsNameController.text.isEmpty) {
              Util.showToast('请填写店铺名称');
              return;
            }
            ApiShop.setShopInfo({'name': _textGoodsNameController.text},
                (data) async {
              Provider.of<ShopInfoProvider>(context, listen: false)
                  .getShopInfo();
              Routers.pop(context);
            }, (message) => null);
          },
        ),
        body: GestureDetector(
          child: Container(
              padding: EdgeInsets.only(left: 10),
              color: Colors.white,
              child: NormalInput(
                  hintText: "请填写店铺名称",
                  controller: _textGoodsNameController,
                  focusNode: _nodeGoodsName,
                  autoFocus: true,
                  keyboardType: TextInputType.text,
                  onSubmitted: (res) {})),
        ));
  }
}
