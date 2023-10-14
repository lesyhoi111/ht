class UserProfile {
  String? id;
  String? name;
  String? firstName;
  String? fcmToken;
  String? role;

  UserProfile({this.id, this.name, this.firstName, this.fcmToken, this.role});

  UserProfile.fromJson(Map<String, dynamic> json, String role1) {
    id = json['id'];
    name = json['name'];
    firstName = json['firstName'];
    fcmToken = json['fcmToken'];
    role = role1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['firstName'] = firstName;
    data['fcmToken'] = fcmToken;
    data['role'] = role;
    return data;
  }
}
