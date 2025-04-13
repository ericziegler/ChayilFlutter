// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'techniques_by_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TechniquesByCategory _$TechniquesByCategoryFromJson(
        Map<String, dynamic> json) =>
    TechniquesByCategory(
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TechniquesByCategoryToJson(
        TechniquesByCategory instance) =>
    <String, dynamic>{
      'categories': instance.categories,
    };
