import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonEnum(alwaysCreate: true)
enum UserStatus {
  @JsonValue('ACTIVE')
  active,

  @JsonValue('INACTIVE')
  inactive,
}

@JsonEnum(alwaysCreate: true)
enum UserRole {
  @JsonValue('STUDENT')
  student,

  @JsonValue('INSTRUCTOR')
  instructor,

  @JsonValue('SCHOOL')
  school,

  @JsonValue('ADMIN')
  admin,

  @JsonValue('DEMO')
  demo,
}

@JsonSerializable()
class User {
  final String email;
  final String? deviceId;
  final UserStatus status;
  final UserRole role;

  User({
    required this.email,
    this.deviceId,
    required this.status,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
