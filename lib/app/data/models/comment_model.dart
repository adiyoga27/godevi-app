class CommentModel {
  int? id;
  int? userId;
  String? userName;
  String? userAvatar;
  String? comment;

  CommentModel({
    this.id,
    this.userId,
    this.userName,
    this.userAvatar,
    this.comment,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userAvatar = json['user_avatar'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['user_avatar'] = userAvatar;
    data['comment'] = comment;
    return data;
  }
}
