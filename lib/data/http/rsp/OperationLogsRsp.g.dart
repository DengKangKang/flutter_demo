// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OperationLogsRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationLogsRsp _$OperationLogsRspFromJson(Map<String, dynamic> json) {
  return new OperationLogsRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : new OperationLogsData.fromJson(
              json['data'] as Map<String, dynamic>));
}

abstract class _$OperationLogsRspSerializerMixin {
  int get code;
  String get msg;
  OperationLogsData get data;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'code': code, 'msg': msg, 'data': data};
}
