// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'techniques_by_rank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TechniquesByRank _$TechniquesByRankFromJson(Map<String, dynamic> json) =>
    TechniquesByRank(
      ranks: (json['ranks'] as List<dynamic>?)
          ?.map((e) => Rank.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TechniquesByRankToJson(TechniquesByRank instance) =>
    <String, dynamic>{
      'ranks': instance.ranks,
    };
