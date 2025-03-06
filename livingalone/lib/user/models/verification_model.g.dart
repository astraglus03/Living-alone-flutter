// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailVerificationRequest _$EmailVerificationRequestFromJson(
        Map<String, dynamic> json) =>
    EmailVerificationRequest(
      email: json['email'] as String,
      university: json['university'] as String,
    );

Map<String, dynamic> _$EmailVerificationRequestToJson(
        EmailVerificationRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'university': instance.university,
    };

PhoneVerificationRequest _$PhoneVerificationRequestFromJson(
        Map<String, dynamic> json) =>
    PhoneVerificationRequest(
      phoneNumber: json['phoneNumber'] as String,
      carrier: json['carrier'] as String,
    );

Map<String, dynamic> _$PhoneVerificationRequestToJson(
        PhoneVerificationRequest instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'carrier': instance.carrier,
    };

VerificationResponse _$VerificationResponseFromJson(
        Map<String, dynamic> json) =>
    VerificationResponse(
      message: json['message'] as String,
      success: json['success'] as bool,
      verificationCode: json['verificationCode'] as String?,
    );

Map<String, dynamic> _$VerificationResponseToJson(
        VerificationResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'verificationCode': instance.verificationCode,
    };
