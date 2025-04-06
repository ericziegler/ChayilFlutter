// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technique_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TechniqueList _$TechniqueListFromJson(Map<String, dynamic> json) =>
    TechniqueList(
      techniques: (json['techniques'] as List<dynamic>)
          .map((e) => Technique.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TechniqueListToJson(TechniqueList instance) =>
    <String, dynamic>{
      'techniques': instance.techniques,
    };
