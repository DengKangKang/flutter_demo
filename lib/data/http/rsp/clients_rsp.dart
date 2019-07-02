import 'package:flutter_app/data/http/rsp/data/clients_data.dart';
import 'package:json_annotation/json_annotation.dart';

import 'BaseRsp.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'clients_rsp.g.dart';

@JsonSerializable()
class ClientsRsp extends BaseRsp {
  ClientsRsp(code, msg, this.data) : super(code, msg);

  ClientsRsp.base(code, msg) : super(code, msg);

  factory ClientsRsp.fromJson(Map<String, dynamic> json) =>
      _$ClientsRspFromJson(json);

  ClientsData data;
}
