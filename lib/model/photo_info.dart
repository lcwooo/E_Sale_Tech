import 'dart:io';

var _id = 0;

///图片
class PhotoInfo {
  int id;
  String url;
  int sortNum;
  File imageFile;

  PhotoInfo({this.id, this.url, this.sortNum, this.imageFile});

  factory PhotoInfo.fromJson(dynamic json) {
    if (json is Map && json.containsKey("path") && !json.containsKey("url")) {
      json['url'] = json['path'];
    }
    // if (json is Map && !json.containsKey("id")) {
    //   json['id'] = 0;
    // }
    return PhotoInfo(
      id: (json is String) ? ++_id : json['id'],
      url: (json is String) ? json : json['url'],
    );
  }
}
