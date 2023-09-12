class ShopInfo {
  int id;
  String name;
  String logo;
  String signature;
  Template template;
  ShopQrCode shopQrCode;
  int goodsCount;
  int visitorCount;
  num earningsCount;
  String shareCode;
  String qrCode;
  String h5Url;

  ShopInfo(
      {this.id = 0,
      this.name = '',
      this.logo = '',
      this.signature = '',
      this.shareCode = '',
      this.qrCode = '',
      this.h5Url = '',
      this.template,
      this.shopQrCode,
      this.goodsCount = 0,
      this.visitorCount = 0,
      this.earningsCount = 0});

  ShopInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    shareCode = json['share_code'];
    qrCode = json['qr_code'];
    h5Url = json['h5_share_url'];
    signature = json['signature'];
    template = json['template'] != null
        ? new Template.fromJson(json['template'])
        : null;
    shopQrCode = json['shop_qr_code'] != null
        ? new ShopQrCode.fromJson(json['shop_qr_code'])
        : null;
    goodsCount = json['goods_count'];
    visitorCount = json['visitor_count'];
    earningsCount = json['earnings_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['signature'] = this.signature;
    if (this.template != null) {
      data['template'] = this.template.toJson();
    }
    if (this.shopQrCode != null) {
      data['shop_qr_code'] = this.shopQrCode.toJson();
    }
    data['goods_count'] = this.goodsCount;
    data['visitor_count'] = this.visitorCount;
    data['earnings_count'] = this.earningsCount;
    return data;
  }
}

class Template {
  int id;
  String name;

  Template({this.id, this.name});

  Template.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class ShopQrCode {
  String description;
  String name;
  String picture;
  String qrCode;

  ShopQrCode(
      {this.description = '',
      this.name = '',
      this.picture = '',
      this.qrCode = ''});

  ShopQrCode.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    name = json['name'];
    picture = json['picture'];
    qrCode = json['qr_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['name'] = this.name;
    data['picture'] = this.picture;
    data['qr_code'] = this.qrCode;
    return data;
  }
}
