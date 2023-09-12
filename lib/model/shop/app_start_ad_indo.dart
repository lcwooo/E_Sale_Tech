class AppStartAd {
  int id;
  String path;
  int type;
  String linkPath;
  String createdAt;
  String updatedAt;

  AppStartAd(
      {this.id = 0,
      this.path = '',
      this.type = 0,
      this.linkPath = '',
      this.createdAt = '',
      this.updatedAt});

  AppStartAd.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    path = json['path'];
    type = json['type'];
    linkPath = json['link_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['path'] = this.path;
    data['type'] = this.type;
    data['link_path'] = this.linkPath;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
