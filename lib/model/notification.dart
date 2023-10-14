import 'dart:convert';

class Notification {
  String? id;
  String? status;
  String? readAt;
  String? title;
  String? content;
  bool? isImportant;
  String? type;
  String? createdAt;
  String? sender;

  Notification(
      {this.id,
      this.status,
      this.readAt,
      this.title,
      this.content,
      this.isImportant,
      this.type,
      this.createdAt,
      this.sender});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    readAt = json['readAt'];
    title = utf8.decode(json['notifDetail']['title'].runes.toList());
    content = utf8.decode(json['notifDetail']['content'].runes.toList());
    isImportant = json['notifDetail']['isImportant'];
    type = json['notifDetail']['type'];
    createdAt = json['createdAt'];
    sender = json['notifDetail']['sender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['isImportant'] = isImportant;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['notifDetail']['sender'] = sender;
    return data;
  }
}
