import 'package:json_annotation/json_annotation.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/common/enum/room_enums.dart';

part 'room_model.g.dart';

@JsonSerializable()
class RoomModel {
  final String id;                        // 게시물 고유 식별자
  final PostType postType;                // 방인지 이용권인지(페이지 통합으로 인해 필요함)
  final String thumbnailUrl;              // 게시물 대표 이미지 URL (첫 번째 이미지)
  final String title;                     // 게시물 제목 (예: "안서동보아파트 101동")
  final bool isTransferred;               // 양도 완료 여부 (true: 양도완료, false: 양도중)
  final String location;                  // 지역명 (예: 안서동, 신부동, 두정동)
  final String buildingType;              // 건물 유형 (아파트, 빌라, 주택, 오피스텔)
  final String propertyType;              // 매물 종류 (원룸(오픈형), 원룸(분리형), 투룸, 쓰리룸 이상)
  final RentType rentType;                // 임대 방식 (월세, 전세, 단기양도)
  final int deposit;                      // 보증금 (만원 단위)
  final int maintenance;                  // 관리비 (만원 단위)
  final int? monthlyRent;                 // 월세 (만원 단위, 전세, 단기양도의 경우 null)
  final List<String>? options;            // 옵션 목록 (에어컨, 세탁기, 냉장고 등)
  final List<String>? facilities;         // 시설 목록 (엘리베이터, 주차장, CCTV, 복층, 옥탑)
  final List<String>? conditions;         // 조건 목록 (2인 거주 가능, 여성 전용, 반려동물 가능)
  final int likes;                        // 찜 횟수
  final int comments;                     // 전체 댓글 수 (대댓글 포함)
  final int chatRooms;                    // 활성화된 채팅방 수
  final DateTime createdAt;               // 게시물 작성 시간

  RoomModel({
    required this.id,
    required this.postType,
    required this.thumbnailUrl,
    required this.title,
    required this.isTransferred,
    required this.location,
    required this.buildingType,
    required this.propertyType,
    required this.rentType,
    required this.deposit,
    this.monthlyRent,
    this.options,
    this.facilities,
    this.conditions,
    required this.maintenance,
    required this.likes,
    required this.comments,
    required this.chatRooms,
    required this.createdAt,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoomModelToJson(this);
} 