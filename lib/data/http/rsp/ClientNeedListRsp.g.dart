// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClientNeedListRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientNeedListRsp _$ClientNeedListRspFromJson(Map<String, dynamic> json) {
  return new ClientNeedListRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : new ClientNeedListData.fromJson(
              json['data'] as Map<String, dynamic>));
}

abstract class _$ClientNeedListRspSerializerMixin {
  int get code;
  String get msg;
  ClientNeedListData get data;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'code': code, 'msg': msg, 'data': data};
}
