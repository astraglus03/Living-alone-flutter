import 'package:json_annotation/json_annotation.dart';
part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  final String id;
  final String email;
  final String nickname;
  final String? profileImage;
  final String phoneNumber;
  final String language;
  final bool pushNotificationEnabled;
  final bool chatNotificationEnabled;
  final bool neighborNotificationEnabled;
  final bool handoverNotificationEnabled;
  final bool communityNotificationEnabled;
  final bool noticeNotificationEnabled;
  final String? address;

  UserProfileModel({
    required this.id,
    required this.email,
    required this.nickname,
    this.profileImage,
    required this.phoneNumber,
    required this.language,
    this.pushNotificationEnabled = true,
    this.chatNotificationEnabled = true,
    this.neighborNotificationEnabled = true,
    this.handoverNotificationEnabled = true,
    this.communityNotificationEnabled = true,
    this.noticeNotificationEnabled = true,
    this.address,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  UserProfileModel copyWith({
    String? id,
    String? email,
    String? nickname,
    String? profileImage,
    String? phoneNumber,
    String? language,
    bool? pushNotificationEnabled,
    bool? chatNotificationEnabled,
    bool? neighborNotificationEnabled,
    bool? handoverNotificationEnabled,
    bool? communityNotificationEnabled,
    bool? noticeNotificationEnabled,
    String? address,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      language: language ?? this.language,
      pushNotificationEnabled: pushNotificationEnabled ?? this.pushNotificationEnabled,
      chatNotificationEnabled: chatNotificationEnabled ?? this.chatNotificationEnabled,
      neighborNotificationEnabled: neighborNotificationEnabled ?? this.neighborNotificationEnabled,
      handoverNotificationEnabled: handoverNotificationEnabled ?? this.handoverNotificationEnabled,
      communityNotificationEnabled: communityNotificationEnabled ?? this.communityNotificationEnabled,
      noticeNotificationEnabled: noticeNotificationEnabled ?? this.noticeNotificationEnabled,
      address: address ?? this.address,
    );
  }
}