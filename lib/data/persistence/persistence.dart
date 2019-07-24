import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Persistence {
  factory Persistence() {
    return _singleton;
  }

  Persistence._internal() {
    getUserAuthority().then((b) {
      userAuthority.add(b);
    });
  }

  static final Persistence _singleton = Persistence._internal();
  static const String _keyToken = "token";
  static const String _keyUsername = "user_name";
  static const String _keyUserAccount = "user_account";
  static const String _keyUserAuthority = "user_authority";
  static const String _keyDaily = "user_daily";

  var userAuthority = BehaviorSubject<bool>(seedValue: false);

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

  Future<bool> setUserAuthority(bool authority) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_keyUserAuthority, authority);
  }

  Future<bool> getUserAuthority() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyUserAuthority);
  }

  Future<bool> setDaily(String daily) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keyDaily, daily);
  }

  Future<String> getDaily() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDaily);
  }

}
