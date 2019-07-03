import 'package:flutter_app/data/http/rsp/BaseRsp.dart';
import 'package:flutter_app/data/http/rsp/data/ClientListData.dart';
import 'package:flutter_app/data/http/rsp/data/LoginData.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'account_info.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class AccountInfoRsp extends BaseRsp {
  AccountInfoRsp(code, msg, this.data) : super(code, msg);

  AccountInfoRsp.base(code, msg) : super(code, msg);

  factory AccountInfoRsp.fromJson(Map<String, dynamic> json) =>
      _$AccountInfoRspFromJson(json);

  AccountData data;
}

@JsonSerializable()
class AccountData {
  AccountData(this.detail);

  factory AccountData.fromJson(Map<String, dynamic> json) =>
      _$AccountDataFromJson(json);
  final List<Detail> detail;
}

@JsonSerializable()
class Detail {
  Detail(
      this.agree_time,
      this.time_limit,
      this.memo,
      this.features,
      this.device_name,
      this.leads_id,
      this.responsibility,
      this.train_place,
      this.price,
      this.initial_password,
      this.quota,
      this.id,
      this.state,
      this.email,
      this.fc_company_id,
      this.requirements,
      this.device_quantity,
      this.create_time,
      this.visit_time,
      this.expire_time,
      this.fc_company_id_test,
      this.prename,
      this.realname,
      this.is_purchase,
      this.visit_progress,
      this.staff_limit,
      this.check_amount,
      this.fc_admin_name);

  factory Detail.fromJson(Map<String, dynamic> json) => _$DetailFromJson(json);

  String agree_time;
  String time_limit;
  String memo;
  String features;
  String device_name;
  int leads_id;
  String responsibility;
  String train_place;
  String price;
  String initial_password;
  List<QuotaEntity> quota;
  int id;
  int state;
  String email;
  int fc_company_id;
  String requirements;
  String device_quantity;
  String create_time;
  String visit_time;
  String expire_time;
  int fc_company_id_test;
  String prename;
  String realname;
  String is_purchase;
  String visit_progress;
  int staff_limit;
  int check_amount;
  String fc_admin_name;
}

@JsonSerializable()
class QuotaEntity {
  QuotaEntity(this.company_id, this.create_time, this.quota, this.expiry_date,
      this.id, this.used, this.category);

  factory QuotaEntity.fromJson(Map<String, dynamic> json) =>
      _$QuotaEntityFromJson(json);
  String company_id;
  String create_time;
  int quota;
  String expiry_date;
  int id;
  int used;
  int category;
}
