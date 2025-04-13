import 'package:json_annotation/json_annotation.dart';
import 'package:chayil/domain/models/techniques/technique.dart';

part 'rank.g.dart';

@JsonSerializable()
class Rank {
  final String id;
  final String name;
  final String imageAsset;
  final String primaryColor;
  final String secondaryColor;
  final int sortOrder;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Technique>? techniques;

  Rank({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.primaryColor,
    required this.secondaryColor,
    required this.sortOrder,
    this.techniques,
  });

  factory Rank.fromJson(Map<String, dynamic> json) => _$RankFromJson(json);
  Map<String, dynamic> toJson() => _$RankToJson(this);
}
