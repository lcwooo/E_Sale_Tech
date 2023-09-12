import 'package:E_Sale_Tech/model/base_entity.dart';

class ProductsList {
  List<ProductsItem> productsList;

  ProductsList({this.productsList});

  ProductsList.fromJson(BaseEntity json) {
    if (json.data != null) {
      productsList = new List<ProductsItem>.empty(growable: true);
      json.data.forEach((v) {
        productsList.add(new ProductsItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productsList != null) {
      data['products_item'] = this.productsList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductsItem {
  int id;
  int number;
  List<String> majorPhoto;
  List<String> majorThumb;
  String remark;
  String totalPrice;
  String createdAt;
  String updatedAt;
  String name;
  bool checked = false;
  num lowestPrice;

  ProductsItem(
      {this.id,
      this.number,
      this.majorPhoto,
      this.majorThumb,
      this.remark,
      this.totalPrice,
      this.createdAt,
      this.checked,
      this.name,
      this.lowestPrice,
      this.updatedAt});

  ProductsItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['num'];
    name = json['name'];
    lowestPrice = json['lowest_price'];
    majorPhoto = json['major_photo'].cast<String>();
    majorThumb = json['major_thumb'].cast<String>();
    remark = json['remark'];
    totalPrice = json['total_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['num'] = this.number;
    data['name'] = this.name;
    data['major_photo'] = this.majorPhoto;
    data['major_thumb'] = this.majorThumb;
    data['remark'] = this.remark;
    data['total_price'] = this.totalPrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
