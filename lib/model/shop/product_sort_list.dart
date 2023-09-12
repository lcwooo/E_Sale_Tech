class ProductsSortList {
  List<Data> data;

  ProductsSortList({this.data});

  ProductsSortList.fromJson(List json) {
    if (json != null) {
      data = new List<Data>.empty(growable: true);
      json.forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  String name;
  int index;
  int status;
  num price;
  num maxPrice;
  String createdAt;
  String majorThumb;

  Data(
      {this.id,
      this.name,
      this.index,
      this.status,
      this.price,
      this.maxPrice,
      this.majorThumb,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    index = json['index'];
    status = json['status'];
    price = json['price'];
    maxPrice = json['max_price'];
    createdAt = json['created_at'];
    majorThumb = json['major_thumb'][0];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['index'] = this.index;
    data['status'] = this.status;
    data['price'] = this.price;
    data['max_price'] = this.maxPrice;
    data['created_at'] = this.createdAt;
    data['major_thumb'] = this.majorThumb;
    return data;
  }
}
