import 'package:E_Sale_Tech/model/base_entity.dart';

class CategoryDataInfo {
  List<CategoryList> categoryList;

  CategoryDataInfo({this.categoryList});

  CategoryDataInfo.fromJson(BaseEntity json) {
    if (json.data != null) {
      categoryList = new List<CategoryList>.empty(growable: true);
      json.data.forEach((v) {
        categoryList.add(new CategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categoryList != null) {
      data['data'] = this.categoryList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryList {
  int id;
  int modelId;
  int parentId;
  String name;
  String icon;
  int taxRate;
  String keywords;
  String description;
  int sortIndex;
  int isShow;
  int shouldTax;
  int showBbd;
  String createdAt;
  String updatedAt;
  List<Categories> categories;
  bool checked;

  CategoryList(
      {this.id,
      this.modelId,
      this.parentId,
      this.name,
      this.icon,
      this.taxRate,
      this.keywords,
      this.description,
      this.sortIndex,
      this.isShow,
      this.shouldTax,
      this.showBbd,
      this.createdAt,
      this.updatedAt,
      this.categories,
      this.checked = false});

  CategoryList.fromJson(Map<String, dynamic> json) {
    print(json['keywords']);
    id = json['id'];
    modelId = json['model_id'];
    parentId = json['parent_id'];
    name = json['name'];
    icon = json['icon'];
    taxRate = json['tax_rate'];
    keywords = json['keywords'] != null ? json['keywords'] : '';
    description = json['description'];
    sortIndex = json['sort_index'];
    isShow = json['is_show'];
    shouldTax = json['should_tax'];
    showBbd = json['show_bbd'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    checked = false;
    if (json['categories'] != null) {
      categories = new List<Categories>.empty(growable: true);
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['model_id'] = this.modelId;
    data['parent_id'] = this.parentId;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['tax_rate'] = this.taxRate;
    data['keywords'] = this.keywords;
    data['description'] = this.description;
    data['sort_index'] = this.sortIndex;
    data['is_show'] = this.isShow;
    data['should_tax'] = this.shouldTax;
    data['show_bbd'] = this.showBbd;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int id;
  int modelId;
  int parentId;
  String name;
  String icon;
  int taxRate;
  String keywords;
  String description;
  int sortIndex;
  int isShow;
  int shouldTax;
  int showBbd;
  String createdAt;
  String updatedAt;

  Categories(
      {this.id,
      this.modelId,
      this.parentId,
      this.name,
      this.icon,
      this.taxRate,
      this.keywords,
      this.description,
      this.sortIndex,
      this.isShow,
      this.shouldTax,
      this.showBbd,
      this.createdAt,
      this.updatedAt});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modelId = json['model_id'];
    parentId = json['parent_id'];
    name = json['name'];
    icon = json['icon'];
    taxRate = json['tax_rate'];
    keywords = json['keywords'] != null ? json['keywords'] : '';
    description = json['description'];
    sortIndex = json['sort_index'];
    isShow = json['is_show'];
    shouldTax = json['should_tax'];
    showBbd = json['show_bbd'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['model_id'] = this.modelId;
    data['parent_id'] = this.parentId;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['tax_rate'] = this.taxRate;
    data['keywords'] = this.keywords;
    data['description'] = this.description;
    data['sort_index'] = this.sortIndex;
    data['is_show'] = this.isShow;
    data['should_tax'] = this.shouldTax;
    data['show_bbd'] = this.showBbd;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
