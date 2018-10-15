// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BaseRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseRsp _$BaseRspFromJson(Map<String, dynamic> json) {
  return new BaseRsp(json['code'] as int, json['msg'] as String);
}

abstract class _$BaseRspSerializerMixin {
  int get code;
  String get msg;
  Map<String, dynamic> toJson() => <String, dynamic>{'code': code, 'msg': msg};
}
