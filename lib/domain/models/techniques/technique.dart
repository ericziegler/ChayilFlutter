import 'package:json_annotation/json_annotation.dart';

part 'technique.g.dart';

@JsonSerializable()
class Technique {
  final String id;
  final String name;
  final String details;
  final String advancedNotes;
  final String rankId;
  final String categoryId;
  final int sortOrder;

  Technique({
    required this.id,
    required this.name,
    required this.details,
    required this.advancedNotes,
    required this.rankId,
    required this.categoryId,
    required this.sortOrder,
  });

  String? formattedDetails() {
    const find = '\\n';
    const replaceWith = '\n';
    return details.replaceAll(find, replaceWith);
  }

  String? formattedAdvancedNotes() {
    const find = '\\n';
    const replaceWith = '\n';
    return advancedNotes.replaceAll(find, replaceWith);
  }

  factory Technique.fromJson(Map<String, dynamic> json) =>
      _$TechniqueFromJson(json);

  Map<String, dynamic> toJson() => _$TechniqueToJson(this);
}
