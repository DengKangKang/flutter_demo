import 'package:flutter_app/data/http/rsp/BaseRsp.dart';
import 'package:flutter_app/data/http/rsp/DailiesRsp.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'comments.g.dart';


/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class CommentsRsp extends BaseRsp {
  CommentsRsp(code, msg, this.data) : super(code, msg);

  CommentsRsp.base(code, msg) : super(code, msg);

  factory CommentsRsp.fromJson(Map<String, dynamic> json) =>
      _$CommentsRspFromJson(json);

  List<Comment> data;
}

