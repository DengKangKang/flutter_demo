// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clients_rsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientsRsp _$ClientsRspFromJson(Map<String, dynamic> json) {
  return ClientsRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : ClientsData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ClientsRspToJson(ClientsRsp instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };
