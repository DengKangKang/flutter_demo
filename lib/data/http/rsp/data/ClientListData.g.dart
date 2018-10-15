// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClientListData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientListData _$ClientListDataFromJson(Map<String, dynamic> json) {
  return new ClientListData(
      json['count'] as int,
      (json['rows'] as List)
          ?.map((e) =>
              e == null ? null : new Client.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

abstract class _$ClientListDataSerializerMixin {
  int get count;
  List<Client> get rows;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'count': count, 'rows': rows};
}

Client _$ClientFromJson(Map<String, dynamic> json) {
  return new Client(
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

abstract class _$ClientSerializerMixin {
  int get is_important;
  String get userid_sale_ct;
  int get userid_sale;
  int get id;
  String get source_name;
  String get leads_name;
  String get leads_mobile;
  String get creator;
  String get create_time;
  String get leads_contact;
  String get realname;
  int get count_cs;
  int get count_sale;
  String get count_presale;
  String get count_imp;
  int get state;
  int get annual_invoice;
  String get job_title;
  String get leads_email;
  int get on_premise;
  String get company_size;
  int get company_type;
  int get source_id;
  int get location;
  int get progress_percent;
  int get industry;
  String get anticipated_date;
  String get contract_no;
  String get contract_amount;
  String get received_payment;
  String get anticipated_amount;
  String get memo;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'is_important': is_important,
        'userid_sale_ct': userid_sale_ct,
        'userid_sale': userid_sale,
        'id': id,
        'source_name': source_name,
        'leads_name': leads_name,
        'leads_mobile': leads_mobile,
        'creator': creator,
        'create_time': create_time,
        'leads_contact': leads_contact,
        'realname': realname,
        'count_cs': count_cs,
        'count_sale': count_sale,
        'count_presale': count_presale,
        'count_imp': count_imp,
        'state': state,
        'annual_invoice': annual_invoice,
        'job_title': job_title,
        'leads_email': leads_email,
        'on_premise': on_premise,
        'company_size': company_size,
        'company_type': company_type,
        'source_id': source_id,
        'location': location,
        'progress_percent': progress_percent,
        'industry': industry,
        'anticipated_date': anticipated_date,
        'contract_no': contract_no,
        'contract_amount': contract_amount,
        'received_payment': received_payment,
        'anticipated_amount': anticipated_amount,
        'memo': memo
      };
}
