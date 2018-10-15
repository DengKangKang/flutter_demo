// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SourceTypesRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceTypesRsp _$SourceTypesRspFromJson(Map<String, dynamic> json) {
  return new SourceTypesRsp(
      json['code'],
      json['msg'],
      (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : new RadioBean.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

abstract class _$SourceTypesRspSerializerMixin {
  int get code;
  String get msg;
  List<RadioBean> get data;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'code': code, 'msg': msg, 'data': data};
}
