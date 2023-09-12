import 'package:E_Sale_Tech/model/me/agent_msg_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MsgDetail extends StatefulWidget {
  final Map arguments;

  MsgDetail({this.arguments});

  @override
  _MsgDetailState createState() => _MsgDetailState();
}

class _MsgDetailState extends State<MsgDetail> {
  final subtitleStyle = TextStyle(color: Color(0xff999999));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var title = widget.arguments['msg'].title;
    var content = widget.arguments['msg'].content;
    List<Data> titleList = widget.arguments['msg'].data;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xffF8F8F8),
        appBar: MyAppBar(
          centerTitle: (title != null && title.length <= 15)
              ? title
              : title.substring(0, 15) + '...',
        ),
        // Html(data: widget.arguments['msg'].content)),
        body: SingleChildScrollView(
          child: titleList.length == 0
              ? Html(data: widget.arguments['msg'].content)
              : Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 15, left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            content,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w200),
                            maxLines: 10,
                            // overflow: TextOverflow.ellipsis,
                          ))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Table(
                          border: TableBorder.all(
                              color: Colors.black,
                              width: 0.6,
                              style: BorderStyle.solid),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth()
                          },
                          children: _renderList()),
                    )
                  ],
                ),
        ));
  }

  List<TableRow> _renderList() {
    List<Data> titleList = widget.arguments['msg'].data;
    List<TableRow> list = [];
    list.add(getRow());
    for (var i = 0; i < titleList.length; i++) {
      Data model = titleList[i];
      list.add(getDataRow(model));
    }
    return list;
  }

  TableRow getRow() {
    AgentMsgList msgData = widget.arguments['msg'];
    if (msgData.subject == 11) {
      return TableRow(children: [
        Container(
          padding: EdgeInsets.all(2),
          child: Text(
            '商品名称',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.all(2),
          child: Text(
            '商品规格',
            textAlign: TextAlign.center,
          ),
        ),
      ]);
    } else if (msgData.subject == 13) {
      return TableRow(children: [
        Container(
          padding: EdgeInsets.all(2),
          child: Text(
            '商品名称',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.all(2),
          child: Text(
            '商品规格',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.all(2),
          child: Text(
            '原始成本价',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.all(2),
          child: Text(
            '成本上调价格',
            textAlign: TextAlign.center,
          ),
        ),
      ]);
    } else if (msgData.subject == 31) {
      return TableRow(children: [
        Container(
          padding: EdgeInsets.all(2),
          child: Text(
            '订单号',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.all(2),
          child: Text(
            '预估收益',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.all(2),
          child: Text(
            '时间',
            textAlign: TextAlign.center,
          ),
        ),
      ]);
    } else if (msgData.subject == 32 ||
        msgData.subject == 33 ||
        msgData.subject == 35) {
      return TableRow(children: [
        Container(
          padding: EdgeInsets.all(2),
          child: Text(
            '订单号',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.all(2),
          child: Text(
            '时间',
            textAlign: TextAlign.center,
          ),
        ),
      ]);
    } else if (msgData.subject == 34) {
      return TableRow(children: [
        Container(
          padding: EdgeInsets.all(2),
          child: Text(
            '订单号',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.all(2),
          child: Text(
            '时间',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.all(2),
          child: Text(
            '签收人',
            textAlign: TextAlign.center,
          ),
        ),
      ]);
    }
  }

  TableRow getDataRow(Data model) {
    var width = ScreenUtil().screenWidth;
    AgentMsgList msgData = widget.arguments['msg'];
    if (msgData.subject == 11) {
      return TableRow(children: [
        Container(
          width: width / 2,
          padding: EdgeInsets.all(2),
          child: Text(
            model?.name != null ? model?.name : '暂无',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: width / 2,
          padding: EdgeInsets.all(2),
          child: Text(
            // model.specName,
            model?.specName != null ? model?.specName : '暂无',
            textAlign: TextAlign.center,
          ),
        ),
      ]);
    } else if (msgData.subject == 13) {
      return TableRow(children: [
        Container(
          width: width / 4,
          padding: EdgeInsets.all(2),
          child: Text(
            model?.name != null ? model?.name : '暂无',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: width / 4,
          padding: EdgeInsets.all(2),
          child: Text(
            model?.specName != null ? model?.specName : '暂无',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: width / 4,
          padding: EdgeInsets.all(2),
          child: Text(
            model?.originPrice != null
                ? model.originPrice.toStringAsFixed(2)
                : '暂无',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: width / 4,
          padding: EdgeInsets.all(2),
          child: Text(
            model?.changePrice != null
                ? model.changePrice.toStringAsFixed(2)
                : '暂无',
            textAlign: TextAlign.center,
          ),
        ),
      ]);
    } else if (msgData.subject == 31) {
      return TableRow(children: [
        Container(
          width: width / 3,
          padding: EdgeInsets.all(2),
          child: Text(
            model?.orderSn != null ? model.orderSn : '暂无',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: width / 3,
          padding: EdgeInsets.all(2),
          child: Text(
            model?.profit != null ? model.profit : '暂无',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: width / 3,
          padding: EdgeInsets.all(2),
          child: Text(
            model?.date != null ? model?.date : '暂无',
            textAlign: TextAlign.center,
          ),
        ),
      ]);
    } else if (msgData.subject == 32 ||
        msgData.subject == 33 ||
        msgData.subject == 35) {
      return TableRow(children: [
        Container(
          width: width / 2,
          padding: EdgeInsets.all(2),
          child: Text(
            model?.orderSn != null ? model.orderSn : '暂无',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: width / 2,
          padding: EdgeInsets.all(2),
          child: Text(
            model?.date != null ? model?.date : '暂无',
            textAlign: TextAlign.center,
          ),
        ),
      ]);
    } else if (msgData.subject == 34) {
      return TableRow(children: [
        Container(
          width: width / 3,
          padding: EdgeInsets.all(2),
          child: Text(
            model?.orderSn != null ? model.orderSn : '暂无',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: width / 3,
          padding: EdgeInsets.all(2),
          child: Text(
            model?.date != null ? model?.date : '暂无',
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: width / 3,
          padding: EdgeInsets.all(2),
          child: Text(
            model?.signer != null ? model?.signer : '暂无',
            textAlign: TextAlign.center,
          ),
        ),
      ]);
    }
  }
}

// Container(
//         padding: EdgeInsets.all(2),
//         child: Text('订单号'),
//       ),
//       Container(
//         padding: EdgeInsets.all(2),
//         child: Text('预估收益'),
//       ),
//       Container(
//         padding: EdgeInsets.all(2),
//         child: Text('时间'),
//       )
