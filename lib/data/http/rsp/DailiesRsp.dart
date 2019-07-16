import 'package:flutter_app/data/http/rsp/BaseRsp.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'DailiesRsp.g.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class DailiesRsp extends BaseRsp {
  DailiesRsp(code, msg, this.data) : super(code, msg);

  DailyRspData data;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory DailiesRsp.fromJson(Map<String, dynamic> json) =>
      _$DailiesRspFromJson(json);
}

@JsonSerializable()
class DailyRspData {
  int count;
  List<Daily> list;

  DailyRspData(this.count, this.list);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory DailyRspData.fromJson(Map<String, dynamic> json) =>
      _$DailyRspDataFromJson(json);
}

@JsonSerializable()
class Daily {
  Daily(
    this.id,
    this.daily_time,
    this.today_content,
    this.today_customer_visit,
    this.today_solution,
    this.next_plan,
    this.next_customer_visit,
    this.user_realname,
    this.morn_type,
    this.afternoon_type,
    this.morn_content,
    this.afternoon_content,
    this.comments,
  );

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);

  @JsonKey(name: '_id')
  String id;
  String daily_time;
  String today_content;
  String today_customer_visit;
  String today_solution;
  String next_plan;
  String next_customer_visit;
  String user_realname;
  int morn_type;
  int afternoon_type;
  String morn_content;
  String afternoon_content;
  List<Comment> comments;
}

@JsonSerializable()
class Comment {
  Comment(
    this.create_time,
    this.role_type,
    this.target_name,
    this.author,
    this.view_id,
    this.viewed,
    this.daily_id,
    this.target_id,
    this.id,
    this.author_id,
    this.content,
    this.daily_time,
  );

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

//  {"_id":"5d2861294a51244d44c95a76","author":"张高彩","target_name":"","author_id":12,"target_id":null,"create_time":"2019-07-12 18:30:01","daily_id":"5d284fd35dc6e05b508e7bbc","content":"我们要努力去努力实现","viewed":1,"view_id":12
  String create_time;
  int role_type;
  String target_name;
  String author;
  int view_id;
  int viewed;
  String daily_id;
  int target_id;
  @JsonKey(name: '_id')
  String id;
  int author_id;
  String content;
  String daily_time;
}
