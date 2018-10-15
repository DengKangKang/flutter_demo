// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RadioBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RadioBean _$RadioBeanFromJson(Map<String, dynamic> json) {
  return new RadioBean(json['id'] as int, json['name'] as String);
}

abstract class _$RadioBeanSerializerMixin {
  int get id;
  String get name;
  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'name': name};
}
