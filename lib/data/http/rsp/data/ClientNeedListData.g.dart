// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClientNeedListData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientNeedListData _$ClientNeedListDataFromJson(Map<String, dynamic> json) {
  return ClientNeedListData((json['list'] as List)
      ?.map((e) => e == null ? null : Need.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$ClientNeedListDataToJson(ClientNeedListData instance) =>
    <String, dynamic>{'list': instance.list};

Need _$NeedFromJson(Map<String, dynamic> json) {
  return Need(
      json['leads_id'] as int,
      json['create_time'] as String,
      json['creator_id'] as int,
      json['creator_realname'] as String,
      json['requirement'] as String);
}

Map<String, dynamic> _$NeedToJson(Need instance) => <String, dynamic>{
      'leads_id': instance.leads_id,
      'create_time': instance.create_time,
      'creator_id': instance.creator_id,
      'creator_realname': instance.creator_realname,
      'requirement': instance.requirement
    };
