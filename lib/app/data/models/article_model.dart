class ArticleModel {
  int? id;
  String? postTitle;
  String? postContent;
  String? postThumbnail;
  String? postAuthor;
  String? slug;
  String? createdAt;

  ArticleModel({
    this.id,
    this.postTitle,
    this.postContent,
    this.postThumbnail,
    this.postAuthor,
    this.slug,
    this.createdAt,
  });

  ArticleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is String ? int.tryParse(json['id']) : json['id'];
    postTitle = json['post_title'];
    postContent = json['post_content'];
    postThumbnail = json['post_thumbnail'];
    postAuthor = json['post_author'];
    slug = json['slug'];
    createdAt = json['created_at'];
  }
}
