import 'package:flutter_app/data/http/rsp/BaseRsp.dart';
import 'package:flutter_app/data/http/rsp/data/ClientListData.dart';
import 'package:flutter_app/data/http/rsp/data/ClientNeedListData.dart';
import 'package:flutter_app/data/http/rsp/data/LoginData.dart';
import 'package:flutter_app/data/http/rsp/data/OperationLogsData.dart';
import 'package:flutter_app/data/http/rsp/data/VisitLogsData.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'package:flutter_app/data/http/rsp/DailiesRsp.g.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class DailiesRsp extends BaseRsp {
  DailiesRsp(code, msg) : super(code, msg);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory DailiesRsp.fromJson(Map<String, dynamic> json) =>
      _$DailiesRspFromJson(json);
}

@JsonSerializable()
class DailyRspData {
  int count;
  List<Daily> data;

  DailyRspData(this.count, this.data);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory DailyRspData.fromJson(Map<String, dynamic> json) =>
      _$DailyRspDataFromJson(json);
}

@JsonSerializable()
class Daily {
  String daily_time;
  String today_content;
  String today_customer_visit;
  String today_solution;
  String next_plan;
  String next_customer_visit;

  Daily(
    this.daily_time,
    this.today_content,
    this.today_customer_visit,
    this.today_solution,
    this.next_plan,
    this.next_customer_visit,
  );

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);
}
