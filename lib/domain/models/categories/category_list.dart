import 'package:json_annotation/json_annotation.dart';
import 'category.dart';

part 'category_list.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryList {
  final List<Category> items;

  CategoryList({required this.items});

  factory CategoryList.fromJson(Map<String, dynamic> json) =>
      _$CategoryListFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryListToJson(this);
}
