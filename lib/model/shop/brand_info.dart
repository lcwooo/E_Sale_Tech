import 'package:E_Sale_Tech/model/base_entity.dart';

class BrandDataInfo {
  List<BrandList> brandList;

  BrandDataInfo({this.brandList});

  BrandDataInfo.fromJson(BaseEntity json) {
    if (json.data != null) {
      brandList = new List<BrandList>.empty(growable: true);
      json.data.forEach((v) {
        brandList.add(new BrandList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.brandList != null) {
      data['data'] = this.brandList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BrandList {
  int id;
  String name;
  String icon;
  String adPicture;
  int sortIndex;
  int isShow;
  int isSearch;
  String createdAt;
  String updatedAt;
  bool checked;

  BrandList({
    this.id,
    this.name,
    this.icon,
    this.adPicture,
    this.sortIndex,
    this.isShow,
    this.isSearch,
    this.createdAt,
    this.updatedAt,
    this.checked = false,
  });

  BrandList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    adPicture = json['ad_picture'];
    sortIndex = json['sort_index'];
    isShow = json['is_show'];
    isSearch = json['is_search'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    checked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['ad_picture'] = this.adPicture;
    data['sort_index'] = this.sortIndex;
    data['is_show'] = this.isShow;
    data['is_search'] = this.isSearch;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
