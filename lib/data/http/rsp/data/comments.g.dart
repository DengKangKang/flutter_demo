// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentsRsp _$CommentsRspFromJson(Map<String, dynamic> json) {
  return CommentsRsp(
      json['code'],
      json['msg'],
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$CommentsRspToJson(CommentsRsp instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };
