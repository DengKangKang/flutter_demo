// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VisitLogsData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitLogsData _$VisitLogsDataFromJson(Map<String, dynamic> json) {
  return VisitLogsData((json['list'] as List)
      ?.map((e) =>
          e == null ? null : VisitLog.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$VisitLogsDataToJson(VisitLogsData instance) =>
    <String, dynamic>{'list': instance.list};

VisitLog _$VisitLogFromJson(Map<String, dynamic> json) {
  return VisitLog(
      json['_id'] as String,
      json['create_time'] as String,
      json['user_id'] as int,
      json['user_realname'] as String,
      json['category'] as int,
      json['cs_log'] as String);
}

Map<String, dynamic> _$VisitLogToJson(VisitLog instance) => <String, dynamic>{
      '_id': instance.leads_id,
      'create_time': instance.create_time,
      'user_id': instance.user_id,
      'user_realname': instance.user_realname,
      'category': instance.category,
      'cs_log': instance.cs_log
    };
