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
  VisitLog(
      this.leads_id,
      this.create_time,
      this.user_id,
      this.user_realname,
      this.category,
      this.cs_log,
      this.sale_visit_time,
      this.sale_visit_form,
      this.sale_feedback,
      this.sale_solution,
      this.expense,
      this.visitor,
      this.visit_goal);

  factory VisitLog.fromJson(Map<String, dynamic> json) =>
      _$VisitLogFromJson(json);

  @JsonKey(name: '_id')
  String leads_id;
  String create_time;
  int user_id;
  String user_realname;
  int category;
  String cs_log;
  String sale_visit_time;
  String sale_visit_form;
  String sale_feedback;
  String sale_solution;
  int expense;
  String visitor;
  String visit_goal;
}
