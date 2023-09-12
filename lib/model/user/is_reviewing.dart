class IsReviewing {
  int isReviewing;
  String defaultPhoneCode;

  IsReviewing({this.isReviewing, this.defaultPhoneCode});

  IsReviewing.fromJson(Map<String, dynamic> json) {
    isReviewing = json['is_reviewing'];
    defaultPhoneCode = json['default_phone_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_reviewing'] = this.isReviewing;
    data['default_phone_code'] = this.defaultPhoneCode;
    return data;
  }
}