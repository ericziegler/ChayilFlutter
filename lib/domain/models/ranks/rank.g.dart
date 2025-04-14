// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rank _$RankFromJson(Map<String, dynamic> json) => Rank(
      id: json['id'] as String,
      name: json['name'] as String,
      imageAsset: json['imageAsset'] as String,
      primaryColor: json['primaryColor'] as String,
      secondaryColor: json['secondaryColor'] as String,
      stripeColor: json['stripeColor'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
    );

Map<String, dynamic> _$RankToJson(Rank instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageAsset': instance.imageAsset,
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
      'stripeColor': instance.stripeColor,
      'sortOrder': instance.sortOrder,
    };
