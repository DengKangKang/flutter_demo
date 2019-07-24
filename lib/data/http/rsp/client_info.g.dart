// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientInfoRsp _$ClientInfoRspFromJson(Map<String, dynamic> json) {
  return ClientInfoRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : ClientInfoData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ClientInfoRspToJson(ClientInfoRsp instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

ClientInfoData _$ClientInfoDataFromJson(Map<String, dynamic> json) {
  return ClientInfoData((json['rows'] as List)
      ?.map((e) =>
          e == null ? null : ClientInfo.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$ClientInfoDataToJson(ClientInfoData instance) =>
    <String, dynamic>{'rows': instance.rows};

ClientInfo _$ClientInfoFromJson(Map<String, dynamic> json) {
  return ClientInfo(
      json['name'] as String,
      json['address'] as String,
      json['channel_name'] as String,
      json['account_bank'] as String,
      json['account_number'] as String,
      json['telephone'] as String,
      json['client_key'] as String,
      json['client_secret'] as String,
      json['company_key'] as String,
      json['company_secret'] as String,
      json['dkt_key'] as String,
      json['dkt_secret'] as String)
    ..creator = json['creator'] as String;
}

Map<String, dynamic> _$ClientInfoToJson(ClientInfo instance) =>
    <String, dynamic>{
      'creator': instance.creator,
      'name': instance.name,
      'address': instance.address,
      'channel_name': instance.channel_name,
      'account_bank': instance.account_bank,
      'account_number': instance.account_number,
      'telephone': instance.telephone,
      'client_key': instance.client_key,
      'client_secret': instance.client_secret,
      'company_key': instance.company_key,
      'company_secret': instance.company_secret,
      'dkt_key': instance.dkt_key,
      'dkt_secret': instance.dkt_secret
    };
