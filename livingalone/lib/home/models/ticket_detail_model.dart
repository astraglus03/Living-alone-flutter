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
    super.isFavorite = false,
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
      
  @override
  Map<String, dynamic> toJson() => _$TicketDetailModelToJson(this);
  
  // 객체의 일부 필드만 업데이트하여 새 객체를 생성하는 메서드
  TicketDetailModel copyWith({
    String? id,
    String? postType,
    String? title,
    String? location,
    String? ticketType,
    DateTime? createdAt,
    bool? isTransferred,
    bool? isFavorite,
    int? handoverPrice,
    List<String>? additionalImages,
    String? authorProfileUrl,
    String? authorName,
    String? address,
    String? detailedAddress,
    int? remainingNum,
    int? remainingTime,
    int? maintenanceFee,
    String? description,
    String? availableDate,
    bool? immediateEnter,
  }) {
    return TicketDetailModel(
      id: id ?? this.id,
      postType: postType ?? this.postType,
      title: title ?? this.title,
      location: location ?? this.location,
      ticketType: ticketType ?? this.ticketType,
      createdAt: createdAt ?? this.createdAt,
      isTransferred: isTransferred ?? this.isTransferred,
      isFavorite: isFavorite ?? this.isFavorite,
      handoverPrice: handoverPrice ?? this.handoverPrice,
      additionalImages: additionalImages ?? this.additionalImages,
      authorProfileUrl: authorProfileUrl ?? this.authorProfileUrl,
      authorName: authorName ?? this.authorName,
      address: address ?? this.address,
      detailedAddress: detailedAddress ?? this.detailedAddress,
      remainingNum: remainingNum ?? this.remainingNum,
      remainingTime: remainingTime ?? this.remainingTime,
      maintenanceFee: maintenanceFee ?? this.maintenanceFee,
      description: description ?? this.description,
      availableDate: availableDate ?? this.availableDate,
      immediateEnter: immediateEnter ?? this.immediateEnter,
    );
  }
}
