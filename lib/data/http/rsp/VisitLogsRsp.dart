import 'package:flutter_app/data/http/rsp/BaseRsp.dart';
import 'package:flutter_app/data/http/rsp/data/ClientListData.dart';
import 'package:flutter_app/data/http/rsp/data/ClientNeedListData.dart';
import 'package:flutter_app/data/http/rsp/data/LoginData.dart';
import 'package:flutter_app/data/http/rsp/data/VisitLogsData.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'VisitLogsRsp.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class VisitLogsRsp extends BaseRsp {
  VisitLogsRsp(code, msg, this.data) : super(code, msg);

  VisitLogsRsp.base(code, msg) : super(code, msg);

  VisitLogsData data;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory VisitLogsRsp.fromJson(Map<String, dynamic> json) =>
      _$VisitLogsRspFromJson(json);
}
