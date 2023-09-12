class LoginBean {
  String accessToken;
  String tokenType;
  int expiresIn;
  String email;
  String username;
  bool completeinfo;

  LoginBean(
      {this.accessToken,
      this.tokenType,
      this.expiresIn,
      this.email,
      this.username,
      this.completeinfo});

  LoginBean.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    email = json['email'];
    username = json['username'];
    completeinfo = json['complete_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    data['email'] = this.email;
    data['username'] = this.username;
    data['complete_info'] = this.completeinfo;
    return data;
  }
}
