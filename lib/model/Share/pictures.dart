class Pictures {
  List<Banner> banner;
  Banner hotSale;
  Banner forSale;
  Banner share;
  Banner hotBrand;

  Pictures(
      {this.banner, this.hotSale, this.forSale, this.share, this.hotBrand});

  Pictures.fromJson(Map<String, dynamic> json) {
    if (json['banner'] != null) {
      banner = new List<Banner>.empty(growable: true);
      json['banner'].forEach((v) {
        banner.add(new Banner.fromJson(v));
      });
    }
    hotSale =
        json['hot_sale'] != null ? new Banner.fromJson(json['hot_sale']) : null;
    forSale =
        json['for_sale'] != null ? new Banner.fromJson(json['for_sale']) : null;
    share = json['share'] != null ? new Banner.fromJson(json['share']) : null;
    hotBrand = json['hot_brand'] != null
        ? new Banner.fromJson(json['hot_brand'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banner != null) {
      data['banner'] = this.banner.map((v) => v.toJson()).toList();
    }
    if (this.hotSale != null) {
      data['hot_sale'] = this.hotSale.toJson();
    }
    if (this.forSale != null) {
      data['for_sale'] = this.forSale.toJson();
    }
    if (this.share != null) {
      data['share'] = this.share.toJson();
    }
    if (this.hotBrand != null) {
      data['hot_brand'] = this.hotBrand.toJson();
    }
    return data;
  }
}

class Banner {
  int linkType;
  String linkPath;
  int position;
  int type;

  Banner({this.linkType, this.linkPath, this.position, this.type});

  Banner.fromJson(Map<String, dynamic> json) {
    linkType = json['link_type'];
    linkPath = json['link_path'];
    position = json['position'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link_type'] = this.linkType;
    data['link_path'] = this.linkPath;
    data['position'] = this.position;
    data['type'] = this.type;
    return data;
  }
}
