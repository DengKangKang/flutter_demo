// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClientListRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientListRsp _$ClientListRspFromJson(Map<String, dynamic> json) {
  return new ClientListRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : new ClientListData.fromJson(json['data'] as Map<String, dynamic>));
}

abstract class _$ClientListRspSerializerMixin {
  int get code;
  String get msg;
  ClientListData get data;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'code': code, 'msg': msg, 'data': data};
}
