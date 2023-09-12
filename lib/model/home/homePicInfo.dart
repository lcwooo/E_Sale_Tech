class HomeDataInfo {
  int id;
  String pictureName;
  String picturePath;
  int position;
  int source;
  int type;
  int linkType;
  String linkPath;
  Null createdAt;
  Null updatedAt;
  int sortIndex;
  String fullPath;

  HomeDataInfo(
      {this.id,
      this.pictureName,
      this.picturePath,
      this.position,
      this.source,
      this.type,
      this.linkType,
      this.linkPath,
      this.createdAt,
      this.updatedAt,
      this.sortIndex,
      this.fullPath});

  HomeDataInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pictureName = json['picture_name'];
    picturePath = json['picture_path'];
    position = json['position'];
    source = json['source'];
    type = json['type'];
    linkType = json['link_type'];
    linkPath = json['link_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sortIndex = json['sort_index'];
    fullPath = json['full_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['picture_name'] = this.pictureName;
    data['picture_path'] = this.picturePath;
    data['position'] = this.position;
    data['source'] = this.source;
    data['type'] = this.type;
    data['link_type'] = this.linkType;
    data['link_path'] = this.linkPath;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['sort_index'] = this.sortIndex;
    data['full_path'] = this.fullPath;
    return data;
  }
}

