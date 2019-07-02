import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access  members in
/// the generated file. The value for this is .g.dart, where
/// the star denotes the source file name.
part 'VisitLogsData.g.dart';

@JsonSerializable()
class VisitLogsData extends Object {
  VisitLogsData(this.list);

  List<VisitLog> list;

  factory VisitLogsData.fromJson(Map<String, dynamic> json) =>
      _$VisitLogsDataFromJson(json);
}

@JsonSerializable()
class VisitLog extends Object {
  VisitLog(this.leads_id, this.create_time, this.user_id, this.user_realname,
      this.category, this.cs_log);

  @JsonKey(name: '_id')
  String leads_id;
  String create_time;
  int user_id;
  String user_realname;
  int category;
  String cs_log;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory VisitLog.fromJson(Map<String, dynamic> json) =>
      _$VisitLogFromJson(json);
}
