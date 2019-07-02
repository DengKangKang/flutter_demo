import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/data/http/rsp/data/clients_data.dart';
import 'package:json_annotation/json_annotation.dart';

import 'BaseRsp.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'applied_plugins_rsp.g.dart';

@JsonSerializable()
class AppliedPluginsRsp extends BaseRsp {
  AppliedPluginsRsp(code, msg, this.data) : super(code, msg);

  AppliedPluginsRsp.base(code, msg) : super(code, msg);

  factory AppliedPluginsRsp.fromJson(Map<String, dynamic> json) =>
      _$AppliedPluginsRspFromJson(json);

  List<Plugin> data;
}

@JsonSerializable()
class Plugin {
//  {"branch_limit":0,"plugin_id":2,"expiration_date":"2019-07-02","create_time":"2019-07-01","name":"2 连续录入 [录入优化]"}

  Plugin([
    this.id,
    this.name,
    this.branch_limit,
    this.expiration_date,
    this.create_time,
    this.quota,
  ]);

  factory Plugin.fromJson(Map<String, dynamic> json) => _$PluginFromJson(json);
  int branch_limit;
  @JsonKey(name: 'plugin_id')
  int id;
  String expiration_date;
  String create_time;
  String name;


  List<Quota> quota;

  List<Plugin> ocrSonPlugins;
  List<Plugin> invoicePlugins;
}

@JsonSerializable()
class Quota {
  Quota(this.category, this.quota);
  factory Quota.fromJson(Map<String, dynamic> json) => _$QuotaFromJson(json);


  final int category;
  final int quota;


}
