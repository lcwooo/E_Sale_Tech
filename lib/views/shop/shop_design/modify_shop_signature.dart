import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/input/normal_input.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/views/shop/shop_provider.dart';
import 'package:provider/provider.dart';

class ModifyShopSignature extends StatefulWidget {
  @override
  _ModifyShopSignatureState createState() => _ModifyShopSignatureState();
}

class _ModifyShopSignatureState extends State<ModifyShopSignature> {
  final subtitleStyle = TextStyle(color: Color(0xff999999));

  TextEditingController _textGoodsNameController = new TextEditingController();
  final FocusNode _nodeGoodsName = FocusNode();
  @override
  void initState() {
    super.initState();
    _textGoodsNameController.text =
        Provider.of<ShopInfoProvider>(context, listen: false)
            .shopInfo
            .signature;
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
          centerTitle: '修改店铺签名',
          onPressed: () {
            if (_textGoodsNameController.text.isEmpty) {
              Util.showToast('请填写签名');
              return;
            }
            ApiShop.setShopInfo({'signature': _textGoodsNameController.text},
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
                hintText: "请填写店铺签名",
                controller: _textGoodsNameController,
                focusNode: _nodeGoodsName,
                autoFocus: true,
                keyboardType: TextInputType.text,
              )),
        ));
  }
}
