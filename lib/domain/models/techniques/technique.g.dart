// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technique.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Technique _$TechniqueFromJson(Map<String, dynamic> json) => Technique(
      id: json['id'] as String,
      name: json['name'] as String,
      details: json['details'] as String,
      advancedNotes: json['advancedNotes'] as String,
      rankId: json['rankId'] as String,
      categoryId: json['categoryId'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
    );

Map<String, dynamic> _$TechniqueToJson(Technique instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'details': instance.details,
      'advancedNotes': instance.advancedNotes,
      'rankId': instance.rankId,
      'categoryId': instance.categoryId,
      'sortOrder': instance.sortOrder,
    };
