import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'clients_data.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class ClientsData {
  ClientsData(this.count, this.rows);

  factory ClientsData.fromJson(Map<String, dynamic> json) =>
      _$ClientsDataFromJson(json);

  final int count;
  final List<Client> rows;
}

@JsonSerializable()
class Client {
  Client(
    this.contract_amount,
    this.leads_contact,
    this.company_type,
    this.annual_invoice,
    this.memo,
    this.count_imp,
    this.industry,
    this.userid_sale,
    this.received_payment,
    this.anticipated_date,
    this.leads_mobile,
    this.leads_email,
    this.anticipated_amount,
    this.id,
    this.leads_name,
    this.state,
    this.job_title,
    this.source_name,
    this.fc_company_id,
    this.contract_no,
    this.is_important,
    this.progress_percent,
    this.creator,
    this.create_time,
    this.count_presale,
    this.on_premise,
    this.fc_company_id_test,
    this.realname,
    this.count_cs,
    this.userid_sale_ct,
    this.location,
    this.count_sale,
    this.source_id,
    this.company_size, this.daily,
  );

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  final String contract_amount;
  final String leads_contact;
  final int company_type;
  final int annual_invoice;
  final String memo;
  final String count_imp;
  final int industry;
  final int userid_sale;
  final String received_payment;
  final String anticipated_date;
  final String leads_mobile;
  final String leads_email;
  final String anticipated_amount;
  final int id;
  final String leads_name;
  final int state;
  final String job_title;
  final String source_name;
  final int fc_company_id;
  final String contract_no;
  final int is_important;
  final int progress_percent;
  final String creator;
  final String create_time;
  final String count_presale;
  final int on_premise;
  final int fc_company_id_test;
  final String realname;
  final int count_cs;
  final String userid_sale_ct;
  final int location;
  final int count_sale;
  final int source_id;
  final String company_size;
  final int daily;
}
