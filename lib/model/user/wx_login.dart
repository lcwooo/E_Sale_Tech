class WxBean {
  int type;
  int outId;
  String session;
  String token;
  String username;
  String email;
  String tokenType;
  int expiresIn;
  bool completeinfo;

  WxBean(
      {this.type,
      this.outId,
      this.session,
      this.token,
      this.username,
      this.email,
      this.tokenType,
      this.expiresIn,
      this.completeinfo});

  WxBean.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    outId = json['out_id'];
    session = json['session'];
    token = json['token'];
    username = json['username'];
    email = json['email'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    completeinfo = json['complete_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['out_id'] = this.outId;
    data['session'] = this.session;
    data['token'] = this.token;
    data['username'] = this.username;
    data['email'] = this.email;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    data['complete_info'] = this.completeinfo;
    return data;
  }
}
