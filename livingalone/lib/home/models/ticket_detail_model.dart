import 'package:json_annotation/json_annotation.dart';
import 'package:livingalone/home/models/ticket_model.dart';

part 'ticket_detail_model.g.dart';

@JsonSerializable()
class TicketDetailModel extends TicketModel {
  final int handoverPrice;
  final List<String> additionalImages;
  final String authorProfileUrl;
  final String authorName;
  final String address;
  final String detailedAddress;
  final int? remainingNum;
  final int? remainingTime;
  final int? maintenanceFee;
  final String description;
  final String availableDate;
  final bool? immediateEnter;

  TicketDetailModel({
    required super.id,
    required super.postType,
    required super.title,
    required super.location,
    required super.ticketType,
    required super.createdAt,
    required super.isTransferred,
    required this.handoverPrice,
    required this.additionalImages,
    required this.authorProfileUrl,
    required this.authorName,
    required this.address,
    required this.detailedAddress,
    this.remainingNum,
    this.remainingTime,
    this.maintenanceFee,
    required this.description,
    required this.availableDate,
    this.immediateEnter,
  });

  factory TicketDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TicketDetailModelFromJson(json);
}
