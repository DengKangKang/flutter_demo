import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Persistence {
  static final Persistence _singleton = new Persistence._internal();
  static const String _KEY_TOKEN = "token";
  static const String _KEY_USERNAME = "user_name";
  static const String _KEY_USER_ACCOUNT = "user_account";

  factory Persistence() {
    return _singleton;
  }

  Persistence._internal();

  Future<bool> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_KEY_TOKEN, token);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_KEY_TOKEN);
  }


  Future<bool> setUsername(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_KEY_USERNAME, token);
  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_KEY_USERNAME);
  }


  Future<bool> setUserAccount(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_KEY_USER_ACCOUNT, token);
  }

  Future<String> getUserAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_KEY_USER_ACCOUNT);
  }
}
