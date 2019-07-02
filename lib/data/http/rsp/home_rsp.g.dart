// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_rsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeRsp _$HomeRspFromJson(Map<String, dynamic> json) {
  return HomeRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : HomeData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$HomeRspToJson(HomeRsp instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };
