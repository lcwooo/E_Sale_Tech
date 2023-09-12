import 'package:E_Sale_Tech/model/home/hot_sale.dart';

import 'pictures.dart';

class HomeDataInfo {
  List<HotSale> forSale;
  List<HotSale> hotSale;
  List<HotSale> brandsSale;
  Pictures pictures;

  HomeDataInfo({this.forSale, this.hotSale, this.brandsSale, this.pictures});

  HomeDataInfo.fromJson(Map<String, dynamic> json) {
    if (json['for_sale'] != null) {
      forSale = new List<HotSale>.empty(growable: true);
      json['for_sale'].forEach((v) {
        forSale.add(new HotSale.fromJson(v));
      });
    }
    if (json['hot_sale'] != null) {
      hotSale = new List<HotSale>.empty(growable: true);
      json['hot_sale'].forEach((v) {
        hotSale.add(new HotSale.fromJson(v));
      });
    }
    if (json['brands_sale'] != null) {
      brandsSale = new List<HotSale>.empty(growable: true);
      json['brands_sale'].forEach((v) {
        brandsSale.add(new HotSale.fromJson(v));
      });
    }
    pictures = json['pictures'] != null
        ? new Pictures.fromJson(json['pictures'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.forSale != null) {
      data['for_sale'] = this.forSale.map((v) => v.toJson()).toList();
    }
    if (this.hotSale != null) {
      data['hot_sale'] = this.hotSale.map((v) => v.toJson()).toList();
    }
    if (this.brandsSale != null) {
      data['brands_sale'] = this.brandsSale.map((v) => v.toJson()).toList();
    }
    if (this.pictures != null) {
      data['pictures'] = this.pictures.toJson();
    }
    return data;
  }
}

class ForSale {
  String lowestPrice;
  List<String> majorPhoto;
  List<String> majorThumb;

  ForSale({this.lowestPrice, this.majorPhoto, this.majorThumb});

  ForSale.fromJson(Map<String, dynamic> json) {
    lowestPrice = json['lowest_price'];
    majorPhoto = json['major_photo'].cast<String>();
    majorThumb = json['major_thumb'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lowest_price'] = this.lowestPrice;
    data['major_photo'] = this.majorPhoto;
    data['major_thumb'] = this.majorThumb;
    return data;
  }
}

class HotSale {
  int id;
  int warehouseId;
  int categoryId;
  String lowestPrice;
  int isForSale;
  int isNew;
  int unitId;
  int originId;
  int brandId;
  int num;
  List<String> majorPhoto;
  List<String> majorThumb;
  String remark;
  int status;
  String saleTime;
  int type;
  int saleNum;
  String keyword;
  String description;
  List<String> detailDescription;
  String createdAt;
  String updatedAt;
  String name;
  int lockNum;

  HotSale(
      {this.id,
      this.warehouseId,
      this.categoryId,
      this.lowestPrice,
      this.isForSale,
      this.isNew,
      this.unitId,
      this.originId,
      this.brandId,
      this.num,
      this.majorPhoto,
      this.majorThumb,
      this.remark,
      this.status,
      this.saleTime,
      this.type,
      this.saleNum,
      this.keyword,
      this.description,
      this.detailDescription,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.lockNum});

  HotSale.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warehouseId = json['warehouse_id'];
    categoryId = json['category_id'];
    lowestPrice = json['lowest_price'];
    isForSale = json['is_for_sale'];
    isNew = json['is_new'];
    unitId = json['unit_id'];
    originId = json['origin_id'];
    brandId = json['brand_id'];
    num = json['num'];
    majorPhoto = json['major_photo'].cast<String>();
    majorThumb = json['major_thumb'].cast<String>();
    remark = json['remark'];
    status = json['status'];
    saleTime = json['sale_time'];
    type = json['type'];
    saleNum = json['sale_num'];
    keyword = json['keyword'];
    description = json['description'];
    detailDescription = json['detail_description'].cast<String>();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    lockNum = json['lock_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['warehouse_id'] = this.warehouseId;
    data['category_id'] = this.categoryId;
    data['lowest_price'] = this.lowestPrice;
    data['is_for_sale'] = this.isForSale;
    data['is_new'] = this.isNew;
    data['unit_id'] = this.unitId;
    data['origin_id'] = this.originId;
    data['brand_id'] = this.brandId;
    data['num'] = this.num;
    data['major_photo'] = this.majorPhoto;
    data['major_thumb'] = this.majorThumb;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['sale_time'] = this.saleTime;
    data['type'] = this.type;
    data['sale_num'] = this.saleNum;
    data['keyword'] = this.keyword;
    data['description'] = this.description;
    data['detail_description'] = this.detailDescription;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['lock_num'] = this.lockNum;
    return data;
  }
}

class Brands {
  int id;
  String icon;
  int sortIndex;
  int isShow;
  int isSearch;
  String createdAt;
  Null updatedAt;
  String name;

  Brands(
      {this.id,
      this.icon,
      this.sortIndex,
      this.isShow,
      this.isSearch,
      this.createdAt,
      this.updatedAt,
      this.name});

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icon = json['icon'];
    sortIndex = json['sort_index'];
    isShow = json['is_show'];
    isSearch = json['is_search'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['icon'] = this.icon;
    data['sort_index'] = this.sortIndex;
    data['is_show'] = this.isShow;
    data['is_search'] = this.isSearch;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    return data;
  }
}
