import 'package:flutter_app/data/http/rsp/BaseRsp.dart';
import 'package:json_annotation/json_annotation.dart';

import 'account_info.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'count_use.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class CountUseRsp extends BaseRsp {
  CountUseRsp(code, msg, this.data) : super(code, msg);

  CountUseRsp.base(code, msg) : super(code, msg);

  factory CountUseRsp.fromJson(Map<String, dynamic> json) =>
      _$CountUseRspFromJson(json);

  CountUseData data;
}


@JsonSerializable()
class CountUseData {
  CountUseData(this.rows, this.count, this.quota);
  factory CountUseData.fromJson(Map<String, dynamic> json) =>
      _$CountUseDataFromJson(json);

  List<CountUse> rows;
  int count;
  int quota;
}

@JsonSerializable()
class CountUse {
  CountUse(this.count, this.dt);

  factory CountUse.fromJson(Map<String, dynamic> json) =>
      _$CountUseFromJson(json);

  int count;
  String dt;

}