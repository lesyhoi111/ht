import 'package:flutter/material.dart';
import 'package:hiptech_app/networkApi/networkRequest.dart';

class FetchNotifiCationProvider extends ChangeNotifier {
  List _notification = [];
  List get notifications => _notification;
  bool isLoading = false;
  Future<void> fetchAllNotification() async {
    isLoading = true;
    notifyListeners();
    _notification = await NetworkRequest.fetchNotifications();
    isLoading = false;
    notifyListeners();
  }

  Future<void> reFetchAllNotification() async {
    _notification = await NetworkRequest.fetchNotifications();
    notifyListeners();
  }
}
