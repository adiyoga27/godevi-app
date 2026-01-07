class EventModel {
  int? id;
  String? name;
  String? description;
  int? price;
  String? location;
  String? dateEvent;
  String? defaultImg;
  String? slug;
  String? itenaries;
  String? inclusion;
  String? term;
  String? categoryName;
  String? duration;
  int? disc;

  EventModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.location,
    this.dateEvent,
    this.defaultImg,
    this.slug,
    this.itenaries,
    this.inclusion,
    this.term,
    this.categoryName,
    this.duration,
    this.disc,
  });

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is String ? int.tryParse(json['id']) : json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'] is String
        ? int.tryParse(json['price'])
        : json['price'];
    location = json['location'];
    dateEvent = json['date_event'];
    defaultImg = json['default_img'];
    slug = json['slug'];
    // Handle API typo 'interary'
    itenaries = json['interary'] ?? json['itenaries'];
    inclusion = json['inclusion'];
    term = json['term'];

    // Additional fields from JSON
    categoryName = json['category_name'];
    duration = json['duration'];
    disc = json['disc'] is String ? int.tryParse(json['disc']) : json['disc'];
  }
}
