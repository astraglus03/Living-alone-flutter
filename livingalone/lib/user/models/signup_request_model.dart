import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'signup_request_model.g.dart';

@JsonSerializable()
class SignUpRequest {
  final String? id;
  final String email;
  final String password;
  final String nickname;
  final String phoneNumber;
  final String university;
  @JsonKey(ignore: true) // JSON 직렬화에서 제외
  final File? profileImage;
  final bool termsAgreed;
  final bool privacyAgreed;
  final bool? alarmAgreed;

  SignUpRequest({
    required this.email,
    required this.password,
    required this.nickname,
    required this.phoneNumber,
    required this.university,
    required this.termsAgreed,
    required this.privacyAgreed,
    this.alarmAgreed,
    this.id,
    this.profileImage,
  });

  factory SignUpRequest.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);

  SignUpRequest copyWith(
      {String? id,
      String? email,
      String? password,
      String? nickname,
      String? phoneNumber,
      String? university,
      File? profileImage,
      bool? termsAgreed,
      bool? privacyAgreed,
      bool? alarmAgreed}) {
    return SignUpRequest(
      email: email ?? this.email,
      password: email ?? this.password,
      nickname: nickname ?? this.nickname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      university: university ?? this.university,
      termsAgreed: termsAgreed ?? this.termsAgreed,
      privacyAgreed: privacyAgreed ?? this.privacyAgreed,
      alarmAgreed: alarmAgreed ?? this.alarmAgreed,
    );
  }
}
