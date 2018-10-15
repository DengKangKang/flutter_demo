import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'ClientListData.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class ClientListData extends Object with _$ClientListDataSerializerMixin {
  ClientListData(this.count, this.rows);

  int count;
  List<Client> rows;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory ClientListData.fromJson(Map<String, dynamic> json) =>
      _$ClientListDataFromJson(json);
}

@JsonSerializable()
class Client extends Object with _$ClientSerializerMixin {
  Client(
    this.is_important,
    this.userid_sale_ct,
    this.userid_sale,
    this.id,
    this.source_name,
    this.leads_name,
    this.leads_mobile,
    this.creator,
    this.create_time,
    this.leads_contact,
    this.realname,
    this.count_cs,
    this.count_sale,
    this.count_presale,
    this.count_imp,
    this.state,
    this.annual_invoice,
    this.job_title,
    this.leads_email,
    this.on_premise,
    this.company_size,
    this.company_type,
    this.source_id,
    this.location,
    this.progress_percent,
    this.industry,
    this.anticipated_date,
    this.contract_no,
    this.contract_amount,
    this.received_payment,
    this.anticipated_amount,
    this.memo,
  );

  int is_important;
  String userid_sale_ct;
  int userid_sale;
  int id;
  String source_name;
  String leads_name;
  String leads_mobile;
  String creator;
  String create_time;
  String leads_contact;
  String realname;
  int count_cs;
  int count_sale;
  String count_presale;
  String count_imp;
  int state;
  int annual_invoice;
  String job_title;
  String leads_email;
  int on_premise;
  String company_size;
  int company_type;
  int source_id;
  int location;
  int progress_percent;
  int industry;
  String anticipated_date;
  String contract_no;
  String contract_amount;
  String received_payment;
  String anticipated_amount;
  String memo;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
}
