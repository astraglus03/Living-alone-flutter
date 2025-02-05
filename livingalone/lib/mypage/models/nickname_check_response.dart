import 'package:json_annotation/json_annotation.dart';

part 'nickname_check_response.g.dart';

@JsonSerializable()
class NicknameCheckResponse {
  final bool available;
  final String message;

  NicknameCheckResponse({
    required this.available,
    required this.message,
  });

  factory NicknameCheckResponse.fromJson(Map<String, dynamic> json) =>
      _$NicknameCheckResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NicknameCheckResponseToJson(this);
} 