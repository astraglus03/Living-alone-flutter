import 'package:json_annotation/json_annotation.dart';
import 'package:livingalone/home/models/ticket_model.dart';

part 'ticket_detail_model.g.dart';

@JsonSerializable()
class TicketDetailModel extends TicketModel {
  final List<String> additionalImages;
  final String authorProfileUrl;
  final String authorProfileName;
  final String address;
  final String? remainingNum;
  final String? remainingTime;
  final String? maintenanceFee;
  final String ticketIntroText;
  final String isPossibleUse;

  TicketDetailModel({
    required super.id,
    required super.postType,
    required super.title,
    required super.location,
    required super.ticketType,
    required super.createdAt,
    required super.isTransferred,
    required this.additionalImages,
    required this.authorProfileUrl,
    required this.authorProfileName,
    required this.address,
    required this.remainingNum,
    required this.remainingTime,
    required this.maintenanceFee,
    required this.ticketIntroText,
    required this.isPossibleUse,
  });

  factory TicketDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TicketDetailModelFromJson(json);
}
