class GoodsDetailInfo {
  int id;
  List<String> majorPhoto;
  List<String> majorThumb;
  String name;
  String shareurl;
  String sharepath;
  num specPrice;
  num totalPrice;
  int number;
  List<Goods> goods;
  String description;
  String unitContent;
  List<String> detailDescription;
  bool isCollect;
  int shopProductStatus;
  String originName;
  String createdAt;
  String updatedAt;

  GoodsDetailInfo(
      {this.id,
      this.majorPhoto,
      this.majorThumb,
      this.name,
      this.shareurl,
      this.sharepath,
      this.specPrice,
      this.totalPrice,
      this.number,
      this.goods,
      this.description,
      this.unitContent,
      this.detailDescription,
      this.isCollect,
      this.shopProductStatus,
      this.originName,
      this.createdAt,
      this.updatedAt});

  GoodsDetailInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    majorPhoto = json['major_photo'].cast<String>();
    majorThumb = json['major_thumb'].cast<String>();
    name = json['name'];
    shareurl = json['share_url'];
    sharepath = json['share_path'];
    specPrice = json['spec_price'];
    totalPrice = json['total_price'];
    number = json['num'];
    if (json['goods'] != null) {
      goods = new List<Goods>.empty(growable: true);
      json['goods'].forEach((v) {
        goods.add(new Goods.fromJson(v));
      });
    }
    description = json['description'];
    unitContent = json['unit_content'];
    detailDescription = json['detail_description'].cast<String>();
    isCollect = json['is_collect'];
    shopProductStatus = json['shop_product_status'];
    originName = json['origin_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['major_photo'] = this.majorPhoto;
    data['major_thumb'] = this.majorThumb;
    data['name'] = this.name;
    data['share_url'] = this.shareurl;
    data['share_path'] = this.sharepath;
    data['spec_price'] = this.specPrice;
    data['total_price'] = this.totalPrice;
    data['num'] = this.number;
    if (this.goods != null) {
      data['goods'] = this.goods.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['unit_content'] = this.unitContent;
    data['detail_description'] = this.detailDescription;
    data['is_collect'] = this.isCollect;
    data['shop_product_status'] = this.shopProductStatus;
    data['origin_name'] = this.originName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Goods {
  int id;
  int productId;
  String specName;
  num specPrice;
  num totalPrice;
  num lowestPrice;
  num discountPrice;
  num averagePrice;
  int number;
  int specNum;
  int salable;
  int lockNum;
  String relevanceCode;
  num weight;
  int isShow;
  int status;
  int saleNum;
  String bbd;
  String createdAt;
  String updatedAt;

  Goods(
      {this.id,
      this.productId,
      this.specName,
      this.specPrice,
      this.discountPrice,
      this.totalPrice,
      this.lowestPrice,
      this.averagePrice,
      this.number,
      this.specNum,
      this.salable,
      this.lockNum,
      this.relevanceCode,
      this.weight,
      this.isShow,
      this.status,
      this.saleNum,
      this.bbd,
      this.createdAt,
      this.updatedAt});

  Goods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    specName = json['spec_name'];
    specPrice = json['spec_price'];
    discountPrice = json["discount_price"];
    totalPrice = json['total_price'];
    lowestPrice = json['lowest_price'];
    averagePrice = json['average_price'];
    number = json['num'];
    salable = json['salable'];
    specNum = json['spec_num'];
    lockNum = json['lock_num'];
    relevanceCode = json['relevance_code'];
    weight = json['weight'];
    isShow = json['is_show'];
    status = json['status'];
    saleNum = json['sale_num'];
    bbd = json['bbd'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['spec_name'] = this.specName;
    data['spec_price'] = this.specPrice;
    data['discount_price'] = this.discountPrice;
    data['total_price'] = this.totalPrice;
    data['lowest_price'] = this.lowestPrice;
    data['average_price'] = this.averagePrice;
    data['num'] = this.number;
    data['salable'] = this.salable;
    data['spec_num'] = this.specNum;
    data['lock_num'] = this.lockNum;
    data['relevance_code'] = this.relevanceCode;
    data['weight'] = this.weight;
    data['is_show'] = this.isShow;
    data['status'] = this.status;
    data['sale_num'] = this.saleNum;
    data['bbd'] = this.bbd;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
