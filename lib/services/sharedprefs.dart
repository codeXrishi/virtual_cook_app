import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userIdKey = "USERKEY";

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userIdKey, getUserId);
  }

  Future<String?> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userIdKey);
  }
}
