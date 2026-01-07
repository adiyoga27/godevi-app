class HomestayModel {
  int? id;
  String? name;
  String? description;
  String? location;
  int? price;
  String? defaultImg;
  String? slug;
  String? categoryId;
  String? categoryName;
  String? facilities;
  String? isBreakfast;
  String? ownerName;
  String? checkInTime;
  String? checkOutTime;
  String? additionalNotes;

  HomestayModel({
    this.id,
    this.name,
    this.description,
    this.location,
    this.price,
    this.defaultImg,
    this.slug,
    this.categoryId,
    this.categoryName,
    this.facilities,
    this.isBreakfast,
    this.ownerName,
    this.checkInTime,
    this.checkOutTime,
    this.additionalNotes,
  });

  HomestayModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is String ? int.tryParse(json['id']) : json['id'];
    name = json['name'];
    description = json['description'];
    location = json['location'];
    price = json['price'] is String
        ? int.tryParse(json['price'])
        : json['price'];
    defaultImg = json['default_img'];
    slug = json['slug'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    facilities = json['facilities'];
    isBreakfast = json['is_breakfast'];
    ownerName = json['owner_name'];
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    additionalNotes = json['additional_notes'];
  }
}
