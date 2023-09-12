class Country {
  List<ListData> listData;
  String name;

  Country({this.listData, this.name});

  Country.fromJson(Map<String, dynamic> json) {
    if (json['listData'] != null) {
      listData = new List<ListData>.empty(growable: true);
      json['listData'].forEach((v) {
        listData.add(new ListData.fromJson(v));
      });
    }
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listData != null) {
      data['listData'] = this.listData.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    return data;
  }
}

class ListData {
  int id;
  String groupCode;
  String code;
  String name;

  ListData({this.id, this.groupCode, this.code, this.name});

  ListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupCode = json['groupCode'];
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['groupCode'] = this.groupCode;
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}
