import 'package:json_annotation/json_annotation.dart';

part 'rank.g.dart';

@JsonSerializable()
class Rank {
  final String id;
  final String name;
  final String imageAsset;
  final String primaryColor;
  final String secondaryColor;
  final int sortOrder;

  Rank({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.primaryColor,
    required this.secondaryColor,
    required this.sortOrder,
  });

  factory Rank.fromJson(Map<String, dynamic> json) => _$RankFromJson(json);
  Map<String, dynamic> toJson() => _$RankToJson(this);
}
