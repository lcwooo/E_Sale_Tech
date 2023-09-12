import 'package:E_Sale_Tech/views/shop/collection/collection_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';

class Collection extends StatefulWidget {
  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        centerTitle: '收藏夹',
      ),
      bottomNavigationBar: Material(
        //底部栏整体的颜色
        color: Color(0xffe4382d),
        child: FlatButton(
          child: new Padding(
            padding: new EdgeInsets.all(10),
            child: Text("批量上架",
                style: TextStyle(
                  fontSize: 18.0, //textsize
                  color: Colors.white, // textcolor
                )),
          ),
          color: Color(0xffe4382d),
          onPressed: () {
            Routers.push("/shop/collection/batchPutOnShelf", context,
                {"type": 1, "showBackBtn": true});
          },
        ),
      ),
      body: CollectionList(),
    );
  }
}
