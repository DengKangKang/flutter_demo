// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LoginData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginData _$LoginDataFromJson(Map<String, dynamic> json) {
  return LoginData(json['auth'] as String, json['realname'] as String);
}

Map<String, dynamic> _$LoginDataToJson(LoginData instance) =>
    <String, dynamic>{'auth': instance.auth, 'realname': instance.realname};
