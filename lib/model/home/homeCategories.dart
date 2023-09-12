class HomeCategories {
  int id;
  String name;
  int sortIndex;
  String icon;
  List<Categories> categories;
  String createdAt;

  HomeCategories(
      {this.id,
      this.name,
      this.sortIndex,
      this.icon,
      this.categories,
      this.createdAt});

  HomeCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sortIndex = json['sort_index'];
    icon = json['icon'];
    if (json['categories'] != null) {
      categories = new List<Categories>.empty(growable: true);
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sort_index'] = this.sortIndex;
    data['icon'] = this.icon;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Categories {
  int id;
  String name;
  int sortIndex;
  String icon;
  List<Categories> categories;
  String createdAt;

  Categories(
      {this.id,
      this.name,
      this.sortIndex,
      this.icon,
      this.categories,
      this.createdAt});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sortIndex = json['sort_index'];
    icon = json['icon'];
    if (json['categories'] != null) {
      categories = new List<Categories>.empty(growable: true);
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sort_index'] = this.sortIndex;
    data['icon'] = this.icon;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}
