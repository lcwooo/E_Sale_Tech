class MyGoodsInformation {
  String majorThumb;
  String name;
  num price;
  int number;
  int saleNum;
  int isCollect;
  int id;
  bool select;

  MyGoodsInformation(
      {this.majorThumb,
      this.name,
      this.price,
      this.number,
      this.saleNum,
      this.isCollect,
      this.id,
      this.select,});

  MyGoodsInformation.fromJson(Map<String, dynamic> json) {
    majorThumb = json['major_thumb'];
    name = json['name'];
    price = json['price'];
    number = json['num'];
    saleNum = json['sale_num'];
    isCollect = json['is_collect'];
    id = json['id'];
    select = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['major_thumb'] = this.majorThumb;
    data['name'] = this.name;
    data['price'] = this.price;
    data['num'] = this.number;
    data['sale_num'] = this.saleNum;
    data['is_collect'] = this.isCollect;
    data['id'] = this.id;
    return data;
  }
}

