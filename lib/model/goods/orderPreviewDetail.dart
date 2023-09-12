class OrderPreviewDetail {
  String warehouseName;
  num itemFee;
  num taxFee;
  num expressFee;
  num paymentFee;
  Address address;
  List<PaymentList> paymentList;

  OrderPreviewDetail(
      {this.warehouseName,
      this.itemFee,
      this.taxFee,
      this.expressFee,
      this.paymentFee,
      this.address,
      this.paymentList});

  OrderPreviewDetail.fromJson(Map<String, dynamic> json) {
    warehouseName = json['warehouse_name'];
    itemFee = json['item_fee'];
    taxFee = json['tax_fee'];
    expressFee = json['express_fee'];
    paymentFee = json['payment_fee'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    if (json['payment_list'] != null) {
      paymentList = new List<PaymentList>.empty(growable: true);
      json['payment_list'].forEach((v) {
        paymentList.add(new PaymentList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['warehouse_name'] = this.warehouseName;
    data['item_fee'] = this.itemFee;
    data['tax_fee'] = this.taxFee;
    data['express_fee'] = this.expressFee;
    data['payment_fee'] = this.paymentFee;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.paymentList != null) {
      data['payment_list'] = this.paymentList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Address {
  int id;
  int userId;
  int agentId;
  int type;
  String provinces;
  String address;
  String postcode;
  String mobile;
  String name;
  String idCard;
  int isVerified;
  int isDefault;
  String backImage;
  String frontImage;
  String userType;
  String createdAt;
  String updatedAt;
  String doorNo;
  String country;

  Address(
      {this.id,
      this.userId,
      this.agentId,
      this.type,
      this.provinces,
      this.address,
      this.postcode,
      this.mobile,
      this.name,
      this.idCard,
      this.isVerified,
      this.isDefault,
      this.backImage,
      this.frontImage,
      this.userType,
      this.createdAt,
      this.updatedAt,
      this.doorNo,
      this.country});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    agentId = json['agent_id'];
    type = json['type'];
    provinces = json['provinces'];
    address = json['address'];
    postcode = json['postcode'];
    doorNo = json['door_no'];
    country = json['country'];
    mobile = json['mobile'];
    name = json['name'];
    idCard = json['id_card'];
    isVerified = json['is_verified'];
    isDefault = json['is_default'];
    backImage = json['back_image'];
    frontImage = json['front_image'];
    userType = json['user_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['agent_id'] = this.agentId;
    data['type'] = this.type;
    data['provinces'] = this.provinces;
    data['address'] = this.address;
    data['postcode'] = this.postcode;
    data['mobile'] = this.mobile;
    data['name'] = this.name;
    data['id_card'] = this.idCard;
    data['is_verified'] = this.isVerified;
    data['is_default'] = this.isDefault;
    data['back_image'] = this.backImage;
    data['front_image'] = this.frontImage;
    data['user_type'] = this.userType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class PaymentList {
  String name;
  String icon;
  int id;

  PaymentList({this.name, this.icon, this.id});

  PaymentList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['id'] = this.id;
    return data;
  }
}
