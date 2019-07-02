import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'home_page.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class HomeData extends Object {
  HomeData(this.list);

  List<HomeInfo> list;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory HomeData.fromJson(Map<String, dynamic> json) =>
      _$HomeDataFromJson(json);
}

@JsonSerializable()
class HomeInfo extends Object {
  HomeInfo(this.p_customer, this.c_customer, this.p_clue, this.c_clue);

  final int p_customer;
  final int c_customer;
  final int p_clue;
  final int c_clue;

  factory HomeInfo.fromJson(Map<String, dynamic> json) =>
      _$HomeInfoFromJson(json);
}
