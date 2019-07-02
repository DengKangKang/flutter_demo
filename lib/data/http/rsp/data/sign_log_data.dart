import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'sign_log_data.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class SignLogData {
  SignLogData(this.list);

  factory SignLogData.fromJson(Map<String, dynamic> json) =>
      _$SignLogDataFromJson(json);

  final List<SignLog> list;
}

@JsonSerializable()
class SignLog {
  SignLog(
      this.contract_no,
      this.contract_amount,
      this.contract_type,
      this.received_amount,
      this.files,
      this.id,
      this.contract_time,
      this.realname);

  String contract_no;
  String contract_amount;
  int contract_type;
  String received_amount;
  List<ExtraFile> files;
  int id;
  String contract_time;
  String realname;

  factory SignLog.fromJson(Map<String, dynamic> json) =>
      _$SignLogFromJson(json);
}

@JsonSerializable()
class ExtraFile{

  factory ExtraFile.fromJson(Map<String, dynamic> json) =>
      _$ExtraFileFromJson(json);

  ExtraFile(this.file_path, this.file_name);

  String file_path;
  String file_name;


}