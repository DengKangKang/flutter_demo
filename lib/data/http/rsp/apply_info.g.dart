// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apply_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplyInfoRsp _$ApplyInfoRspFromJson(Map<String, dynamic> json) {
  return ApplyInfoRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : ApplyInfoData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ApplyInfoRspToJson(ApplyInfoRsp instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

ApplyInfoData _$ApplyInfoDataFromJson(Map<String, dynamic> json) {
  return ApplyInfoData(
      json['state_formal'] as int,
      json['state_test'] as int,
      json['state_train'] as int,
      (json['logs'] as List)
          ?.map((e) =>
              e == null ? null : TrainLog.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ApplyInfoDataToJson(ApplyInfoData instance) =>
    <String, dynamic>{
      'state_formal': instance.state_formal,
      'state_test': instance.state_test,
      'state_train': instance.state_train,
      'logs': instance.logs
    };

TrainLog _$TrainLogFromJson(Map<String, dynamic> json) {
  return TrainLog(
      json['train_place'] as String,
      json['realname'] as String,
      json['memo'] as String,
      json['requirements'] as String,
      json['prename'] as String,
      json['visit_time'] as String,
      json['agree_time'] as String);
}

Map<String, dynamic> _$TrainLogToJson(TrainLog instance) => <String, dynamic>{
      'train_place': instance.train_place,
      'realname': instance.realname,
      'memo': instance.memo,
      'requirements': instance.requirements,
      'prename': instance.prename,
      'visit_time': instance.visit_time,
      'agree_time': instance.agree_time
    };
