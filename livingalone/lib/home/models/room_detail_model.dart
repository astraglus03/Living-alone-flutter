import 'package:json_annotation/json_annotation.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/home/models/comment_model.dart';
import 'package:livingalone/home/models/room_model.dart';

part 'room_detail_model.g.dart';

@JsonSerializable()
class RoomDetailModel extends RoomModel {
  final List<String> additionalImages;  // 추가 이미지 URL 목록 (최대 9개)
  final String authorProfileUrl;        // 게시자 프로필 이미지 URL
  final String authorName;              // 게시자 닉네임
  final String address;                 // 일반 주소( 천안시 동남구 안서동 304-1)
  final String detailedAddress;         // 상세 주소 (예: "101동 304호")
  final String description;             // 방 소개글
  final String area;                    // 면적 (예: "33.06m²")
  final String currentFloor;            // 현재 층수 (예: "7층")
  final String totalFloor;              // 전체 층수
  final String availableDate;         // 입주 가능일
  final bool immediateEnter;            // 즉시 입주 가능 여부
  final List<CommentModel> commentList; // 댓글 목록 (대댓글 포함)


  RoomDetailModel({
    required super.id,                   // 게시물 고유 식별자
    required super.thumbnailUrl,         // 게시물 대표 이미지 URL (첫 번째 이미지)
    required super.postType,
    required super.title,                // 게시물 제목 (예: "안서동보아파트 101동")
    required super.isTransferred,        // 양도 완료 여부 (true: 양도완료, false: 양도중)
    required super.location,             // 지역명 (예: 안서동, 신부동, 두정동)
    required super.buildingType,         // 건물 유형 (아파트, 빌라, 주택, 오피스텔)
    required super.propertyType,         // 매물 종류 (원룸(오픈형), 원룸(분리형), 투룸, 쓰리룸 이상)
    required super.rentType,             // 임대 방식 (월세, 전세, 단기양도)
    required super.deposit,              // 보증금 (만원 단위)
    required super.maintenance,          // 관리비 (만원 단위)
    super.monthlyRent,                   // 월세 (만원 단위, 전세의 경우 null)
    super.options,                       // 옵션 목록 (에어컨, 세탁기, 냉장고 등)
    super.facilities,                    // 시설 목록 (엘리베이터, 주차장, CCTV, 복층, 옥탑)
    super.conditions,                    // 조건 목록 (2인 거주 가능, 여성 전용, 반려동물 가능)
    super.isFavorite,
    required super.likes,                // 찜 횟수
    required super.comments,             // 전체 댓글 수 (대댓글 포함)
    required super.chatRooms,            // 활성화된 채팅방 수
    required super.createdAt,            // 게시물 작성 시간
    required this.additionalImages,
    required this.authorProfileUrl,
    required this.authorName,
    required this.address,
    required this.detailedAddress,
    required this.description,
    required this.area,
    required this.currentFloor,
    required this.totalFloor,
    required this.availableDate,
    required this.immediateEnter,
    required this.commentList,

  });

  factory RoomDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RoomDetailModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RoomDetailModelToJson(this);
  
  // 객체의 일부 필드만 업데이트하여 새 객체를 생성하는 메서드
  @override
  RoomDetailModel copyWith({
    String? id,
    String? postType,
    String? thumbnailUrl,
    String? title,
    bool? isTransferred,
    String? location,
    String? buildingType,
    String? propertyType,
    String? rentType,
    int? deposit,
    int? maintenance,
    int? monthlyRent,
    List<String>? options,
    List<String>? facilities,
    List<String>? conditions,
    int? likes,
    int? comments,
    int? chatRooms,
    DateTime? createdAt,
    List<String>? additionalImages,
    String? authorProfileUrl,
    String? authorName,
    String? address,
    String? detailedAddress,
    String? description,
    String? area,
    String? currentFloor,
    String? totalFloor,
    String? availableDate,
    bool? immediateEnter,
    List<CommentModel>? commentList,
    bool? isFavorite,
  }) {
    return RoomDetailModel(
      id: id ?? this.id,
      postType: postType ?? this.postType,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      title: title ?? this.title,
      isTransferred: isTransferred ?? this.isTransferred,
      location: location ?? this.location,
      buildingType: buildingType ?? this.buildingType,
      propertyType: propertyType ?? this.propertyType,
      rentType: rentType ?? this.rentType,
      deposit: deposit ?? this.deposit,
      maintenance: maintenance ?? this.maintenance,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      options: options ?? this.options,
      facilities: facilities ?? this.facilities,
      conditions: conditions ?? this.conditions,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      chatRooms: chatRooms ?? this.chatRooms,
      createdAt: createdAt ?? this.createdAt,
      additionalImages: additionalImages ?? this.additionalImages,
      authorProfileUrl: authorProfileUrl ?? this.authorProfileUrl,
      authorName: authorName ?? this.authorName,
      address: address ?? this.address,
      detailedAddress: detailedAddress ?? this.detailedAddress,
      description: description ?? this.description,
      area: area ?? this.area,
      currentFloor: currentFloor ?? this.currentFloor,
      totalFloor: totalFloor ?? this.totalFloor,
      availableDate: availableDate ?? this.availableDate,
      immediateEnter: immediateEnter ?? this.immediateEnter,
      commentList: commentList ?? this.commentList,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
} 