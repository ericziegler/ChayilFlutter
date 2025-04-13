import 'package:json_annotation/json_annotation.dart';
import 'package:chayil/domain/models/categories/category.dart';
import 'package:chayil/domain/models/techniques/technique.dart';

part 'techniques_by_category.g.dart';

@JsonSerializable()
class TechniquesByCategory {
  List<Category>? categories;

  TechniquesByCategory({required this.categories});

  void sortTechniquesAlphabetically() {
    for (var category in categories ?? []) {
      category.techniques
          ?.sort((Technique a, Technique b) => a.name.compareTo(b.name));
    }
  }

  // From JSON
  factory TechniquesByCategory.fromJson(Map<String, dynamic> json) =>
      _$TechniquesByCategoryFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$TechniquesByCategoryToJson(this);
}
