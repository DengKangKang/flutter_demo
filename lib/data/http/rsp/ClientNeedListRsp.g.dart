// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClientNeedListRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientNeedListRsp _$ClientNeedListRspFromJson(Map<String, dynamic> json) {
  return ClientNeedListRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : ClientNeedListData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ClientNeedListRspToJson(ClientNeedListRsp instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };
