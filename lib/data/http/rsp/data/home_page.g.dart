// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeData _$HomeDataFromJson(Map<String, dynamic> json) {
  return HomeData((json['list'] as List)
      ?.map((e) =>
          e == null ? null : HomeInfo.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$HomeDataToJson(HomeData instance) =>
    <String, dynamic>{'list': instance.list};

HomeInfo _$HomeInfoFromJson(Map<String, dynamic> json) {
  return HomeInfo(json['p_customer'] as int, json['c_customer'] as int,
      json['p_clue'] as int, json['c_clue'] as int);
}

Map<String, dynamic> _$HomeInfoToJson(HomeInfo instance) => <String, dynamic>{
      'p_customer': instance.p_customer,
      'c_customer': instance.c_customer,
      'p_clue': instance.p_clue,
      'c_clue': instance.c_clue
    };
