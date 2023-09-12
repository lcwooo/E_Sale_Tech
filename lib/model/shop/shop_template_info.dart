class ShopTemplateInfo {
  int id;
  int agentId;
  int shopId;
  int templateId;
  String coverPicture;
  String productList;
  String adPicture;
  List<String> adPictureUrls;
  String createdAt;
  String updatedAt;

  ShopTemplateInfo(
      {this.id,
      this.agentId,
      this.shopId,
      this.templateId,
      this.coverPicture,
      this.productList,
      this.adPicture,
      this.adPictureUrls,
      this.createdAt,
      this.updatedAt});

  ShopTemplateInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agentId = json['agent_id'];
    shopId = json['shop_id'];
    templateId = json['template_id'];
    coverPicture = json['cover_picture'];
    productList = json['product_list'];
    adPicture = json['ad_picture'];
    adPictureUrls = json['ad_picture_urls'].cast<String>();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['agent_id'] = this.agentId;
    data['shop_id'] = this.shopId;
    data['template_id'] = this.templateId;
    data['cover_picture'] = this.coverPicture;
    data['product_list'] = this.productList;
    data['ad_picture'] = this.adPicture;
    data['ad_picture_urls'] = this.adPictureUrls;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
