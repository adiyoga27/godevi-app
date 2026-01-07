class EventModel {
  int? id;
  String? name;
  String? description;
  int? price;
  String? location;
  String? dateEvent;
  String? defaultImg;
  String? slug;

  EventModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.location,
    this.dateEvent,
    this.defaultImg,
    this.slug,
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
  }
}
