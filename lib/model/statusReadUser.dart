class StatusReadUser {
  String? id;
  String? status;
  String? readAt;
  String? idReceiver;
  String? nameUser;
  String? firstNameUser;

  StatusReadUser(
      {this.id,
      this.status,
      this.readAt,
      this.idReceiver,
      this.nameUser,
      this.firstNameUser});

  StatusReadUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    readAt = json['readAt'];
    idReceiver = json['receiver']['id'];
    nameUser = json['receiver']['name'];
    firstNameUser = json['receiver']['firstName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['readAt'] = readAt;
    data['receiver']['id'] = idReceiver;
    data['receiver']['name'] = nameUser;
    data['receiver']['firstName'] = firstNameUser;
    return data;
  }
}
