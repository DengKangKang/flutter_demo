import 'package:json_annotation/json_annotation.dart';

part 'RadioBean.g.dart';


@JsonSerializable()
class RadioBean extends Object {
  RadioBean(this.id, this.name);

  int id;
  String name;

  factory RadioBean.fromJson(Map<String, dynamic> json) =>
      _$RadioBeanFromJson(json);

  @override
  String toString() {
    return name;
  }
}