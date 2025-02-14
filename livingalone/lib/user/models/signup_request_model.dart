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
  final String? profileImage;

  SignUpRequest({
    required this.email,
    required this.password,
    required this.nickname,
    required this.phoneNumber,
    required this.university,
    this.id,
    this.profileImage,
  });

  factory SignUpRequest.fromJson(Map<String, dynamic> json) => _$SignUpRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);
}