import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Persistence {
  factory Persistence() {
    return _singleton;
  }

  Persistence._internal();

  static final Persistence _singleton = Persistence._internal();
  static const String _keyToken = "token";
  static const String _keyUsername = "user_name";
  static const String _keyUserAccount = "user_account";

  Future<bool> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keyToken, token);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  Future<bool> setUsername(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keyUsername, token);
  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  Future<bool> setUserAccount(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keyUserAccount, token);
  }

  Future<String> getUserAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserAccount);
  }
}
