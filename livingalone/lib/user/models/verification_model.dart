import 'package:json_annotation/json_annotation.dart';

part 'verification_model.g.dart';

@JsonSerializable()
class EmailVerificationRequest {
  final String email;
  final String university;

  EmailVerificationRequest({
    required this.email,
    required this.university,
  });

  factory EmailVerificationRequest.fromJson(Map<String, dynamic> json) => _$EmailVerificationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$EmailVerificationRequestToJson(this);
}

@JsonSerializable()
class PhoneVerificationRequest {
  final String phoneNumber;
  final String carrier;

  PhoneVerificationRequest({
    required this.phoneNumber,
    required this.carrier,
  });

  factory PhoneVerificationRequest.fromJson(Map<String, dynamic> json) => _$PhoneVerificationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PhoneVerificationRequestToJson(this);
}

@JsonSerializable()
class VerificationResponse {
  final String message;
  final bool success;
  final String? verificationCode;

  VerificationResponse({
    required this.message,
    required this.success,
    this.verificationCode,
  });

  factory VerificationResponse.fromJson(Map<String, dynamic> json) => _$VerificationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VerificationResponseToJson(this);
}