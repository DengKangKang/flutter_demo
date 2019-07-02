
import 'package:flutter_app/data/http/rsp/BaseRsp.dart';
import 'package:flutter_app/data/http/rsp/data/LoginData.dart';
import 'package:json_annotation/json_annotation.dart';

import 'data/sign_log_data.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'sign_log_rsp.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()

/// Every json_serializable class must have the serializer mixin.
/// It makes the generated toJson() method to be usable for the class.
/// The mixin's name follows the source class, in this case, User.
class SignLogRsp extends BaseRsp  {
  SignLogRsp(code, msg,this.data) : super(code, msg);
  SignLogRsp.base(code,msg) : super(code,msg);

  SignLogData data;


  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory SignLogRsp.fromJson(Map<String, dynamic> json) => _$SignLogRspFromJson(json);

}
