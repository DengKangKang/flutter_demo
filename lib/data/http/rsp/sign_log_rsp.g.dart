// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_log_rsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignLogRsp _$SignLogRspFromJson(Map<String, dynamic> json) {
  return SignLogRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : SignLogData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$SignLogRspToJson(SignLogRsp instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };
