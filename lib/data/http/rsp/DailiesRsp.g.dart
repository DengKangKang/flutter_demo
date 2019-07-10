// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DailiesRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailiesRsp _$DailiesRspFromJson(Map<String, dynamic> json) {
  return DailiesRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : DailyRspData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$DailiesRspToJson(DailiesRsp instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DailyRspData _$DailyRspDataFromJson(Map<String, dynamic> json) {
  return DailyRspData(
      json['count'] as int,
      (json['list'] as List)
          ?.map((e) =>
              e == null ? null : Daily.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DailyRspDataToJson(DailyRspData instance) =>
    <String, dynamic>{'count': instance.count, 'list': instance.list};

Daily _$DailyFromJson(Map<String, dynamic> json) {
  return Daily(
      json['daily_time'] as String,
      json['today_content'] as String,
      json['today_customer_visit'] as String,
      json['today_solution'] as String,
      json['next_plan'] as String,
      json['next_customer_visit'] as String,
      json['user_realname'] as String,
      json['morn_type'] as int,
      json['afternoon_type'] as int,
      json['morn_content'] as String,
      json['afternoon_content'] as String);
}

Map<String, dynamic> _$DailyToJson(Daily instance) => <String, dynamic>{
      'daily_time': instance.daily_time,
      'today_content': instance.today_content,
      'today_customer_visit': instance.today_customer_visit,
      'today_solution': instance.today_solution,
      'next_plan': instance.next_plan,
      'next_customer_visit': instance.next_customer_visit,
      'user_realname': instance.user_realname,
      'morn_type': instance.morn_type,
      'afternoon_type': instance.afternoon_type,
      'morn_content': instance.morn_content,
      'afternoon_content': instance.afternoon_content
    };
