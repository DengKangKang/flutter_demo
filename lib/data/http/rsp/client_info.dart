import 'package:flutter_app/data/http/rsp/BaseRsp.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'client_info.g.dart';


/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class ClientInfoRsp extends BaseRsp {
  ClientInfoRsp(code, msg, this.data) : super(code, msg);

  ClientInfoRsp.base(code, msg) : super(code, msg);

  factory ClientInfoRsp.fromJson(Map<String, dynamic> json) =>
      _$ClientInfoRspFromJson(json);

  ClientInfoData data;
}

@JsonSerializable()
class ClientInfoData{

  ClientInfoData(this.rows);

  factory ClientInfoData.fromJson(Map<String, dynamic> json) =>
      _$ClientInfoDataFromJson(json);

  List<ClientInfo> rows;


}

@JsonSerializable()
class ClientInfo{

  ClientInfo(this.name, this.address, this.channel_name, this.account_bank,
      this.account_number, this.telephone, this.client_key, this.client_secret,
      this.company_key, this.company_secret, this.dkt_key, this.dkt_secret);

  factory ClientInfo.fromJson(Map<String, dynamic> json) =>
      _$ClientInfoFromJson(json);

   String creator;
   String name;
   String address;
   String channel_name;
   String account_bank;
   String account_number;
   String telephone;

   String client_key;
   String client_secret;

   String company_key;
   String company_secret;

   String dkt_key;
   String dkt_secret;




}
