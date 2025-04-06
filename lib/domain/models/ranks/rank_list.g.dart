// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rank_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RankList _$RankListFromJson(Map<String, dynamic> json) => RankList(
      ranks: (json['ranks'] as List<dynamic>)
          .map((e) => Rank.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RankListToJson(RankList instance) => <String, dynamic>{
      'ranks': instance.ranks,
    };
