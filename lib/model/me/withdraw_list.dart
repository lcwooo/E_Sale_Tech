class WithdrawInfo {
  int id;
  int agentId;
  int type;
  String name;
  String amount;
  Info info;
  String createdAt;

  WithdrawInfo(
      {this.id,
      this.agentId,
      this.type,
      this.name,
      this.amount,
      this.info,
      this.createdAt});

  WithdrawInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agentId = json['agent_id'];
    type = json['type'];
    name = json['name'];
    amount = json['amount'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['agent_id'] = this.agentId;
    data['type'] = this.type;
    data['name'] = this.name;
    data['amount'] = this.amount;
    if (this.info != null) {
      data['info'] = this.info.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Info {
  String iban;
  String swiftCode;
  String accountName;
  String accountNumber;

  Info({this.iban, this.swiftCode, this.accountName, this.accountNumber});

  Info.fromJson(Map<String, dynamic> json) {
    iban = json['iban'];
    swiftCode = json['swift_code'];
    accountName = json['account_name'];
    accountNumber = json['account_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iban'] = this.iban;
    data['swift_code'] = this.swiftCode;
    data['account_name'] = this.accountName;
    data['account_number'] = this.accountNumber;
    return data;
  }
}
