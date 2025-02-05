import 'package:json_annotation/json_annotation.dart';

part 'inquiry_model.g.dart';

@JsonSerializable()
class InquiryModel {
  final String id;
  final String category;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? answer;
  final DateTime? answeredAt;

  InquiryModel({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.createdAt,
    this.answer,
    this.answeredAt,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) => _$InquiryModelFromJson(json);

  Map<String, dynamic> toJson() => _$InquiryModelToJson(this);
}