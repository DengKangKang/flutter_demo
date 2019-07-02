// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_log_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignLogData _$SignLogDataFromJson(Map<String, dynamic> json) {
  return SignLogData((json['list'] as List)
      ?.map(
          (e) => e == null ? null : SignLog.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$SignLogDataToJson(SignLogData instance) =>
    <String, dynamic>{'list': instance.list};

SignLog _$SignLogFromJson(Map<String, dynamic> json) {
  return SignLog(
      json['contract_no'] as String,
      json['contract_amount'] as String,
      json['contract_type'] as int,
      json['received_amount'] as String,
      (json['files'] as List)
          ?.map((e) =>
              e == null ? null : ExtraFile.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['id'] as int,
      json['contract_time'] as String,
      json['realname'] as String);
}

Map<String, dynamic> _$SignLogToJson(SignLog instance) => <String, dynamic>{
      'contract_no': instance.contract_no,
      'contract_amount': instance.contract_amount,
      'contract_type': instance.contract_type,
      'received_amount': instance.received_amount,
      'files': instance.files,
      'id': instance.id,
      'contract_time': instance.contract_time,
      'realname': instance.realname
    };

ExtraFile _$ExtraFileFromJson(Map<String, dynamic> json) {
  return ExtraFile(json['file_path'] as String, json['file_name'] as String);
}

Map<String, dynamic> _$ExtraFileToJson(ExtraFile instance) => <String, dynamic>{
      'file_path': instance.file_path,
      'file_name': instance.file_name
    };
