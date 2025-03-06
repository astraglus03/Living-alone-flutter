// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequest _$SignUpRequestFromJson(Map<String, dynamic> json) =>
    SignUpRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      nickname: json['nickname'] as String,
      phoneNumber: json['phoneNumber'] as String,
      university: json['university'] as String,
      termsAgreed: json['termsAgreed'] as bool,
      privacyAgreed: json['privacyAgreed'] as bool,
      alarmAgreed: json['alarmAgreed'] as bool?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$SignUpRequestToJson(SignUpRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'password': instance.password,
      'nickname': instance.nickname,
      'phoneNumber': instance.phoneNumber,
      'university': instance.university,
      'termsAgreed': instance.termsAgreed,
      'privacyAgreed': instance.privacyAgreed,
      'alarmAgreed': instance.alarmAgreed,
    };
