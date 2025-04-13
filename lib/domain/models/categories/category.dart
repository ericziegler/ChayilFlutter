import 'package:json_annotation/json_annotation.dart';
import 'package:chayil/domain/models/techniques/technique.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final String id;
  final String name;
  final int sortOrder;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Technique>? techniques;

  Category({
    required this.id,
    required this.name,
    required this.sortOrder,
    this.techniques,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
