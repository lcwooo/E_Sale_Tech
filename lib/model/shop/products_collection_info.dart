import 'package:E_Sale_Tech/model/base_entity.dart';

class ProductsCollectionList {
  List<ProductsCollection> productsCollection;

  ProductsCollectionList({this.productsCollection});

  ProductsCollectionList.fromJson(BaseEntity json) {
    if (json.data != null) {
      productsCollection = new List<ProductsCollection>.empty(growable: true);
      json.data.forEach((v) {
        productsCollection.add(new ProductsCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productsCollection != null) {
      data['data'] = this.productsCollection.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductsCollection {
  int id;
  String name;
  num lowestPrice;
  List<String> majorPhoto;
  List<String> majorThumb;
  int upShelf;
  int isOffShelves; // 值为1 表示不可选 商品所有规格全部被下架需要置灰
  String createdAt;
  String updatedAt;

  ProductsCollection(
      {this.id,
      this.name,
      this.lowestPrice,
      this.majorPhoto,
      this.majorThumb,
      this.upShelf,
      this.isOffShelves,
      this.createdAt,
      this.updatedAt});

  ProductsCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lowestPrice = json['lowest_price'];
    majorPhoto = json['major_photo'].cast<String>();
    majorThumb = json['major_thumb'].cast<String>();
    upShelf = json['up_shelf'];
    isOffShelves = json['is_off_shelves'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['lowest_price'] = this.lowestPrice;
    data['major_photo'] = this.majorPhoto;
    data['major_thumb'] = this.majorThumb;
    data['up_shelf'] = this.upShelf;
    data['is_off_shelves'] = this.isOffShelves;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
