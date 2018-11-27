// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VisitLogsRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitLogsRsp _$VisitLogsRspFromJson(Map<String, dynamic> json) {
  return VisitLogsRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : VisitLogsData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$VisitLogsRspToJson(VisitLogsRsp instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };
