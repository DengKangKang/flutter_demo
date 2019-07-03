import 'package:flutter_app/data/http/rsp/BaseRsp.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'department_info.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class DepartmentInfo extends BaseRsp {
  DepartmentInfo(code, msg, this.data) : super(code, msg);

  DepartmentInfo.base(code, msg) : super(code, msg);

  factory DepartmentInfo.fromJson(Map<String, dynamic> json) =>
      _$DepartmentInfoFromJson(json);

  DepartmentData data;
}

@JsonSerializable()
class DepartmentData {
  DepartmentData(this.user, this.department);

  factory DepartmentData.fromJson(Map<String, dynamic> json) =>
      _$DepartmentDataFromJson(json);
  List<User> user;
  List<Department> department;
}

@JsonSerializable()
class User {
  User(this.user_id, this.username, this.create_time, this.is_link,
      this.is_admin);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  int user_id;
  String username;
  String create_time;
  int is_link;
  int is_admin;
}

@JsonSerializable()
class Department {
  Department(this.name);

  factory Department.fromJson(Map<String, dynamic> json) =>
      _$DepartmentFromJson(json);
  String name;
}
