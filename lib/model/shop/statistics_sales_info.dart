import 'package:E_Sale_Tech/model/base_entity.dart';

class StatisticsSales {
  StatisticsSalesData statisticsSalesData;

  StatisticsSales({this.statisticsSalesData});

  StatisticsSales.fromJson(BaseEntity json) {
    statisticsSalesData =
        json.data != null ? new StatisticsSalesData.fromJson(json.data) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.statisticsSalesData != null) {
      data['data'] = this.statisticsSalesData.toJson();
    }
    return data;
  }
}

class StatisticsSalesData {
  List<StatisticsSalesList> statisticsSalesList;
  DayCount dayCount;
  MonthCount monthCount;
  List<TopTen> topTen;

  StatisticsSalesData(
      {this.statisticsSalesList, this.dayCount, this.monthCount, this.topTen});

  StatisticsSalesData.fromJson(Map<String, dynamic> json) {
    if (json['sales'] != null) {
      statisticsSalesList = new List<StatisticsSalesList>.empty(growable: true);
      json['sales'].forEach((v) {
        statisticsSalesList.add(new StatisticsSalesList.fromJson(v));
      });
    }
    dayCount = json['dayCount'] != null
        ? new DayCount.fromJson(json['dayCount'])
        : null;
    monthCount = json['monthCount'] != null
        ? new MonthCount.fromJson(json['monthCount'])
        : null;
    if (json['topTen'] != null) {
      topTen = new List<TopTen>.empty(growable: true);
      json['topTen'].forEach((v) {
        topTen.add(new TopTen.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.statisticsSalesList != null) {
      data['sales'] = this.statisticsSalesList.map((v) => v.toJson()).toList();
    }
    if (this.dayCount != null) {
      data['dayCount'] = this.dayCount.toJson();
    }
    if (this.monthCount != null) {
      data['monthCount'] = this.monthCount.toJson();
    }
    if (this.topTen != null) {
      data['topTen'] = this.topTen.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatisticsSalesList {
  String days;
  String months;
  num sales;
  num earnings;

  StatisticsSalesList({this.days, this.sales, this.earnings});

  StatisticsSalesList.fromJson(Map<String, dynamic> json) {
    days = json['days'];
    months = json['months'];
    sales = json['sales'];
    earnings = json['earnings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['days'] = this.days;
    data['months'] = this.months;
    data['sales'] = this.sales;
    data['earnings'] = this.earnings;
    return data;
  }
}

class DayCount {
  num sales;
  num earnings;

  DayCount({this.sales, this.earnings});

  DayCount.fromJson(Map<String, dynamic> json) {
    sales = json['sales'];
    earnings = json['earnings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sales'] = this.sales;
    data['earnings'] = this.earnings;
    return data;
  }
}

class MonthCount {
  num sales;
  num earnings;

  MonthCount({this.sales, this.earnings});

  MonthCount.fromJson(Map<String, dynamic> json) {
    sales = json['sales'];
    earnings = json['earnings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sales'] = this.sales;
    data['earnings'] = this.earnings;
    return data;
  }
}

class TopTen {
  int id;
  String productName;
  num sales;

  TopTen({this.id, this.productName, this.sales});

  TopTen.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    sales = json['sales'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['sales'] = this.sales;
    return data;
  }
}
