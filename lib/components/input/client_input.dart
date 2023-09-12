import 'package:E_Sale_Tech/components/input/base_input.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:flutter/material.dart';

class ClientInput extends StatefulWidget {
  ClientInput(
      {Key key,
      this.id,
      this.name,
      this.hintText,
      this.keyName,
      this.onChange,
      this.focusNode,
      this.pageTitle,
      this.readOnly = false,
      this.type,
      this.router,
      this.warehouseId,
      this.controller,
      this.isDisabledJump = false})
      : super(key: key);
  final TextEditingController controller;
  final int id;
  final String keyName;
  final String hintText;
  final bool readOnly;
  final String name;
  final FocusNode focusNode;
  final ValueChanged onChange;
  final String pageTitle;
  final String type;
  final String router;
  final int warehouseId;
  final bool isDisabledJump;

  @override
  State<StatefulWidget> createState() {
    return _ClientInput();
  }
}

class _ClientInput extends State<ClientInput> {
  int id;
  String name;
  TextEditingController _nameInput = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void openModal() {
    // Routers.popup(widget.router, context, {
    //   "title": widget.pageTitle,
    //   "type": widget.type,
    //   "id": widget.id,
    //   "name": widget.name,
    //   "warehouseId": widget.warehouseId,
    //   "onSelected": (item) {
    //     setState(() {
    //       this.id = item.id;
    //       this.name = item.name;
    //       if (widget.controller == null) {
    //         this._nameInput.text = this.name.toString();
    //       }
    //       widget.onChange(item);
    //     });
    //   }
    // }
    // );
    Routers.push(widget.router, context);
  }

  Widget buildInputItem() {
    if (widget.controller == null) {
      this._nameInput.text = this.widget.name;
    }
    this.id = this.widget.id;
    var suffix = GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(right: 15),
        child: Icon(Icons.arrow_forward_ios),
      ),
      onTap: () {
        if (widget.warehouseId == 0) return;
        openModal();
      },
    );

    return BaseInput(
      controller: widget.controller != null ? widget.controller : _nameInput,
      keyName: widget.keyName,
      hintText: widget.hintText,
      autoShowRemove: false,
      readOnly: widget.readOnly,
      focusNode: widget.focusNode,
      onTab: () {
        if (widget.warehouseId == 0) return;
        if (widget.isDisabledJump) return;
        FocusScope.of(context).requestFocus(new FocusNode());
        openModal();
      },
      suffix: suffix,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildInputItem(),
    );
  }
}
