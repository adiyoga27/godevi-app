class UserModel {
  String? email;
  String? name;
  String? phone;
  String? country;
  String? address;
  int? role;
  String? avatar;
  String? token;

  UserModel({
    this.email,
    this.name,
    this.phone,
    this.country,
    this.address,
    this.role,
    this.avatar,
    this.token,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    country = json['country'];
    address = json['address'];
    role = json['role'];
    avatar = json['avatar'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    data['country'] = country;
    data['address'] = address;
    data['role'] = role;
    data['avatar'] = avatar;
    data['token'] = token;
    return data;
  }
}
