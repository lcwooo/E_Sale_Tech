import 'package:E_Sale_Tech/model/base_entity.dart';

class OrdersInfo {
  List<OrdersListInfo> ordersList;

  OrdersInfo({this.ordersList});

  OrdersInfo.fromJson(BaseEntity json) {
    if (json.data != null) {
      ordersList = new List<OrdersListInfo>.empty(growable: true);
      json.data.forEach((v) {
        ordersList.add(new OrdersListInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ordersList != null) {
      data['data'] = this.ordersList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrdersListInfo {
  int id;
  String orderSn;
  int owner;
  int status;
  String statusName;
  String name;
  List<OrdersOrderItem> ordersOrderItem;
  OrdersAddress ordersAddress;
  OrdersExpress ordersExpress;
  OrdersPayment ordersPayment;
  int qty;
  String createdAt;
  String signedAt;
  String paidAt;
  String updatedAt;
  String remark;
  OrdersUser user;
  int type;

  OrdersListInfo(
      {this.id,
      this.orderSn,
      this.owner,
      this.status,
      this.statusName,
      this.name,
      this.ordersOrderItem,
      this.ordersAddress,
      this.ordersExpress,
      this.ordersPayment,
      this.qty,
      this.createdAt,
      this.signedAt,
      this.paidAt,
      this.updatedAt,
      this.remark,
      this.user,
      this.type});

  OrdersListInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderSn = json['order_sn'];
    owner = json['owner'];
    status = json['status'];
    statusName = json['status_name'];
    name = json['name'];
    remark = json['remark'];
    type = json['type'];
    if (json['user'] != null) {
      user = OrdersUser.fromJson(json['user']);
    } else {
      user = OrdersUser();
    }
    if (json['order_item'] != null) {
      ordersOrderItem = new List<OrdersOrderItem>.empty(growable: true);
      json['order_item'].forEach((v) {
        ordersOrderItem.add(new OrdersOrderItem.fromJson(v));
      });
    }
    ordersAddress = json['address'] != null
        ? new OrdersAddress.fromJson(json['address'])
        : new OrdersAddress();
    ordersExpress = json['express'] != null
        ? new OrdersExpress.fromJson(json['express'])
        : new OrdersExpress();
    ordersPayment = json['payment'] != null
        ? new OrdersPayment.fromJson(json['payment'])
        : new OrdersPayment();
    qty = json['qty'];
    createdAt = json['created_at'];
    signedAt = json['signed_at'];
    paidAt = json['paid_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_sn'] = this.orderSn;
    data['status'] = this.status;
    data['status_name'] = this.statusName;
    data['name'] = this.name;
    if (this.ordersOrderItem != null) {
      data['order_item'] = this.ordersOrderItem.map((v) => v.toJson()).toList();
    }
    if (this.ordersAddress != null) {
      data['address'] = this.ordersAddress.toJson();
    }
    if (this.ordersExpress != null) {
      data['express'] = this.ordersExpress.toJson();
    }
    if (this.ordersPayment != null) {
      data['payment'] = this.ordersPayment.toJson();
    }
    data['qty'] = this.qty;
    data['created_at'] = this.createdAt;
    data['paid_at'] = this.paidAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class OrdersOrderItem {
  int id;
  int orderId;
  int goodsId;
  String specName;
  String name;
  int qty;
  num price;
  String imageUrl;
  String createdAt;

  OrdersOrderItem(
      {this.id,
      this.orderId,
      this.goodsId,
      this.specName,
      this.name,
      this.qty,
      this.price,
      this.imageUrl,
      this.createdAt});

  OrdersOrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    goodsId = json['goods_id'];
    specName = json['spec_name'];
    name = json['name'];
    qty = json['qty'];
    price = json['price'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['goods_id'] = this.goodsId;
    data['spec_name'] = this.specName;
    data['name'] = this.name;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['image_url'] = this.imageUrl;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class OrdersUser {
  int id;
  String name;
  String phone;
  OrdersUser({this.id, this.name, this.phone});
  OrdersUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
  }
}

class OrdersAddress {
  int id;
  int orderId;
  String provinces;
  String address;
  String postcode;
  String mobile;
  String name;
  String idCard;
  Null isDefault;
  String createdAt;

  OrdersAddress(
      {this.id,
      this.orderId,
      this.provinces,
      this.address,
      this.postcode,
      this.mobile,
      this.name,
      this.idCard,
      this.isDefault,
      this.createdAt});

  OrdersAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    provinces = json['provinces'];
    address = json['address'];
    postcode = json['postcode'];
    mobile = json['mobile'];
    name = json['name'];
    idCard = json['id_card'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['provinces'] = this.provinces;
    data['address'] = this.address;
    data['postcode'] = this.postcode;
    data['mobile'] = this.mobile;
    data['name'] = this.name;
    data['id_card'] = this.idCard;
    data['is_default'] = this.isDefault;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class OrdersExpress {
  String name;
  String number;

  OrdersExpress({this.name, this.number});

  OrdersExpress.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['number'] = this.number;
    return data;
  }
}

class OrdersPayment {
  num taxFee;
  num itemFee;
  num couponDiscountFee;
  num paymentFee;
  num costPrice;
  num profit;
  String paymentMethod;
  int closeAfter;

  OrdersPayment(
      {this.taxFee,
      this.itemFee,
      this.couponDiscountFee,
      this.paymentFee,
      this.costPrice,
      this.profit,
      this.closeAfter,
      this.paymentMethod});

  OrdersPayment.fromJson(Map<String, dynamic> json) {
    taxFee = json['tax_fee'];
    itemFee = json['item_fee'];
    couponDiscountFee = json['coupon_discount_fee'];
    paymentFee = json['payment_fee'];
    costPrice = json['cost_price'];
    profit = json['profit'];
    closeAfter = json['close_after'];
    paymentMethod = json['payment_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tax_fee'] = this.taxFee;
    data['item_fee'] = this.itemFee;
    data['coupon_discount_fee'] = this.couponDiscountFee;
    data['payment_fee'] = this.paymentFee;
    data['cost_price'] = this.costPrice;
    data['profit'] = this.profit;
    data['payment_method'] = this.paymentMethod;
    return data;
  }
}
