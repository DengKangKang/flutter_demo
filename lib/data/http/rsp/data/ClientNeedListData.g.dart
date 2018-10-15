// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClientNeedListData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientNeedListData _$ClientNeedListDataFromJson(Map<String, dynamic> json) {
  return new ClientNeedListData((json['list'] as List)
      ?.map((e) =>
          e == null ? null : new Need.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

abstract class _$ClientNeedListDataSerializerMixin {
  List<Need> get list;
  Map<String, dynamic> toJson() => <String, dynamic>{'list': list};
}

Need _$NeedFromJson(Map<String, dynamic> json) {
  return new Need(
      json['leads_id'] as int,
      json['create_time'] as String,
      json['creator_id'] as int,
      json['creator_realname'] as String,
      json['requirement'] as String);
}

abstract class _$NeedSerializerMixin {
  int get leads_id;
  String get create_time;
  int get creator_id;
  String get creator_realname;
  String get requirement;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'leads_id': leads_id,
        'create_time': create_time,
        'creator_id': creator_id,
        'creator_realname': creator_realname,
        'requirement': requirement
      };
}
