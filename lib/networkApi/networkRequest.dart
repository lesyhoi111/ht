import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hiptech_app/model/notification.dart';
import 'package:hiptech_app/model/notificationSent.dart';
import 'package:hiptech_app/model/statusReadUser.dart';
import 'package:hiptech_app/model/user.dart';
import 'package:hiptech_app/model/userProfile.dart';
import 'package:hiptech_app/services/store.dart';
import 'package:http/http.dart' as Http;

class NetworkRequest {
  static Future<bool> SaveRefreshToken() async {
    String? refreshToken = await Store.getRefreshToken();
    Map<String, String> params = {
      "client_id": "notification",
      "client_secret": "Ac18OhFPJ4w2nLr7w7ZTpy6dVs8Epuq5",
      "grant_type": "refresh_token",
      "refresh_token": refreshToken!,
    };
    final response = await Http.post(
      Uri.parse(
          "https://hiptechvn.com:8443/realms/hiptech-portal/protocol/openid-connect/token"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "application/json",
      },
      body: params,
    );
    if (response.statusCode == 200) {
      await SaveToken(json.decode(response.body));
      return true;
    }
    return false;
  }

  ///Handle with token login///
  static Future<void> SaveToken(Map<String, dynamic> data) async {
    final token = data['access_token'];
    final refreshToken = data['refresh_token'];
    await Store.setToken(token);
    await Store.setrRefreshToken(refreshToken);
  }

  static Future<bool> getKeyLogin(Map map) async {
    print("response.statusCode");
    final response = await Http.post(
      Uri.parse(
          "https://hiptechvn.com:8443/realms/hiptech-portal/protocol/openid-connect/token"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "application/json",
      },
      body: map,
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await SaveToken(json.decode(response.body));
      return true;
    }
    return false;
  }

  ///Handle with noti///
  static List<Notification> parseNotification(String responseBody) {
    var listJson = json.decode(responseBody) as List<dynamic>;
    List<Notification> listNotification = listJson
        .map((notification) => Notification.fromJson(notification))
        .toList();
    return listNotification;
  }

