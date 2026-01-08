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
  String? exclusion;
  String? term;
  String? duration;
  String? preparation;
  String? lat;
  String? lng;
  String? type; // 'tour', 'event', or 'homestay'

  // Event-specific fields
  String? location;
  String? dateEvent;
  String? interary; // Note: Events use 'interary', tours use 'itenaries'

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
    this.exclusion,
    this.term,
    this.duration,
    this.preparation,
    this.lat,
    this.lng,
    this.type = 'tour',
    this.location,
    this.dateEvent,
    this.interary,
  });

  PackageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is String ? int.tryParse(json['id']) : json['id'];
    name = json['name'];
    description = json['description'];
    if (json['price'] is String) {
      price = double.tryParse(json['price'])?.toInt();
    } else if (json['price'] is num) {
      price = json['price'].toInt();
    }

    if (json['disc'] is String) {
      disc = double.tryParse(json['disc'])?.toInt();
    } else if (json['disc'] is num) {
      disc = json['disc'].toInt();
    }
    defaultImg = json['default_img'];
    slug = json['slug'];
    categoryId = json['category_id'] is int
        ? json['category_id'].toString()
        : json['category_id'];
    categoryName = json['category_name'];
    review = json['review'];
    itenaries = json['itenaries'];
    inclusion = json['inclusion'];
    exclusion = json['exclusion'];
    term = json['term'];
    duration = json['duration'];
    preparation = json['preparation'];
    lat = json['lat'];
    lng = json['lng'];

    // Event-specific fields
    location = json['location'];
    dateEvent = json['date_event'];
    interary = json['interary'];
  }
}
