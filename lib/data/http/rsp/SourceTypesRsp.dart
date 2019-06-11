import 'package:flutter_app/data/http/rsp/BaseRsp.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'SourceTypesRsp.g.dart';

@JsonSerializable()
class SourceTypesRsp extends BaseRsp {


  factory SourceTypesRsp.fromJson(Map<String, dynamic> json) =>
      _$SourceTypesRspFromJson(json);



  SourceTypesRsp(code, msg, this.data) : super(code, msg);

  SourceTypesRsp.base(code, msg) : super(code, msg);


  List<RadioBean> data;
}
