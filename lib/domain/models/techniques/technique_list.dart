import 'package:json_annotation/json_annotation.dart';
import 'technique.dart';

part 'technique_list.g.dart';

@JsonSerializable()
class TechniqueList {
  final List<Technique> techniques;

  TechniqueList({required this.techniques});

  factory TechniqueList.fromJson(Map<String, dynamic> json) =>
      _$TechniqueListFromJson(json);

  Map<String, dynamic> toJson() => _$TechniqueListToJson(this);
}
