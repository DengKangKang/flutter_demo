// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OperationLogsData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationLogsData _$OperationLogsDataFromJson(Map<String, dynamic> json) {
  return new OperationLogsData((json['list'] as List)
      ?.map((e) => e == null
          ? null
          : new OperationLog.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

abstract class _$OperationLogsDataSerializerMixin {
  List<OperationLog> get list;
  Map<String, dynamic> toJson() => <String, dynamic>{'list': list};
}

OperationLog _$OperationLogFromJson(Map<String, dynamic> json) {
  return new OperationLog(
      json['leads_id'] as String,
      json['create_time'] as String,
      json['user_realname'] as String,
      json['system_log'] as String,
      json['category'] as int);
}

abstract class _$OperationLogSerializerMixin {
  String get leads_id;
  String get create_time;
  String get user_realname;
  String get system_log;
  int get category;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'leads_id': leads_id,
        'create_time': create_time,
        'user_realname': user_realname,
        'system_log': system_log,
        'category': category
      };
}
