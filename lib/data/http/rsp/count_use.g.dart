// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_use.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountUseRsp _$CountUseRspFromJson(Map<String, dynamic> json) {
  return CountUseRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : CountUseData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$CountUseRspToJson(CountUseRsp instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

CountUseData _$CountUseDataFromJson(Map<String, dynamic> json) {
  return CountUseData(
      (json['rows'] as List)
          ?.map((e) =>
              e == null ? null : CountUse.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['count'] as int,
      json['quota'] as int);
}

Map<String, dynamic> _$CountUseDataToJson(CountUseData instance) =>
    <String, dynamic>{
      'rows': instance.rows,
      'count': instance.count,
      'quota': instance.quota
    };

CountUse _$CountUseFromJson(Map<String, dynamic> json) {
  return CountUse(json['count'] as int, json['dt'] as String);
}

Map<String, dynamic> _$CountUseToJson(CountUse instance) =>
    <String, dynamic>{'count': instance.count, 'dt': instance.dt};
