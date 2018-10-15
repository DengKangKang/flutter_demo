// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VisitLogsRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitLogsRsp _$VisitLogsRspFromJson(Map<String, dynamic> json) {
  return new VisitLogsRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : new VisitLogsData.fromJson(json['data'] as Map<String, dynamic>));
}

abstract class _$VisitLogsRspSerializerMixin {
  int get code;
  String get msg;
  VisitLogsData get data;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'code': code, 'msg': msg, 'data': data};
}
