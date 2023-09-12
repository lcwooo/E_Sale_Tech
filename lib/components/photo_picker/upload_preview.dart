import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotpGalleryPage extends StatefulWidget {
  final List photoList;
  final int index;
  final bool isNeedDelete;
  PhotpGalleryPage({this.photoList, this.index = 0, this.isNeedDelete = true});
  @override
  _PhotpGalleryPageState createState() => _PhotpGalleryPageState();
}

class _PhotpGalleryPageState extends State<PhotpGalleryPage> {
  @override
  int currentIndex = 0;
  int initialIndex; //初始index
  int length;
  int title;
  @override
  void initState() {
    currentIndex = widget.index;
    initialIndex = widget.index;
    length = widget.photoList.length;
    title = initialIndex + 1;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
      title = index + 1;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5745C5),
        title: Text('$title / $length'),
        centerTitle: true,
      ),
      body: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              PhotoViewGallery.builder(
                scrollDirection: Axis.horizontal,
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(widget.photoList[index]),
                    initialScale: PhotoViewComputedScale.contained * 1,
                    // heroTag: widget.photoList[index]['id'],
                  );
                },
                loadingChild: Text('Loading...'),
                itemCount: widget.photoList.length,
                backgroundDecoration: BoxDecoration(
                  color: Colors.black,
                ),
                pageController:
                    PageController(initialPage: initialIndex), //点进去哪页默认就显示哪一页
                onPageChanged: onPageChanged,
              ),
              widget.isNeedDelete
                  ? Positioned(
                      right: 30.0,
                      bottom: 10,
                      child: Theme(
                        data: ThemeData(
                            buttonTheme: ButtonThemeData(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          minWidth: 60.0,
                        )),
                        child: GestureDetector(
                          onTap: () {
                            widget.photoList.removeAt(currentIndex);
                            setState(() {
                              initialIndex = currentIndex - 1;
                              length = widget.photoList.length;
                              if (length == 0) {
                                Navigator.pop(context);
                              }
                            });
                          },
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                    )
                  : Text(''),
            ],
          )),
    );
  }
}
