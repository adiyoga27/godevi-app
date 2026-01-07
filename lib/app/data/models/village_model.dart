class VillageModel {
  String? villageName;
  String? villageAddress;
  String? contactPerson;
  String? desc;
  String? lat;
  String? lng;
  String? thumbnail;

  VillageModel({
    this.villageName,
    this.villageAddress,
    this.desc,
    this.lat,
    this.lng,
    this.thumbnail,
  });

  VillageModel.fromJson(Map<String, dynamic> json) {
    villageName = json['village_name'];
    villageAddress = json['village_address'];
    desc = json['desc'];
    lat = json['lat'];
    lng = json['lng'];
    thumbnail = json['thumbnail'];
  }
}
