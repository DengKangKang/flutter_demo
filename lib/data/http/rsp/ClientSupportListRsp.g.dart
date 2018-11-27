// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClientSupportListRsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientSupportListRsp _$ClientSupportListRspFromJson(Map<String, dynamic> json) {
  return ClientSupportListRsp(
      json['code'],
      json['msg'],
      (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : ClientSupport.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ClientSupportListRspToJson(
        ClientSupportListRsp instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

ClientSupport _$ClientSupportFromJson(Map<String, dynamic> json) {
  return ClientSupport(
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

Map<String, dynamic> _$ClientSupportToJson(ClientSupport instance) =>
    <String, dynamic>{
      'check_amount': instance.check_amount,
      'application_type': instance.application_type,
      'device_name': instance.device_name,
      'device_quantity': instance.device_quantity,
      'fc_admin_name': instance.fc_admin_name,
      'email': instance.email,
      'features': instance.features,
      'id': instance.id,
      'realname': instance.realname,
      'responsibility': instance.responsibility,
      'initial_password': instance.initial_password,
      'is_purchase': instance.is_purchase,
      'leads_id': instance.leads_id,
      'memo': instance.memo,
      'price': instance.price,
      'requirements': instance.requirements,
      'state': instance.state,
      'prename': instance.prename,
      'visit_progress': instance.visit_progress,
      'visit_time': instance.visit_time,
      'time_limit': instance.time_limit,
      'create_time': instance.create_time,
      'agree_time': instance.agree_time,
      'fc_company_id': instance.fc_company_id,
      'fc_company_id_test': instance.fc_company_id_test
    };
