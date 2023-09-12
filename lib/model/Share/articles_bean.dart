class ArticlesBean {
  int id;
  String title;
  String cover;
  String abstract;
  int likeCount;
  int shareCount;
  String author;
  String shareUrl;
  String createdAt;

  ArticlesBean(
      {this.id,
        this.title,
        this.cover,
        this.abstract,
        this.likeCount,
        this.shareCount,
        this.author,
        this.shareUrl,
        this.createdAt});

  ArticlesBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    cover = json['cover'];
    abstract = json['abstract'];
    likeCount = json['like_count'];
    shareCount = json['share_count'];
    author = json['author'];
    shareUrl = json['share_url'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['cover'] = this.cover;
    data['abstract'] = this.abstract;
    data['like_count'] = this.likeCount;
    data['share_count'] = this.shareCount;
    data['author'] = this.author;
    data['share_url'] = this.shareUrl;
    data['created_at'] = this.createdAt;
    return data;
  }
}