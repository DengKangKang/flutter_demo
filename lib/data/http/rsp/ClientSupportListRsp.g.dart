// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClientSupportListRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientSupportListRsp _$ClientSupportListRspFromJson(Map<String, dynamic> json) {
  return new ClientSupportListRsp(
      json['code'],
      json['msg'],
      (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : new ClientSupport.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

abstract class _$ClientSupportListRspSerializerMixin {
  int get code;
  String get msg;
  List<ClientSupport> get data;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'code': code, 'msg': msg, 'data': data};
}

ClientSupport _$ClientSupportFromJson(Map<String, dynamic> json) {
  return new ClientSupport(
      json['check_amount'] as int,
      json['application_type'] as int,
      json['device_name'] as int,
      json['device_quantity'] as int,
      json['fc_admin_name'] as String,
      json['email'] as String,
      json['features'] as String,
      json['id'] as int,
      json['realname'] as String,
      json['responsibility'] as int,
      json['initial_password'] as String,
      json['is_purchase'] as int,
      json['leads_id'] as int,
      json['memo'] as String,
      json['price'] as String,
      json['requirements'] as String,
      json['state'] as int,
      json['prename'] as String,
      json['visit_progress'] as int,
      json['visit_time'] as String,
      json['time_limit'] as String,
      json['create_time'] as String,
      json['agree_time'] as String,
      json['fc_company_id'] as String,
      json['fc_company_id_test'] as int);
}

abstract class _$ClientSupportSerializerMixin {
  int get check_amount;
  int get application_type;
  int get device_name;
  int get device_quantity;
  String get fc_admin_name;
  String get email;
  String get features;
  int get id;
  String get realname;
  int get responsibility;
  String get initial_password;
  int get is_purchase;
  int get leads_id;
  String get memo;
  String get price;
  String get requirements;
  int get state;
  String get prename;
  int get visit_progress;
  String get visit_time;
  String get time_limit;
  String get create_time;
  String get agree_time;
  String get fc_company_id;
  int get fc_company_id_test;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'check_amount': check_amount,
        'application_type': application_type,
        'device_name': device_name,
        'device_quantity': device_quantity,
        'fc_admin_name': fc_admin_name,
        'email': email,
        'features': features,
        'id': id,
        'realname': realname,
        'responsibility': responsibility,
        'initial_password': initial_password,
        'is_purchase': is_purchase,
        'leads_id': leads_id,
        'memo': memo,
        'price': price,
        'requirements': requirements,
        'state': state,
        'prename': prename,
        'visit_progress': visit_progress,
        'visit_time': visit_time,
        'time_limit': time_limit,
        'create_time': create_time,
        'agree_time': agree_time,
        'fc_company_id': fc_company_id,
        'fc_company_id_test': fc_company_id_test
      };
}
