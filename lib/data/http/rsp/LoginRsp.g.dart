// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LoginRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRsp _$LoginRspFromJson(Map<String, dynamic> json) {
  return new LoginRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : new LoginData.fromJson(json['data'] as Map<String, dynamic>));
}

abstract class _$LoginRspSerializerMixin {
  int get code;
  String get msg;
  LoginData get data;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'code': code, 'msg': msg, 'data': data};
}
