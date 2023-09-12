import 'package:E_Sale_Tech/model/base_entity.dart';

class StatisticsTrade {
  StatisticTradeData statisticTradeData;

  StatisticsTrade({this.statisticTradeData});

  StatisticsTrade.fromJson(BaseEntity json) {
    statisticTradeData =
        json.data != null ? new StatisticTradeData.fromJson(json.data) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.statisticTradeData != null) {
      data['data'] = this.statisticTradeData.toJson();
    }
    return data;
  }
}

class StatisticTradeData {
  List<StatisticTradeItem> statisticTradeArr;
  StatisticTradeToday statisticTradeToday;

  StatisticTradeData({this.statisticTradeArr, this.statisticTradeToday});

  StatisticTradeData.fromJson(Map<String, dynamic> json) {
    if (json['trade'] != null) {
      statisticTradeArr = new List<StatisticTradeItem>.empty(growable: true);
      json['trade'].forEach((v) {
        statisticTradeArr.add(new StatisticTradeItem.fromJson(v));
      });
    }
    statisticTradeToday = json['today'] != null
        ? new StatisticTradeToday.fromJson(json['today'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.statisticTradeArr != null) {
      data['trade'] = this.statisticTradeArr.map((v) => v.toJson()).toList();
    }
    if (this.statisticTradeToday != null) {
      data['today'] = this.statisticTradeToday.toJson();
    }
    return data;
  }
}

class StatisticTradeItem {
  String days;
  String months;
  int count;

  StatisticTradeItem({this.days, this.count, this.months});

  StatisticTradeItem.fromJson(Map<String, dynamic> json) {
    days = json['days'];
    months = json['months'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['days'] = this.days;
    data['months'] = this.months;
    data['count'] = this.count;
    return data;
  }
}

class StatisticTradeToday {
  int count;
  num payment;

  StatisticTradeToday({this.count = 0, this.payment = 0});

  StatisticTradeToday.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    payment = json['payment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['payment'] = this.payment;
    return data;
  }
}