  static Future<List<Notification>> fetchNotifications() async {
    String? token = await Store.getToken();
    final response = await Http.get(
      Uri.parse("${dotenv.get("API_URL")}/api/user-notifs?isDefaultView=true"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      return parseNotification(response.body);
    } else {
      if (response.statusCode == 401) {
        await SaveRefreshToken();
        return fetchNotifications();
      } else {
        print('not found');
        throw Exception('Can\'t get Notification');
      }
    }
  }

  static Future<List<Notification>> fetchNotificationsImportant() async {
    String? token = await Store.getToken();
    final response = await Http.get(
      Uri.parse(
          "${dotenv.get("API_URL")}/api/user-notifs?isImportant=true&isDefaultView=true"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      return parseNotification(response.body);
    }
    if (response.statusCode == 401) {
      await SaveRefreshToken();
      return fetchNotificationsImportant();
    }
    print('not found');
    throw Exception('Can\'t get Notification');
  }

  static Future<List<Notification>> fetchNotificationsArchived() async {
    String? token = await Store.getToken();
    final response = await Http.get(
      Uri.parse(
          "${dotenv.get("API_URL")}/api/user-notifs?notifStatus=ARCHIVED"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return parseNotification(response.body);
    }
    if (response.statusCode == 401) {
      await SaveRefreshToken();
      return fetchNotificationsArchived();
    }
    print('not found');
    throw Exception('Can\'t get Notification');
    return [];
  }

  ///handle put status Read///
  static Future<bool> putStatusRead(Map map) async {
    print(json.encode(map));
    String? token = await Store.getToken();
    final response = await Http.put(
      Uri.parse("${dotenv.get("API_URL")}/api/user-notifs"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode(map),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 401) {
      await SaveRefreshToken();
      return putStatusRead(map);
    }
    print('not found');
    throw Exception('Can\'t put Notification');
    return false;
  }

  ///handle put status Archived///
  static Future<bool> putStatusArchived(Map map) async {
    print(json.encode(map));
    String? token = await Store.getToken();
    final response = await Http.put(
      Uri.parse("${dotenv.get("API_URL")}/api/user-notifs"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode(map),
    );
    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 401) {
      await SaveRefreshToken();
      return putStatusArchived(map);
    }
    print('not found');
    throw Exception('Can\'t put Notification');
    return false;
  }

  ///handle put status Archived///
  static Future<UserProfile> getRole() async {
    String? token = await Store.getToken();
    final response = await Http.get(
      Uri.parse("${dotenv.get("API_URL")}/api/user-authorities"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    final responseProfile = await Http.get(
      Uri.parse("${dotenv.get("API_URL")}/api/profile"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 && responseProfile.statusCode == 200) {
      print("${response.body.toString()}a");
      return UserProfile.fromJson(
          json.decode(responseProfile.body), response.body.toString());
    }
    if (response.statusCode == 401 || responseProfile.statusCode == 401) {
      await SaveRefreshToken();
      return getRole();
    }
    print('not found');
    throw Exception('Can\'t put Notification');
  }

  ///Handle with User///
  static List<UserDetail> parseUser(String responseBody) {
    var listJson = json.decode(responseBody) as List<dynamic>;
    List<UserDetail> listUser =
        listJson.map((userDetail) => UserDetail.fromJson(userDetail)).toList();
    return listUser;
  }

  static Future<List<UserDetail>> fetchListUser() async {
    String? token = await Store.getToken();
    final response = await Http.get(
      Uri.parse("${dotenv.get("API_URL")}/api/admin/user-details/all"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return parseUser(response.body);
    }
    if (response.statusCode == 401) {
      await SaveRefreshToken();
      return fetchListUser();
    }
    print('not found');
    throw Exception('Can\'t get user');
    return [];
  }

  static Future<UserDetail> fetchProfileUser() async {
    String? token = await Store.getToken();
    final response = await Http.get(
      Uri.parse("${dotenv.get("API_URL")}/api/profile"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      UserDetail a = UserDetail.fromJson(json.decode(response.body));
      return a;
    }
    if (response.statusCode == 401) {
      await SaveRefreshToken();
      return fetchProfileUser();
    }
    print('not found');
    throw Exception('Can\'t get user');
  }

  static Future<List<UserDetail>> fetchListUserSearch(String strSearch) async {
    String? token = await Store.getToken();
    final response = await Http.get(
      Uri.parse(
          "${dotenv.get("API_URL")}/api/admin/user-details?name=$strSearch"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return parseUser(response.body);
    }
    if (response.statusCode == 401) {
      await SaveRefreshToken();
      return fetchListUserSearch(strSearch);
    }
    print('not found');
    throw Exception('Can\'t get Notification');
    return [];
  }

  ///Handle with group///
  static List<UserDetail> parseGroup(String responseBody) {
    var listJson = json.decode(responseBody) as List<dynamic>;
    List<UserDetail> listUser =
        listJson.map((userDetail) => UserDetail.fromJson(userDetail)).toList();
    return listUser;
  }

  static Future<List<UserDetail>> fetchGroup() async {
    String? token = await Store.getToken();
    final response = await Http.get(
      Uri.parse("${dotenv.get("API_URL")}/api/admin/user-details/all"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return parseUser(response.body);
    }
    if (response.statusCode == 401) {
      await SaveRefreshToken();
      return fetchGroup();
    }
    print('not found');
    throw Exception('Can\'t get user');
    return [];
  }

  ///Handle with sent noti of admin///
  static List<NotificationSent> parseNotificationSent(String responseBody) {
    print("parseNotificationSent");
    var listJson = json.decode(responseBody) as List<dynamic>;
    // print(json.decode(responseBody));
    List<NotificationSent> listNotification = listJson.map((notification) =>
        // print(NotificationSent.fromJson(notification));
        NotificationSent.fromJson(notification)).toList();
    return listNotification;
  }

  static Future<List<NotificationSent>> fetchNotificationSent() async {
    String? token = await Store.getToken();
    final response = await Http.get(
      Uri.parse("${dotenv.get("API_URL")}/api/admin/notifications"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return parseNotificationSent(response.body);
    }
    if (response.statusCode == 401) {
      await SaveRefreshToken();
      return fetchNotificationSent();
    }
    print('not found');
    throw Exception('Can\'t get Notification');
    return [];
  }

  static Future<bool> deleteNotification(String id) async {
    String? token = await Store.getToken();
    final response = await Http.delete(
      Uri.parse("${dotenv.get("API_URL")}/api/admin/notifications/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 204) {
      return true;
    }
    if (response.statusCode == 401) {
      await SaveRefreshToken();
      return deleteNotification(id);
    }
    print('not found');
    throw Exception('Can\'t delete Notification');
    return false;
  }

  static Future<List<NotificationSent>> fetchNotificationSentSchedule() async {
    String? token = await Store.getToken();
    final response = await Http.get(
      Uri.parse(
          "${dotenv.get("API_URL")}/api/admin/notifications?notifType=SCHEDULE"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return parseNotificationSent(response.body);
    }
    if (response.statusCode == 401) {
      await SaveRefreshToken();
      return fetchNotificationSentSchedule();
    }
    print('not found');
    throw Exception('Can\'t get Notification');
    return [];
  }

  ///Handle with status read of user///
  static List<StatusReadUser> parseStatusReadUser(String responseBody) {
    var listJson = json.decode(responseBody) as List<dynamic>;
    List<StatusReadUser> listStatusReadUser =
        listJson.map((item) => StatusReadUser.fromJson(item)).toList();
    return listStatusReadUser;
  }

  static Future<List<StatusReadUser>> fetchStatusReadUser(String id) async {
    String? token = await Store.getToken();
    final response = await Http.get(
      Uri.parse("${dotenv.get("API_URL")}/api/admin/notifications/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print(response.body);
    if (response.statusCode == 200) {
      return parseStatusReadUser(response.body);
    }
    if (response.statusCode == 401) {
      await SaveRefreshToken();
      return fetchStatusReadUser(id);
    }
    print('not found');
    throw Exception('Can\'t get Notification');
    return [];
  }

  ///handle post noti of admin///
  static Future<bool> postNotification(Map map) async {
    print(map);
    String? token = await Store.getToken();
    final response = await Http.post(
      Uri.parse("${dotenv.get("API_URL")}/api/admin/notifications"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode(map),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201) {
      return true;
    }
    if (response.statusCode == 401) {
      await SaveRefreshToken();
      return postNotification(map);
    }
    print('Not Post');
    throw Exception('Can\'t Post Notification');
    return false;
  }

  ///post FCM///
  static Future<bool> postFCM(Map map, String? Id) async {
    print(map);
    print(Id);
    String? token = await Store.getToken();
    final response = await Http.patch(
      Uri.parse("${dotenv.get("API_URL")}/api/user-details/$Id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode(map),
    );
    print(response.statusCode);
    print("response.statusCode");
    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 401) {
      await SaveRefreshToken();
      return postFCM(map, Id);
    }
    print('Not Post');
    throw Exception('Can\'t Post Notification');
    return false;
  }
}
