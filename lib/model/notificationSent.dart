import 'dart:convert';

class NotificationSent {
  String? id;
  String? title;
  String? content;
  bool? isImportant;
  String? type;
  String? sendTime;
  String? createdAt;
  String? receivers;
  List<dynamic>? receiverGroups;
  String? senderName;

  NotificationSent(
      {this.id,
      this.title,
      this.content,
      this.isImportant,
      this.type,
      this.sendTime,
      this.createdAt,
      this.receivers,
      this.receiverGroups,
      this.senderName});

  NotificationSent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = utf8.decode(json['title'].runes.toList());
    content = utf8.decode(json['content'].runes.toList());
    isImportant = json['isImportant'];
    type = json['type'];
    sendTime = json['sendTime'];
    createdAt = json['createdAt'];
    receivers = json['receivers'];
    receiverGroups = json['receiverGroups'];
    senderName = json['sender']['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['isImportant'] = isImportant;
    data['type'] = type;
    data['sendTime'] = sendTime;
    data['createdAt'] = createdAt;
    data['receivers'] = receivers;
    data['receiverGroups'] = receiverGroups;
    data['sender']['name'] = senderName;
    return data;
  }
}
