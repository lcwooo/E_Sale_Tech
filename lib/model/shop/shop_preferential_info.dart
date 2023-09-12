class ShopPreferential {
  num lastMonth;
  num currentMonth;
  num target;
  bool applyEnabled;
  bool returnEnabled;
  String specification;

  ShopPreferential(
      {this.lastMonth = 0,
      this.currentMonth = 0,
      this.target = 0,
      this.specification = '',
      this.applyEnabled = false,
      this.returnEnabled = false});

  ShopPreferential.fromJson(Map<String, dynamic> json) {
    lastMonth = json['last_month'];
    currentMonth = json['current_month'];
    target = json['target'];
    applyEnabled = json['apply_enabled'];
    returnEnabled = json['return_enabled'];
    specification = json['specification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_month'] = this.lastMonth;
    data['current_month'] = this.currentMonth;
    data['target'] = this.target;
    data['apply_enabled'] = this.applyEnabled;
    data['return_enabled'] = this.returnEnabled;
    return data;
  }
}
