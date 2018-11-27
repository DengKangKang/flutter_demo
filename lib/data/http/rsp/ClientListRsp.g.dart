// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClientListRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientListRsp _$ClientListRspFromJson(Map<String, dynamic> json) {
  return ClientListRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : ClientListData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ClientListRspToJson(ClientListRsp instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };
