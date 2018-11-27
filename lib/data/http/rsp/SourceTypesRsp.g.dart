// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SourceTypesRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceTypesRsp _$SourceTypesRspFromJson(Map<String, dynamic> json) {
  return SourceTypesRsp(
      json['code'],
      json['msg'],
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : RadioBean.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$SourceTypesRspToJson(SourceTypesRsp instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };
