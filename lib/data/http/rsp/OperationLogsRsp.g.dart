// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OperationLogsRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationLogsRsp _$OperationLogsRspFromJson(Map<String, dynamic> json) {
  return OperationLogsRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : OperationLogsData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$OperationLogsRspToJson(OperationLogsRsp instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };
