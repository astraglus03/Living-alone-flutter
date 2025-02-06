import 'package:json_annotation/json_annotation.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/common/enum/room_enums.dart';

part 'handover_history_model.g.dart';

@JsonSerializable()
class HandoverHistoryModel {
  final String itemId;
  final String title;
  final String location;
  final String? thumbnailUrl;
  @JsonKey(unknownEnumValue: PostType.room)
  final PostType type;
  final DateTime createdAt;
  final int viewCount;
  final int commentCount;
  final int chatCount;
  final bool isTransferred;
  final bool isHidden;
  
  // Room specific fields
  final String? buildingType;
  final String? propertyType;
  final String? rentType;
  final int? deposit;
  final int? monthlyRent;

  // Ticket specific fields
  final String? ticketType;
  final int? remainingDays;
  final int? price;

  HandoverHistoryModel({
    required this.itemId,
    required this.title,
    required this.location,
    this.thumbnailUrl,
    required this.type,
    required this.createdAt,
    required this.viewCount,
    required this.commentCount,
    required this.chatCount,
    required this.isTransferred,
    this.isHidden = false,
    this.buildingType,
    this.propertyType,
    this.rentType,
    this.deposit,
    this.monthlyRent,
    this.ticketType,
    this.remainingDays,
    this.price,
  });

  factory HandoverHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HandoverHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$HandoverHistoryModelToJson(this);
} 