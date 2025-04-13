import 'package:json_annotation/json_annotation.dart';
import 'package:chayil/domain/models/ranks/rank.dart';
import 'package:chayil/domain/models/techniques/technique.dart';

part 'techniques_by_rank.g.dart';

@JsonSerializable()
class TechniquesByRank {
  List<Rank>? ranks;

  TechniquesByRank({required this.ranks});

  void sortTechniquesAlphabetically() {
    for (var rank in ranks ?? []) {
      rank.techniques
          ?.sort((Technique a, Technique b) => a.name.compareTo(b.name));
    }
  }

  // From JSON
  factory TechniquesByRank.fromJson(Map<String, dynamic> json) =>
      _$TechniquesByRankFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$TechniquesByRankToJson(this);
}
