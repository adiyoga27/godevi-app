class SliderModel {
  String? title;
  String? desc;
  String? img;

  SliderModel({this.title, this.desc, this.img});

  SliderModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    desc = json['desc'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['desc'] = desc;
    data['img'] = img;
    return data;
  }
}
