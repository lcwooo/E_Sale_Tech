class ShopQRcode {
  String title;
  String description;
  String picture;
  String qrCode;

  ShopQRcode({this.title, this.description, this.picture, this.qrCode});

  ShopQRcode.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    picture = json['picture'];
    qrCode = json['qr_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['picture'] = this.picture;
    data['qr_code'] = this.qrCode;
    return data;
  }
}
