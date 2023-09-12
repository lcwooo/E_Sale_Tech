import 'dart:io';

// library
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

// model
import 'package:E_Sale_Tech/model/photo_info.dart';

// component
import 'package:E_Sale_Tech/api/common.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/components/photo_picker/upload_preview.dart';

class UploadPhotoPicker extends StatefulWidget {
  UploadPhotoPicker({
    Key key,
    this.photoInfo,
    this.onSort,
    this.onDelete,
    this.onUploaded,
    this.isUploadMultiple = false,
    this.maxUploadNumber = 1,
    this.photoList,
  });
  final PhotoInfo photoInfo;
  final Function onSort;
  final Function onDelete;
  final Function onUploaded;
  final int maxUploadNumber;

  /// 是否可以上传多张
  final bool isUploadMultiple;
  final List photoList;

  @override
  State<StatefulWidget> createState() {
    return _UploadPhotoPicker();
  }
}

class _UploadPhotoPicker extends State<UploadPhotoPicker> {
  final myWidgetStateKey = new GlobalKey<_UploadPhotoPicker>();
  final ScrollController _scrollCtrl = ScrollController();
  final Color textColor = Color(0xff727272);
  static var photoEvent;
  static var contextData;
  @override
  void initState() {
    super.initState();
    contextData = context;
    initEvent();
  }

  initEvent() {
    photoEvent = ApplicationEvent.event.on<PhotoPickerEvent>().listen((event) {
      showModal(contextData);
    });
  }

  Future<String> uploadToApi(File image) async {
    String url = await Api.uploadImage(image);
    return url;
  }

  void previewPhoto({List imgs, int index = 0}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PhotpGalleryPage(photoList: widget.photoList, index: index)),
    );
  }

  Future<Null> cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      maxWidth: 800,
      maxHeight: 800,
    );

    return croppedFile;
  }

  /*选择上传方式*/
  Future<void> selectPhotoMethod(String type) async {
    var image;
    if (type == 'camera') {
      image = await ImagePicker().getImage(source: ImageSource.camera);
    } else if (type == 'gallery') {
      image = await ImagePicker().getImage(source: ImageSource.camera);
    }
    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (croppedFile != null) {
        String imageUrl = await uploadToApi(croppedFile);
        setState(() {
          if (widget.isUploadMultiple) {
            widget.photoList.add(imageUrl);
          } else {
            if (widget.photoList.length == 0) {
              widget.photoList.add(imageUrl);
            } else {
              widget.photoList[0] = imageUrl;
            }
          }
          widget.onUploaded(imageUrl);
        });
      }
    }
  }

  List<Widget> selectDialogMethods() {
    List<Widget> listTile = List<Widget>.empty(growable: true);
    if (widget.isUploadMultiple == false && widget.photoList.length >= 1) {
      listTile.add(new ListTile(
        leading: new Icon(Icons.photo_size_select_actual),
        title: new Text("查看图片"),
        onTap: () {
          Navigator.of(context).pop();
          previewPhoto(imgs: widget.photoList);
        },
      ));
    }
    listTile
      ..add(new ListTile(
        leading: new Icon(Icons.photo_camera),
        title: new Text("用手机拍照"),
        onTap: () async {
          Navigator.of(context).pop();
          await selectPhotoMethod('camera');
        },
      ))
      ..add(new ListTile(
        leading: new Icon(Icons.photo_library),
        title: new Text("相册中读取"),
        onTap: () async {
          Navigator.of(context).pop();
          await selectPhotoMethod('gallery');
        },
      ));
    return listTile;
  }

  void showModal(BuildContext context) {
    showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: selectDialogMethods(),
          );
        });
  }

  Widget pickerWidget() {
    var iconAdd = Icon(
      Icons.add,
      color: textColor,
    );
    var photo = Image.network(
      widget.photoList.length >= 1 ? widget.photoList[0] : '',
      width: 44.0,
      height: 44.0,
      fit: BoxFit.cover,
    );
    var imgSrc = new Container(
        margin: const EdgeInsets.all(5),
        height: 44.0,
        width: 44.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        child: widget.isUploadMultiple
            ? iconAdd
            : widget.photoList.length >= 1
                ? photo
                : iconAdd);

    var img = new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        if (widget.maxUploadNumber != 1 &&
            widget.photoList.length >= widget.maxUploadNumber) {
          Util.showSnackBar(context, "图片不能超过${widget.maxUploadNumber}张");
          return;
        }
        showModal(context);
      },
      child: imgSrc,
    );

    return new Container(
        child: new Stack(
            alignment: AlignmentDirectional.topCenter,
            textDirection: TextDirection.ltr,
            fit: StackFit.loose,
            children: [img]));
  }

  Widget renderPhotoItem(int index, String items) {
    return GestureDetector(
        onTap: () {
          previewPhoto(imgs: widget.photoList, index: index);
        },
        child: Container(
          child: Image.network(
            items,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ));
  }

  IndexedWidgetBuilder _itemBuilder() {
    return (context, index) {
      return renderPhotoItem(index, widget.photoList[index]);
    };
  }

  @override
  void dispose() {
    photoEvent.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        key: myWidgetStateKey,
        child: Column(
          children: <Widget>[
            (widget.isUploadMultiple && widget.photoList.length > 0)
                ? Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 80,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.photoList.length,
                                cacheExtent: 0,
                                shrinkWrap: true,
                                itemBuilder: _itemBuilder(),
                                controller: _scrollCtrl)),
                      )
                    ],
                  )
                : Container(width: 0, height: 0),
            pickerWidget()
          ],
        ));
  }
}
