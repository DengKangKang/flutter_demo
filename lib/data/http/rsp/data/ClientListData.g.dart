// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClientListData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientListData _$ClientListDataFromJson(Map<String, dynamic> json) {
  return ClientListData(
      json['count'] as int,
      (json['rows'] as List)
          ?.map((e) =>
              e == null ? null : Client.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ClientListDataToJson(ClientListData instance) =>
    <String, dynamic>{'count': instance.count, 'rows': instance.rows};

Client _$ClientFromJson(Map<String, dynamic> json) {
  return Client(
      json['is_important'] as int,
      json['userid_sale_ct'] as String,
      json['userid_sale'] as int,
      json['id'] as int,
      json['source_name'] as String,
      json['leads_name'] as String,
      json['leads_mobile'] as String,
      json['creator'] as String,
      json['create_time'] as String,
      json['leads_contact'] as String,
      json['realname'] as String,
      json['count_cs'] as int,
      json['count_sale'] as int,
      json['count_presale'] as String,
      json['count_imp'] as String,
      json['state'] as int,
      json['annual_invoice'] as int,
      json['job_title'] as String,
      json['leads_email'] as String,
      json['on_premise'] as int,
      json['company_size'] as String,
      json['company_type'] as int,
      json['source_id'] as int,
      json['location'] as int,
      json['progress_percent'] as int,
      json['industry'] as int,
      json['anticipated_date'] as String,
      json['contract_no'] as String,
      json['contract_amount'] as String,
      json['received_payment'] as String,
      json['anticipated_amount'] as String,
      json['memo'] as String);
}

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'is_important': instance.is_important,
      'userid_sale_ct': instance.userid_sale_ct,
      'userid_sale': instance.userid_sale,
      'id': instance.id,
      'source_name': instance.source_name,
      'leads_name': instance.leads_name,
      'leads_mobile': instance.leads_mobile,
      'creator': instance.creator,
      'create_time': instance.create_time,
      'leads_contact': instance.leads_contact,
      'realname': instance.realname,
      'count_cs': instance.count_cs,
      'count_sale': instance.count_sale,
      'count_presale': instance.count_presale,
      'count_imp': instance.count_imp,
      'state': instance.state,
      'annual_invoice': instance.annual_invoice,
      'job_title': instance.job_title,
      'leads_email': instance.leads_email,
      'on_premise': instance.on_premise,
      'company_size': instance.company_size,
      'company_type': instance.company_type,
      'source_id': instance.source_id,
      'location': instance.location,
      'progress_percent': instance.progress_percent,
      'industry': instance.industry,
      'anticipated_date': instance.anticipated_date,
      'contract_no': instance.contract_no,
      'contract_amount': instance.contract_amount,
      'received_payment': instance.received_payment,
      'anticipated_amount': instance.anticipated_amount,
      'memo': instance.memo
    };
