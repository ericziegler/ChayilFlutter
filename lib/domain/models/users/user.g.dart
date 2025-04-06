// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      deviceId: json['deviceId'] as String?,
      status: $enumDecode(_$UserStatusEnumMap, json['status']),
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'deviceId': instance.deviceId,
      'status': _$UserStatusEnumMap[instance.status]!,
      'role': _$UserRoleEnumMap[instance.role]!,
    };

const _$UserStatusEnumMap = {
  UserStatus.active: 'ACTIVE',
  UserStatus.inactive: 'INACTIVE',
};

const _$UserRoleEnumMap = {
  UserRole.student: 'STUDENT',
  UserRole.instructor: 'INSTRUCTOR',
  UserRole.school: 'SCHOOL',
  UserRole.admin: 'ADMIN',
};
