class AgentMsgList {
  int id;
  int type;
  int subject;
  String title;
  String content;
  String operator;
  int isRead;
  List<Data> data;
  String createdAt;

  AgentMsgList(
      {this.id,
      this.type,
      this.subject,
      this.title,
      this.content,
      this.operator,
      this.isRead,
      this.data,
      this.createdAt});

  AgentMsgList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    subject = json['subject'];
    title = json['title'];
    content = json['content'];
    operator = json['operator'];
    isRead = json['is_read'];
    if (json['data'] != null) {
      data = new List<Data>.empty(growable: true);
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['subject'] = this.subject;
    data['title'] = this.title;
    data['content'] = this.content;
    data['operator'] = this.operator;
    data['is_read'] = this.isRead;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Data {
  String date;
  String name;
  String profit;
  String signer;
  String orderSn;
  String specName;
  var changePrice;
  var originPrice;

  Data(
      {this.date,
      this.name,
      this.profit,
      this.signer,
      this.orderSn,
      this.specName,
      this.changePrice,
      this.originPrice});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    name = json['name'];
    profit = json['profit'];
    signer = json['signer'];
    orderSn = json['order_sn'];
    specName = json['spec_name'];
    changePrice = json['change_price'];
    originPrice = json['origin_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['name'] = this.name;
    data['profit'] = this.profit;
    data['signer'] = this.signer;
    data['order_sn'] = this.orderSn;
    data['spec_name'] = this.specName;
    data['change_price'] = this.changePrice;
    data['origin_price'] = this.originPrice;
    return data;
  }
}
