// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OperationLogsData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationLogsData _$OperationLogsDataFromJson(Map<String, dynamic> json) {
  return OperationLogsData((json['list'] as List)
      ?.map((e) =>
          e == null ? null : OperationLog.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$OperationLogsDataToJson(OperationLogsData instance) =>
    <String, dynamic>{'list': instance.list};

OperationLog _$OperationLogFromJson(Map<String, dynamic> json) {
  return OperationLog(
      json['leads_id'] as String,
      json['create_time'] as String,
      json['user_realname'] as String,
      json['system_log'] as String,
      json['category'] as int);
}

Map<String, dynamic> _$OperationLogToJson(OperationLog instance) =>
    <String, dynamic>{
      'leads_id': instance.leads_id,
      'create_time': instance.create_time,
      'user_realname': instance.user_realname,
      'system_log': instance.system_log,
      'category': instance.category
    };
