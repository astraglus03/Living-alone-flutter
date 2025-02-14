// lib/user/models/user_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;

  UserModelError({
    required this.message,
  });
}

class UserModelLoading extends UserModelBase {}

@JsonSerializable()
class UserModel extends UserModelBase {
  final String? id;
  final String email;
  final String? nickname;
  final String? phoneNumber;
  final String? profileImage;
  final bool? isVerified;
  final String? university;

  UserModel({
    this.id,
    required this.email,
    this.nickname,
    this.phoneNumber,
    this.profileImage,
    this.isVerified,
    this.university,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? nickname,
    String? phoneNumber,
    String? profileImage,
    bool? isVerified,
    String? university,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
      university: university ?? this.university,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
