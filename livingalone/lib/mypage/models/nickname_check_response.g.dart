// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nickname_check_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NicknameCheckResponse _$NicknameCheckResponseFromJson(
        Map<String, dynamic> json) =>
    NicknameCheckResponse(
      available: json['available'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$NicknameCheckResponseToJson(
        NicknameCheckResponse instance) =>
    <String, dynamic>{
      'available': instance.available,
      'message': instance.message,
    };
