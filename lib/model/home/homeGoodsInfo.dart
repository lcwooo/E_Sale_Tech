class HomeGoodsInfo {
  Null description;
  int status;
  int warehouseId;
  int isForSale;
  Null keyword;
  Null detailDescription;
  String updatedAt;
  int lockNum;
  int isNew;
  String saleTime;
  int saleNum;
  int brandId;
  String name;
  int type;
  int id;
  int num;
  String lowestPrice;
  Null originId;
  String createdAt;
  int unitId;
  int categoryId;
  List<String> majorPhoto;
  Null remark;
  List<String> majorThumb;

  HomeGoodsInfo(
      {this.description,
      this.status,
      this.warehouseId,
      this.isForSale,
      this.keyword,
      this.detailDescription,
      this.updatedAt,
      this.lockNum,
      this.isNew,
      this.saleTime,
      this.saleNum,
      this.brandId,
      this.name,
      this.type,
      this.id,
      this.num,
      this.lowestPrice,
      this.originId,
      this.createdAt,
      this.unitId,
      this.categoryId,
      this.majorPhoto,
      this.remark,
      this.majorThumb});

  HomeGoodsInfo.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    status = json['status'];
    warehouseId = json['warehouse_id'];
    isForSale = json['is_for_sale'];
    keyword = json['keyword'];
    detailDescription = json['detail_description'];
    updatedAt = json['updated_at'];
    lockNum = json['lock_num'];
    isNew = json['is_new'];
    saleTime = json['sale_time'];
    saleNum = json['sale_num'];
    brandId = json['brand_id'];
    name = json['name'];
    type = json['type'];
    id = json['id'];
    num = json['num'];
    lowestPrice = json['lowest_price'];
    originId = json['origin_id'];
    createdAt = json['created_at'];
    unitId = json['unit_id'];
    categoryId = json['category_id'];
    majorPhoto = json['major_photo'].cast<String>();
    remark = json['remark'];
    majorThumb = json['major_thumb'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['status'] = this.status;
    data['warehouse_id'] = this.warehouseId;
    data['is_for_sale'] = this.isForSale;
    data['keyword'] = this.keyword;
    data['detail_description'] = this.detailDescription;
    data['updated_at'] = this.updatedAt;
    data['lock_num'] = this.lockNum;
    data['is_new'] = this.isNew;
    data['sale_time'] = this.saleTime;
    data['sale_num'] = this.saleNum;
    data['brand_id'] = this.brandId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['id'] = this.id;
    data['num'] = this.num;
    data['lowest_price'] = this.lowestPrice;
    data['origin_id'] = this.originId;
    data['created_at'] = this.createdAt;
    data['unit_id'] = this.unitId;
    data['category_id'] = this.categoryId;
    data['major_photo'] = this.majorPhoto;
    data['remark'] = this.remark;
    data['major_thumb'] = this.majorThumb;
    return data;
  }
}

