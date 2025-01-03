import 'package:json_annotation/json_annotation.dart';
import 'room_post_model.dart';

part 'ticket_post_model.g.dart';

@JsonSerializable()
class TicketPost {
  final String id;
  final String title;
  final String subTitle1;
  final String subTitle2;
  final String subTitle3;
  final String subTitle4;
  final int likes;
  final int comments;
  final int scraps;
  final DateTime createdAt;

  TicketPost({
    required this.id,
    required this.title,
    required this.subTitle1,
    required this.subTitle2,
    required this.subTitle3,
    required this.subTitle4,
    required this.likes,
    required this.comments,
    required this.scraps,
    required this.createdAt,
  });

  factory TicketPost.fromJson(Map<String, dynamic> json) => 
      _$TicketPostFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$TicketPostToJson(this);
} 