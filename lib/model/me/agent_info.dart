class AgentInfo {
  int id;
  String timezone;
  String phone;
  String name;
  int groupId;
  String email;
  String country;
  String address;
  int checked;
  int isVerified;
  String remark;
  int normal;
  String avatar;
  String createdAt;
  String updatedAt;
  int forbidLogin;
  int forbidShop;

  AgentInfo(
      {this.id,
      this.timezone,
      this.phone,
      this.name,
      this.groupId,
      this.email,
      this.country,
      this.address,
      this.checked,
      this.isVerified,
      this.remark,
      this.normal,
      this.avatar,
      this.createdAt,
      this.updatedAt,
      this.forbidLogin,
      this.forbidShop});

  AgentInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timezone = json['timezone'];
    phone = json['phone'];
    name = json['name'];
    groupId = json['group_id'];
    email = json['email'];
    country = json['country'];
    address = json['address'];
    checked = json['checked'];
    isVerified = json['is_verified'];
    remark = json['remark'];
    normal = json['normal'];
    avatar = json['avatar'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    forbidLogin = json['forbid_login'];
    forbidShop = json['forbid_shop'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timezone'] = this.timezone;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['group_id'] = this.groupId;
    data['email'] = this.email;
    data['country'] = this.country;
    data['address'] = this.address;
    data['checked'] = this.checked;
    data['is_verified'] = this.isVerified;
    data['remark'] = this.remark;
    data['normal'] = this.normal;
    data['avatar'] = this.avatar;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['forbid_login'] = this.forbidLogin;
    data['forbid_shop'] = this.forbidShop;
    return data;
  }
}
