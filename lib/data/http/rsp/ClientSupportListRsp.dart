import 'package:flutter_app/data/http/rsp/BaseRsp.dart';
import 'package:flutter_app/data/http/rsp/data/ClientListData.dart';
import 'package:flutter_app/data/http/rsp/data/ClientNeedListData.dart';
import 'package:flutter_app/data/http/rsp/data/LoginData.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'ClientSupportListRsp.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class ClientSupportListRsp extends BaseRsp
   {
  ClientSupportListRsp(code, msg, this.data) : super(code, msg);

  List<ClientSupport> data;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory ClientSupportListRsp.fromJson(Map<String, dynamic> json) =>
      _$ClientSupportListRspFromJson(json);
}

@JsonSerializable()
class ClientSupport extends Object {
//    leads_id : 7093
//    create_time : 2018-09-29 17:51:03
//    creator_id : 12
//    creator_realname : 张高彩
//    requirement : 王浩测试新增的需求

  ClientSupport(
    this.check_amount,
    this.application_type,
    this.device_name,
    this.device_quantity,
    this.fc_admin_name,
    this.email,
    this.features,
    this.id,
    this.realname,
    this.responsibility,
    this.initial_password,
    this.is_purchase,
    this.leads_id,
    this.memo,
    this.price,
    this.requirements,
    this.state,
    this.prename,
    this.visit_progress,
    this.visit_time,
    this.time_limit,
    this.create_time,
    this.agree_time,
    this.fc_company_id,
    this.fc_company_id_test,
  );

  int check_amount;
  int application_type;
  int device_name;
  int device_quantity;
  String fc_admin_name;
  String email;
  String features;
  int id;
  String realname;
  int responsibility;
  String initial_password;
  int is_purchase;
  int leads_id;
  String memo;
  String price;
  String requirements;
  int state;
  String prename;
  int visit_progress;
  String visit_time;
  String time_limit;
  String create_time;
  String agree_time;
  String fc_company_id;
  int fc_company_id_test;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory ClientSupport.fromJson(Map<String, dynamic> json) =>
      _$ClientSupportFromJson(json);
}
