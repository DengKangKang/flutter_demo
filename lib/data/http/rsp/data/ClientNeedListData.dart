import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access  members in
/// the generated file. The value for this is .g.dart, where
/// the star denotes the source file name.
part 'ClientNeedListData.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()

/// Every json_serializable class must have the serializer mixin.
/// It makes the generated toJson() method to be usable for the class.
/// The mixin's name follows the source class, in this case, User.
class ClientNeedListData extends Object {
  ClientNeedListData(this.list);

  List<Need> list;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory ClientNeedListData.fromJson(Map<String, dynamic> json) => _$ClientNeedListDataFromJson(json);

}

@JsonSerializable()
class Need extends Object   {


//    leads_id : 7093
//    create_time : 2018-09-29 17:51:03
//    creator_id : 12
//    creator_realname : 张高彩
//    requirement : 王浩测试新增的需求

  Need( this.leads_id, this.create_time, this.creator_id,
      this.creator_realname, this.requirement);

   int leads_id;
   String create_time;
   int creator_id;
   String creator_realname;
   String requirement;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory Need.fromJson(Map<String, dynamic> json) => _$NeedFromJson(json);



}
