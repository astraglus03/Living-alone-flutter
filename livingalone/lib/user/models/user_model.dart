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
  final String nickname;
  final String phoneNumber;
  final String? profileImage;
  final bool isVerified;
  final String university;
  final bool serviceAlarm;
  final String? address;
  final String? language;

  UserModel({
    this.id,
    required this.email,
    required this.nickname,
    required this.phoneNumber,
    this.profileImage,
    required this.isVerified,
    required this.university,
    required this.serviceAlarm,
    this.address,
    this.language
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? nickname,
    String? phoneNumber,
    String? profileImage,
    bool? isVerified,
    String? university,
    bool? serviceAlarm,
    String? address,
    String? language
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
      university: university ?? this.university,
      serviceAlarm: serviceAlarm ?? this.serviceAlarm,
      address: address ?? this.address,
      language: language ?? this.language,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
