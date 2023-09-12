import 'dart:io';
import 'package:E_Sale_Tech/api/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ClickUploadImage {
  static void showDemoActionSheetCircle(
      {BuildContext context, Widget child, Function onSuccessCallback}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String type) async {
      var image;
      if (type == 'camera') {
        image = await ImagePicker().getImage(source: ImageSource.camera);
      } else if (type == 'gallery') {
        image = await ImagePicker().getImage(source: ImageSource.gallery);
      }
      if (image != null) {
        File croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          cropStyle: CropStyle.circle,
          maxWidth: 800,
          maxHeight: 800,
        );
        if (croppedFile != null) {
          String imageUrl = await Api.uploadImage(croppedFile);
          onSuccessCallback(imageUrl);
        }
      }
    });
  }

  static void showDemoActionSheet(
      {BuildContext context, Widget child, Function onSuccessCallback}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String type) async {
      var image;
      if (type == 'camera') {
        image = await ImagePicker().getImage(source: ImageSource.camera);
      } else if (type == 'gallery') {
        image = await ImagePicker().getImage(source: ImageSource.gallery);
      }
      if (image != null) {
        File croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          maxWidth: 800,
          maxHeight: 800,
        );
        if (croppedFile != null) {
          String imageUrl = await Api.uploadImage(croppedFile);
          onSuccessCallback(imageUrl);
        }
      }
    });
  }

  static void showIDCardActionSheet(
      {BuildContext context, Widget child, Function onSuccessCallback}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String type) async {
      var image;
      if (type == 'camera') {
        image = await ImagePicker().getImage(source: ImageSource.camera);
      } else if (type == 'gallery') {
        image = await ImagePicker().getImage(source: ImageSource.gallery);
      }
      if (image != null) {
        File croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          maxWidth: 800,
          maxHeight: 800,
        );
        if (croppedFile != null) {
          onSuccessCallback(croppedFile);
        }
      }
    });
  }

  static void showDemoActionSheetSwiper(
      {BuildContext context, Widget child, Function onSuccessCallback}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String type) async {
      var image;
      if (type == 'camera') {
        image = await ImagePicker().getImage(source: ImageSource.camera);
      } else if (type == 'gallery') {
        image = await ImagePicker().getImage(source: ImageSource.gallery);
      }
      if (image != null) {
        File croppedFile = await ImageCropper.cropImage(
            sourcePath: image.path,
            aspectRatio: CropAspectRatio(ratioX: 75, ratioY: 31),
            aspectRatioPresets: Platform.isAndroid
                ? [
                    CropAspectRatioPreset.original,
                  ]
                : [
                    CropAspectRatioPreset.original,
                  ],
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: '编辑图片',
                toolbarColor: Colors.white,
                toolbarWidgetColor: Colors.black,
                // initAspectRatio: CropAspectRatioPreset.ratio16x9,
                lockAspectRatio: true),
            iosUiSettings: IOSUiSettings(
                minimumAspectRatio: 31 / 75,
                // aspectRatioLockEnabled: true,
                aspectRatioPickerButtonHidden: true,
                resetAspectRatioEnabled: false,
                showActivitySheetOnDone: false));
        if (croppedFile != null) {
          String imageUrl = await Api.uploadImage(croppedFile);
          onSuccessCallback(imageUrl);
        }
      }
    });
  }
}
