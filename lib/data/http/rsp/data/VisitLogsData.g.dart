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
      json['leads_id'] as String,
      json['create_time'] as String,
      json['user_id'] as int,
      json['user_realname'] as String,
      json['category'] as int,
      json['sale_visit_time'] as String,
      json['sale_visit_form'] as int,
      json['sale_feedback'] as String,
      json['sale_solution'] as String,
      json['expense'] as String,
      json['visitor'] as String,
      json['visit_goal'] as String);
}

Map<String, dynamic> _$VisitLogToJson(VisitLog instance) => <String, dynamic>{
      'leads_id': instance.leads_id,
      'create_time': instance.create_time,
      'user_id': instance.user_id,
      'user_realname': instance.user_realname,
      'category': instance.category,
      'sale_visit_time': instance.sale_visit_time,
      'sale_visit_form': instance.sale_visit_form,
      'sale_feedback': instance.sale_feedback,
      'sale_solution': instance.sale_solution,
      'expense': instance.expense,
      'visitor': instance.visitor,
      'visit_goal': instance.visit_goal
    };
