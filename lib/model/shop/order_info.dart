///订单管理
class OrderInfo {
  int id;
  String statusName;
  String orderSn;
  num price;
  int userId;
  dynamic goodsList;

  OrderInfo(
      {this.id,
      this.userId,
      this.price,
      this.orderSn,
      this.goodsList,
      this.statusName});

  factory OrderInfo.fromJson(Map<String, dynamic> data) {
    return OrderInfo(
      id: data["id"],
      orderSn: data["order_sn"] ?? '',
      userId: data["user_id"] ?? '',
      price: data["price"],
      goodsList: data["goods_list"],
    );
  }
}
