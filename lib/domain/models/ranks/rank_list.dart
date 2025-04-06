// rank_list.dart
import 'package:json_annotation/json_annotation.dart';
import 'rank.dart';

part 'rank_list.g.dart';

@JsonSerializable()
class RankList {
  final List<Rank> ranks;

  RankList({required this.ranks});

  factory RankList.fromJson(Map<String, dynamic> json) =>
      _$RankListFromJson(json);
  Map<String, dynamic> toJson() => _$RankListToJson(this);
}
