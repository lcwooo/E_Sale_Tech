import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_screenutil/screenutil.dart';

// class SearchBar extends StatelessWidget implements PreferredSizeWidget {
//   SearchBar({
//     Key key,
//     this.leading,
//     this.title,
//     this.onCancel,
//     this.onSearch,
//   }) : super(key: key);
//   final Widget leading;

//   // 标题
//   final String title;

//   // 点击取消回调
//   final VoidCallback onCancel;

//   // 点击键盘搜索回调
//   final ValueChanged<String> onSearch;

//   @override
//   Widget build(BuildContext context) {
//     return _AppBar(
//       key: key,
//       leading: leading,
//       title: title,
//       onSearch: onSearch,
//       onCancel: onCancel,
//     );
//   }

// }

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  SearchBar({
    Key key,
    this.leading,
    this.title,
    this.onCancel,
    this.onSearch,
    this.onSearchClick,
    this.controller,
    this.focusNode,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  // 头部组件 可选
  final Widget leading;

  // 标题 可选
  final String title;

  // 点击取消回调 可选
  final VoidCallback onCancel;

  // 点击键盘搜索回调 可选
  final ValueChanged<String> onSearch;

  final ValueChanged<String> onSearchClick;

  final TextEditingController controller;

  final FocusNode focusNode;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  // bool _showSearch = true; // 显示搜索框
  String _title = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    widget.focusNode.dispose();
    super.dispose();
  }

  // 搜索面板 默认返回标题
  Widget _searchPanel() {
    return Container(
      width: ScreenUtil().screenWidth * 4 / 4,
      height: kToolbarHeight - 20,
      child: TextField(
        cursorColor: AppColor.themeRed,
        focusNode: widget.focusNode,
        controller: widget.controller,
        autofocus: true,
        style: TextStyle(fontSize: 13),
        textInputAction: TextInputAction.search,
        onChanged: (string1) {
          _title = string1;
          // print(string1);
          print("$widget.onSearch");
          if (widget.onSearch is Function) {
            print(string1);
            widget.onSearch(string1);
          }
        },
        onSubmitted: (strin) {
          _title = strin;
          // print(string1);
          print("$widget.onSearch");
          if (widget.onSearchClick is Function) {
            print(strin);
            widget.onSearchClick(strin);
          }
        },
        decoration: InputDecoration(
          filled: true,
          hintText: S.of(context).homeSearchHint,
          hintStyle: AppText.textGray14,
          fillColor: AppColor.bgGray,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  // 搜索/取消按钮
  Widget _action() {
    return Container(
      color: Colors.white,
      width: 50,
      margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
      child: RawMaterialButton(
        padding: EdgeInsets.all(0),
        child: Text(S.of(context).search),
        onPressed: () {
          print("$_title");
          if (widget.onSearch is Function) widget.onSearchClick(_title);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      elevation: 3,
      centerTitle: false,
      backgroundColor: Colors.white,
      leading: widget.leading,
      title: _searchPanel(),
      actions: <Widget>[_action()],
    );
  }
}
