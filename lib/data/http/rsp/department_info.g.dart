// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentInfo _$DepartmentInfoFromJson(Map<String, dynamic> json) {
  return DepartmentInfo(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : DepartmentData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$DepartmentInfoToJson(DepartmentInfo instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DepartmentData _$DepartmentDataFromJson(Map<String, dynamic> json) {
  return DepartmentData(
      (json['user'] as List)
          ?.map((e) =>
              e == null ? null : User.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['department'] as List)
          ?.map((e) =>
              e == null ? null : Department.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DepartmentDataToJson(DepartmentData instance) =>
    <String, dynamic>{'user': instance.user, 'department': instance.department};

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      json['user_id'] as int,
      json['username'] as String,
      json['create_time'] as String,
      json['is_link'] as int,
      json['is_admin'] as int);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'user_id': instance.user_id,
      'username': instance.username,
      'create_time': instance.create_time,
      'is_link': instance.is_link,
      'is_admin': instance.is_admin
    };

Department _$DepartmentFromJson(Map<String, dynamic> json) {
  return Department(json['name'] as String);
}

Map<String, dynamic> _$DepartmentToJson(Department instance) =>
    <String, dynamic>{'name': instance.name};
