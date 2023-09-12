class AgentInvoiceList {
  int id;
  int type;
  String number;
  String link;
  double amount;
  String createdAt;

  AgentInvoiceList(
      {this.id,
      this.type,
      this.number,
      this.link,
      this.amount,
      this.createdAt});

  AgentInvoiceList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    number = json['number'];
    link = json['link'];
    amount = json['amount'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['number'] = this.number;
    data['link'] = this.link;
    data['amount'] = this.amount;
    data['created_at'] = this.createdAt;
    return data;
  }
}
