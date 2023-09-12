class OrdersDetailTracking {
  String company;
  String number;
  List<TrackingData> trackingData;

  OrdersDetailTracking(
      {this.company = '', this.number = '', this.trackingData = const []});

  OrdersDetailTracking.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    number = json['number'];
    if (json['trackingData'] != null) {
      trackingData = new List<TrackingData>.empty(growable: true);
      json['trackingData'].forEach((v) {
        trackingData.add(new TrackingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company'] = this.company;
    data['number'] = this.number;
    if (this.trackingData != null) {
      data['trackingData'] = this.trackingData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrackingData {
  String time;
  String context;

  TrackingData({this.time, this.context});

  TrackingData.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    context = json['context'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['context'] = this.context;
    return data;
  }
}
