import 'banner.dart';
import 'hot_sale.dart';

class Pictures {
  List<BannerModel> banner;
  HotSale hotSale;
  BannerModel forSale;
  BannerModel hotBrand;

  Pictures({this.banner, this.hotSale, this.forSale, this.hotBrand});

  Pictures.fromJson(Map<String, dynamic> json) {
    if (json['banner'] != null) {
      banner = new List<BannerModel>.empty(growable: true);
      json['banner'].forEach((v) {
        banner.add(new BannerModel.fromJson(v));
      });
    }
    hotSale = json['hot_sale'] != null
        ? new HotSale.fromJson(json['hot_sale'])
        : null;
    forSale = json['for_sale'] != null
        ? new BannerModel.fromJson(json['for_sale'])
        : null;
    hotBrand = json['hot_brand'] != null
        ? new BannerModel.fromJson(json['hot_brand'])
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
    if (this.hotBrand != null) {
      data['hot_brand'] = this.hotBrand.toJson();
    }
    return data;
  }
}
