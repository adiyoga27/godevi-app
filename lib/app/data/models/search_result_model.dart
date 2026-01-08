class SearchResultModel {
  final int id;
  final String type;
  final String name;
  final String slug;
  final String? thumbnail;

  SearchResultModel({
    required this.id,
    required this.type,
    required this.name,
    required this.slug,
    this.thumbnail,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      thumbnail: json['thumbnail'],
    );
  }
}
