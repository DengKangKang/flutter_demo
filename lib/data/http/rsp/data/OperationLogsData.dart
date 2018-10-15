import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'OperationLogsData.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class OperationLogsData extends Object with _$OperationLogsDataSerializerMixin {
  OperationLogsData(this.list);

  List<OperationLog> list;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory OperationLogsData.fromJson(Map<String, dynamic> json) =>
      _$OperationLogsDataFromJson(json);
}

@JsonSerializable()
class OperationLog extends Object with _$OperationLogSerializerMixin {

  OperationLog(this.leads_id, this.create_time, this.user_id,
      this.user_realname, this.system_log, this.category);

  String leads_id;
  String create_time;
  int user_id;
  String user_realname;
  String system_log;
  int category;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory OperationLog.fromJson(Map<String, dynamic> json) => _$OperationLogFromJson(json);


}
