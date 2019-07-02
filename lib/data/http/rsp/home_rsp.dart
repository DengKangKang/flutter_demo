import 'package:flutter_app/data/http/rsp/data/home_page.dart';
import 'package:json_annotation/json_annotation.dart';

import 'BaseRsp.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'home_rsp.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()

/// Every json_serializable class must have the serializer mixin.
/// It makes the generated toJson() method to be usable for the class.
/// The mixin's name follows the source class, in this case, User.

@JsonSerializable()
class HomeRsp extends BaseRsp {


  factory HomeRsp.fromJson(Map<String, dynamic> json) =>
      _$HomeRspFromJson(json);



  HomeRsp(code, msg, this.data) : super(code, msg);

  HomeRsp.base(code, msg) : super(code, msg);


  HomeData data;
}
