import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access  members in
/// the generated file. The value for this is .g.dart, where
/// the star denotes the source file name.
part 'VisitLogsData.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()

/// Every json_serializable class must have the serializer mixin.
/// It makes the generated toJson() method to be usable for the class.
/// The mixin's name follows the source class, in this case, User.
class VisitLogsData extends Object{
  VisitLogsData(this.list);

  List<VisitLog> list;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory VisitLogsData.fromJson(Map<String, dynamic> json) => _$VisitLogsDataFromJson(json);

}

@JsonSerializable()
class VisitLog extends Object {

  VisitLog(this.leads_id, this.create_time, this.user_id, this.user_realname,
      this.category, this.sale_visit_time, this.sale_visit_form,
      this.sale_feedback, this.sale_solution, this.expense, this.visitor,
      this.visit_goal,);

//    _id : 5bbc476baea74270e0601217
//    leads_id : 7093
//    create_time : 2018-10-09 14:15:07
//    user_id : 12
//    user_realname : 张高彩
//    category : 3
//    sale_visit_time : 2018-10-01 00:00:00
//    sale_visit_form : 2
//    sale_feedback : 正在使用
//    sale_solution : 进一步跟进
//    expense : 140
//    visitor : 赵德汉
//    visit_goal : 签约产品

   String leads_id;
   String create_time;
   int user_id;
   String user_realname;
   int category;
   String sale_visit_time;
   int sale_visit_form;
   String sale_feedback;
   String sale_solution;
   String expense;
   String visitor;
   String visit_goal;



   /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory VisitLog.fromJson(Map<String, dynamic> json) => _$VisitLogFromJson(json);



}
