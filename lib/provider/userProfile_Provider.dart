import 'package:flutter/material.dart';
import 'package:hiptech_app/networkApi/networkRequest.dart';

import '../model/userProfile.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfile _userProfile = UserProfile();
  UserProfile get getUserProfile => _userProfile;
  Future<void> fetchProfile() async {
    _userProfile = await NetworkRequest.getRole();
    notifyListeners();
  }

  String? get Role => _userProfile.role;
}
