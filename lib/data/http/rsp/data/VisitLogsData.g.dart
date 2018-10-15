// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VisitLogsData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitLogsData _$VisitLogsDataFromJson(Map<String, dynamic> json) {
  return new VisitLogsData((json['list'] as List)
      ?.map((e) =>
          e == null ? null : new VisitLog.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

abstract class _$VisitLogsDataSerializerMixin {
  List<VisitLog> get list;
  Map<String, dynamic> toJson() => <String, dynamic>{'list': list};
}

VisitLog _$VisitLogFromJson(Map<String, dynamic> json) {
  return new VisitLog(
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

abstract class _$VisitLogSerializerMixin {
  String get leads_id;
  String get create_time;
  int get user_id;
  String get user_realname;
  int get category;
  String get sale_visit_time;
  int get sale_visit_form;
  String get sale_feedback;
  String get sale_solution;
  String get expense;
  String get visitor;
  String get visit_goal;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'leads_id': leads_id,
        'create_time': create_time,
        'user_id': user_id,
        'user_realname': user_realname,
        'category': category,
        'sale_visit_time': sale_visit_time,
        'sale_visit_form': sale_visit_form,
        'sale_feedback': sale_feedback,
        'sale_solution': sale_solution,
        'expense': expense,
        'visitor': visitor,
        'visit_goal': visit_goal
      };
}
