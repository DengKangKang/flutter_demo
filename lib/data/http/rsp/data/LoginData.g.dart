// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LoginData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginData _$LoginDataFromJson(Map<String, dynamic> json) {
  return new LoginData(json['auth'] as String, json['realname'] as String);
}

abstract class _$LoginDataSerializerMixin {
  String get auth;
  String get realname;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'auth': auth, 'realname': realname};
}
