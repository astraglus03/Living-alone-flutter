// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      profileImage: json['profileImage'] as String?,
      phoneNumber: json['phoneNumber'] as String,
      language: json['language'] as String,
      pushNotificationEnabled: json['pushNotificationEnabled'] as bool? ?? true,
      chatNotificationEnabled: json['chatNotificationEnabled'] as bool? ?? true,
      neighborNotificationEnabled:
          json['neighborNotificationEnabled'] as bool? ?? true,
      handoverNotificationEnabled:
          json['handoverNotificationEnabled'] as bool? ?? true,
      communityNotificationEnabled:
          json['communityNotificationEnabled'] as bool? ?? true,
      noticeNotificationEnabled:
          json['noticeNotificationEnabled'] as bool? ?? true,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nickname': instance.nickname,
      'profileImage': instance.profileImage,
      'phoneNumber': instance.phoneNumber,
      'language': instance.language,
      'pushNotificationEnabled': instance.pushNotificationEnabled,
      'chatNotificationEnabled': instance.chatNotificationEnabled,
      'neighborNotificationEnabled': instance.neighborNotificationEnabled,
      'handoverNotificationEnabled': instance.handoverNotificationEnabled,
      'communityNotificationEnabled': instance.communityNotificationEnabled,
      'noticeNotificationEnabled': instance.noticeNotificationEnabled,
      'address': instance.address,
    };
