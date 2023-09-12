import 'package:E_Sale_Tech/model/base_entity.dart';

class CouponsDataInfo {
  List<CouponsList> couponsList;

  CouponsDataInfo({this.couponsList});

  CouponsDataInfo.fromJson(BaseEntity json) {
    if (json.data != null) {
      couponsList = new List<CouponsList>.empty(growable: true);
      json.data.forEach((v) {
        couponsList.add(new CouponsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.couponsList != null) {
      data['data'] = this.couponsList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CouponsList {
  int id;
  int type;
  String name;
  String statusName;
  int scope;
  String amount;
  String threshold;
  int dispatchAmount;
  String beginTime;
  int customerLimit;
  String endTime;
  String remark;
  int shareEnabled;

  CouponsList(
      {this.id,
      this.type,
      this.name,
      this.statusName,
      this.scope,
      this.amount,
      this.threshold,
      this.dispatchAmount,
      this.beginTime,
      this.customerLimit,
      this.endTime,
      this.remark,
      this.shareEnabled});

  CouponsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    statusName = json['status_name'];
    scope = json['scope'];
    amount = json['amount'];
    threshold = json['threshold'];
    dispatchAmount = json['dispatch_amount'];
    beginTime = json['begin_time'];
    customerLimit = json['customer_limit'];
    endTime = json['end_time'];
    remark = json['remark'];
    shareEnabled = json['share_enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['scope'] = this.scope;
    data['amount'] = this.amount;
    data['threshold'] = this.threshold;
    data['dispatch_amount'] = this.dispatchAmount;
    data['begin_time'] = this.beginTime;
    data['customer_limit'] = this.customerLimit;
    data['end_time'] = this.endTime;
    data['remark'] = this.remark;
    data['share_enabled'] = this.shareEnabled;
    return data;
  }
}
