// lib/mypage/models/notice_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'notice_model.g.dart';

@JsonSerializable()
class NoticeModel {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  NoticeModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) => _$NoticeModelFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeModelToJson(this);
}