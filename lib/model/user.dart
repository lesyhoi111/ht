class UserDetail {
  String? id;
  String? name;
  String? firstName;
  String? fcmToken;

  UserDetail({this.id, this.name, this.firstName, this.fcmToken});

  UserDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstName = json['firstName'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['firstName'] = firstName;
    data['fcmToken'] = fcmToken;
    return data;
  }
}
