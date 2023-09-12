import 'package:E_Sale_Tech/api/common.dart';
import 'package:E_Sale_Tech/utils/click_upload_image.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NormalAddressItem extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String placeholder;
  final bool isEdit;
  final bool isFilled;
  final Widget rightWidget;

  NormalAddressItem(
      {this.controller,
      this.title,
      this.placeholder = "",
      this.isEdit = true,
      this.isFilled = false,
      this.rightWidget = const Text('')});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: AppColor.white,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(left: 14),
              child: Text(this.title),
            ),
          ),
          Expanded(
            flex: 7,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: this.isFilled
                      ? EdgeInsets.only(
                          right: 15,
                          top: 0,
                        )
                      : EdgeInsets.all(0),
                  padding: EdgeInsets.only(right: 20),
                  child: TextField(
                    enabled: this.isEdit,
                    autofocus: true,
                    cursorColor: AppColor.themeRed,
                    controller: this.controller,
                    decoration: InputDecoration(
                      fillColor: AppColor.line,
                      filled: this.isFilled,
                      hintText: this.placeholder ?? "",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 10),
                  width: ScreenUtil().screenWidth,
                  height: 50,
                  // color: Colors.red,
                  child: this.rightWidget,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UploadIDCardImageItem extends StatelessWidget {
  final TextEditingController frontController;
  final TextEditingController backController;
  final TextEditingController nameController;
  final TextEditingController idCardController;
  final String title;
  final String placeholder;
  static const FRONT = 1;
  static const BACK = 2;

  UploadIDCardImageItem(
      {this.frontController,
      this.backController,
      this.nameController,
      this.idCardController,
      this.title,
      this.placeholder = ""});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      color: AppColor.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(left: 14, top: 22.5),
              child: Text(this.title),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: EdgeInsets.only(top: 22.5),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    child: this.frontController?.text == ''
                        ? _buildNoImageItem(context, FRONT)
                        : _buildImageItem(
                            context, this.frontController?.text, FRONT),
                    height: 60,
                    width: 94,
                  ),
                  Container(
                    height: 60,
                    width: 16,
                  ),
                  SizedBox(
                    child: this.backController?.text == ''
                        ? _buildNoImageItem(context, BACK)
                        : _buildImageItem(
                            context, this.backController?.text, BACK),
                    height: 60,
                    width: 94,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageItem(context, String url, int direction) {
    return GestureDetector(
      child: Container(
        child: Image.network(url),
      ),
      onTap: () {
        ClickUploadImage.showIDCardActionSheet(
          onSuccessCallback: (image) async {
            if (direction == FRONT) {
              var imageData = await Api.uploadIDCardImage(image, 'front');
              Map userData = imageData["data"];
              this.nameController?.text = userData['name'];
              this.idCardController?.text = userData['idcard'];
              this.frontController?.text = imageData["path"];
            } else if (direction == BACK) {
              var imageData = await Api.uploadIDCardImage(image, 'back');
              if (imageData != null) {
                this.backController?.text = imageData['path'];
              }
            }
          },
          context: context,
          child: CupertinoActionSheet(
            title: const Text('请选择上传方式'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: const Text('相册'),
                onPressed: () {
                  Navigator.pop(context, 'gallery');
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('照相机'),
                onPressed: () {
                  Navigator.pop(context, 'camera');
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('取消'),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoImageItem(BuildContext context, int direction) {
    var title = '正面';
    if (direction == BACK) {
      title = '反面';
    }
    return InkWell(
      child: Container(
        color: Color(0xffF8F8F8),
        child: Container(
          padding: EdgeInsets.only(top: 10),
          width: 29,
          child: Column(
            children: <Widget>[
              Container(
                width: 24,
                height: 24,
                child: Image.asset('assets/images/me/add_image.png'),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 13.5, color: Color(0xffCCCCCC)),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        ClickUploadImage.showIDCardActionSheet(
          onSuccessCallback: (image) async {
            if (direction == FRONT) {
              var imageData = await Api.uploadIDCardImage(image, 'front');
              Map userData = imageData["data"];
              this.nameController?.text = userData['name'];
              this.idCardController?.text = userData['idcard'];
              this.frontController?.text = imageData["path"];
            } else if (direction == BACK) {
              var imageData = await Api.uploadIDCardImage(image, 'back');
              if (imageData != null) {
                this.backController?.text = imageData['path'];
              }
            }
          },
          context: context,
          child: CupertinoActionSheet(
            title: const Text('请选择上传方式'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: const Text('相册'),
                onPressed: () {
                  Navigator.pop(context, 'gallery');
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('照相机'),
                onPressed: () {
                  Navigator.pop(context, 'camera');
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('取消'),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            ),
          ),
        );
      },
    );
  }
}
