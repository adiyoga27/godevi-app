class PackageModel {
  int? id;
  String? name;
  String? description;
  int? price;
  int? disc;
  String? defaultImg;
  String? slug;
  String? categoryId;
  String? categoryName;
  dynamic review;
  String? itenaries;
  String? inclusion;

  PackageModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.disc,
    this.defaultImg,
    this.slug,
    this.categoryId,
    this.categoryName,
    this.review,
    this.itenaries,
    this.inclusion,
  });

  PackageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is String ? int.tryParse(json['id']) : json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'] is String
        ? int.tryParse(json['price'])
        : json['price'];
    disc = json['disc'] is String ? int.tryParse(json['disc']) : json['disc'];
    defaultImg = json['default_img'];
    slug = json['slug'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    review = json['review'];
    itenaries = json['itenaries'];
    inclusion = json['inclusion'];
  }
}
