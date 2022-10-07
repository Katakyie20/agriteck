class UserObject {
  String? id;
  String? name;
  String? phone;
  String? profile;
  int? createdAt;

  UserObject({
    this.id,
    this.name,
    this.phone,
    this.profile,
    this.createdAt,
  });

  UserObject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    profile = json['profile'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['profile'] = profile;
    data['createdAt'] = createdAt;
    return data;
  }
}
