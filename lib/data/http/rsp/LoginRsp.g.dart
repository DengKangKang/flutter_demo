// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LoginRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRsp _$LoginRspFromJson(Map<String, dynamic> json) {
  return LoginRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : LoginData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$LoginRspToJson(LoginRsp instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };
