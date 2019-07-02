import 'package:flutter_app/data/http/rsp/data/home_page.dart';
import 'package:json_annotation/json_annotation.dart';

import 'BaseRsp.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'apply_info.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class ApplyInfoRsp extends BaseRsp {
  factory ApplyInfoRsp.fromJson(Map<String, dynamic> json) =>
      _$ApplyInfoRspFromJson(json);

  ApplyInfoRsp(code, msg, this.data) : super(code, msg);

  ApplyInfoRsp.base(code, msg) : super(code, msg);

  ApplyInfoData data;
}

@JsonSerializable()
class ApplyInfoData {
  ApplyInfoData(
      this.state_formal, this.state_test, this.state_train, this.logs);

  factory ApplyInfoData.fromJson(Map<String, dynamic> json) =>
      _$ApplyInfoDataFromJson(json);

//  {"state_formal":1,"state_test":0,"state_train":0,"logs":[]}
  final int state_formal;

  final int state_test;

  final int state_train;
  final List<TrainLog> logs;
}


@JsonSerializable()
class TrainLog{
  TrainLog(this.train_place, this.realname, this.memo, this.requirements, this.prename, this.visit_time, this.agree_time);

  final String train_place;
  final String realname;
  final String memo;
  final String requirements;
  final String prename;
  final String visit_time;
  final String agree_time;

  factory TrainLog.fromJson(Map<String, dynamic> json) =>
      _$TrainLogFromJson(json);
}