// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DailiesRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailiesRsp _$DailiesRspFromJson(Map<String, dynamic> json) {
  return DailiesRsp(json['code'], json['msg']);
}

Map<String, dynamic> _$DailiesRspToJson(DailiesRsp instance) =>
    <String, dynamic>{'code': instance.code, 'msg': instance.msg};

DailyRspData _$DailyRspDataFromJson(Map<String, dynamic> json) {
  return DailyRspData(
      json['count'] as int,
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Daily.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DailyRspDataToJson(DailyRspData instance) =>
    <String, dynamic>{'count': instance.count, 'data': instance.data};

Daily _$DailyFromJson(Map<String, dynamic> json) {
  return Daily(
      json['daily_time'] as String,
      json['today_content'] as String,
      json['today_customer_visit'] as String,
      json['today_solution'] as String,
      json['next_plan'] as String,
      json['next_customer_visit'] as String);
}

Map<String, dynamic> _$DailyToJson(Daily instance) => <String, dynamic>{
      'daily_time': instance.daily_time,
      'today_content': instance.today_content,
      'today_customer_visit': instance.today_customer_visit,
      'today_solution': instance.today_solution,
      'next_plan': instance.next_plan,
      'next_customer_visit': instance.next_customer_visit
    };
