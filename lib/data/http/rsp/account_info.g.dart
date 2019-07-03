// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountInfoRsp _$AccountInfoRspFromJson(Map<String, dynamic> json) {
  return AccountInfoRsp(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : AccountData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$AccountInfoRspToJson(AccountInfoRsp instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

AccountData _$AccountDataFromJson(Map<String, dynamic> json) {
  return AccountData((json['detail'] as List)
      ?.map(
          (e) => e == null ? null : Detail.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$AccountDataToJson(AccountData instance) =>
    <String, dynamic>{'detail': instance.detail};

Detail _$DetailFromJson(Map<String, dynamic> json) {
  return Detail(
      json['agree_time'] as String,
      json['time_limit'] as String,
      json['memo'] as String,
      json['features'] as String,
      json['device_name'] as String,
      json['leads_id'] as int,
      json['responsibility'] as String,
      json['train_place'] as String,
      json['price'] as String,
      json['initial_password'] as String,
      (json['quota'] as List)
          ?.map((e) => e == null
              ? null
              : QuotaEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['id'] as int,
      json['state'] as int,
      json['email'] as String,
      json['fc_company_id'] as int,
      json['requirements'] as String,
      json['device_quantity'] as String,
      json['create_time'] as String,
      json['visit_time'] as String,
      json['expire_time'] as String,
      json['fc_company_id_test'] as int,
      json['prename'] as String,
      json['realname'] as String,
      json['is_purchase'] as String,
      json['visit_progress'] as String,
      json['staff_limit'] as int,
      json['check_amount'] as int,
      json['fc_admin_name'] as String);
}

Map<String, dynamic> _$DetailToJson(Detail instance) => <String, dynamic>{
      'agree_time': instance.agree_time,
      'time_limit': instance.time_limit,
      'memo': instance.memo,
      'features': instance.features,
      'device_name': instance.device_name,
      'leads_id': instance.leads_id,
      'responsibility': instance.responsibility,
      'train_place': instance.train_place,
      'price': instance.price,
      'initial_password': instance.initial_password,
      'quota': instance.quota,
      'id': instance.id,
      'state': instance.state,
      'email': instance.email,
      'fc_company_id': instance.fc_company_id,
      'requirements': instance.requirements,
      'device_quantity': instance.device_quantity,
      'create_time': instance.create_time,
      'visit_time': instance.visit_time,
      'expire_time': instance.expire_time,
      'fc_company_id_test': instance.fc_company_id_test,
      'prename': instance.prename,
      'realname': instance.realname,
      'is_purchase': instance.is_purchase,
      'visit_progress': instance.visit_progress,
      'staff_limit': instance.staff_limit,
      'check_amount': instance.check_amount,
      'fc_admin_name': instance.fc_admin_name
    };

QuotaEntity _$QuotaEntityFromJson(Map<String, dynamic> json) {
  return QuotaEntity(
      json['company_id'] as String,
      json['create_time'] as String,
      json['quota'] as int,
      json['expiry_date'] as String,
      json['id'] as int,
      json['used'] as int,
      json['category'] as int);
}

Map<String, dynamic> _$QuotaEntityToJson(QuotaEntity instance) =>
    <String, dynamic>{
      'company_id': instance.company_id,
      'create_time': instance.create_time,
      'quota': instance.quota,
      'expiry_date': instance.expiry_date,
      'id': instance.id,
      'used': instance.used,
      'category': instance.category
    };
