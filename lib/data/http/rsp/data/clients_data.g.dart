// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clients_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientsData _$ClientsDataFromJson(Map<String, dynamic> json) {
  return ClientsData(
      json['count'] as int,
      (json['rows'] as List)
          ?.map((e) =>
              e == null ? null : Client.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ClientsDataToJson(ClientsData instance) =>
    <String, dynamic>{'count': instance.count, 'rows': instance.rows};

Client _$ClientFromJson(Map<String, dynamic> json) {
  return Client(
      json['contract_amount'] as String,
      json['leads_contact'] as String,
      json['company_type'] as int,
      json['annual_invoice'] as int,
      json['memo'] as String,
      json['count_imp'] as String,
      json['industry'] as int,
      json['userid_sale'] as int,
      json['received_payment'] as String,
      json['anticipated_date'] as String,
      json['leads_mobile'] as String,
      json['leads_email'] as String,
      json['anticipated_amount'] as String,
      json['id'] as int,
      json['leads_name'] as String,
      json['state'] as int,
      json['job_title'] as String,
      json['source_name'] as String,
      json['fc_company_id'] as int,
      json['contract_no'] as String,
      json['is_important'] as int,
      json['progress_percent'] as int,
      json['creator'] as String,
      json['create_time'] as String,
      json['count_presale'] as String,
      json['on_premise'] as int,
      json['fc_company_id_test'] as int,
      json['realname'] as String,
      json['count_cs'] as int,
      json['userid_sale_ct'] as String,
      json['location'] as int,
      json['count_sale'] as int,
      json['source_id'] as int,
      json['company_size'] as String,
      json['daily'] as int);
}

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'contract_amount': instance.contract_amount,
      'leads_contact': instance.leads_contact,
      'company_type': instance.company_type,
      'annual_invoice': instance.annual_invoice,
      'memo': instance.memo,
      'count_imp': instance.count_imp,
      'industry': instance.industry,
      'userid_sale': instance.userid_sale,
      'received_payment': instance.received_payment,
      'anticipated_date': instance.anticipated_date,
      'leads_mobile': instance.leads_mobile,
      'leads_email': instance.leads_email,
      'anticipated_amount': instance.anticipated_amount,
      'id': instance.id,
      'leads_name': instance.leads_name,
      'state': instance.state,
      'job_title': instance.job_title,
      'source_name': instance.source_name,
      'fc_company_id': instance.fc_company_id,
      'contract_no': instance.contract_no,
      'is_important': instance.is_important,
      'progress_percent': instance.progress_percent,
      'creator': instance.creator,
      'create_time': instance.create_time,
      'count_presale': instance.count_presale,
      'on_premise': instance.on_premise,
      'fc_company_id_test': instance.fc_company_id_test,
      'realname': instance.realname,
      'count_cs': instance.count_cs,
      'userid_sale_ct': instance.userid_sale_ct,
      'location': instance.location,
      'count_sale': instance.count_sale,
      'source_id': instance.source_id,
      'company_size': instance.company_size,
      'daily': instance.daily
    };
