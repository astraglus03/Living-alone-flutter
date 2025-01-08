import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/home/models/room_detail_model.dart';

const unchanged = Object();

final editRoomPostProvider = StateNotifierProvider<EditRoomPostNotifier, EditRoomPostState>((ref) {
  return EditRoomPostNotifier();
});

class EditRoomPostState {
  final String? id;
  final String? postType;
  final String? thumbnailUrl;
  final String? title;
  final bool? isTransferred;
  final String? location;
  final String? buildingType;
  final String? propertyType;
  final String? rentType;
  final int? deposit;
  final int? monthlyRent;
  final int? maintenanceFee;
  final List<String>? options;
  final List<String>? facilities;
  final List<String>? conditions;
  final int? likes;
  final int? comments;
  final int? chatRooms;
  final DateTime? createdAt;
  final List<String>? additionalImages;
  final String? authorProfileUrl;
  final String? authorName;
  final String? address;
  final String? detailedAddress;
  final String? description;
  final String? area;
  final String? currentFloor;
  final String? totalFloor;
  final String? availableDate;
  final bool? immediateEnter;

  EditRoomPostState({
    this.id,
    this.postType,
    this.thumbnailUrl,
    this.title,
    this.isTransferred,
    this.location,
    this.buildingType,
    this.propertyType,
    this.rentType,
    this.deposit,
    this.monthlyRent,
    this.maintenanceFee,
    this.options,
    this.facilities,
    this.conditions,
    this.likes,
    this.comments,
    this.chatRooms,
    this.createdAt,
    this.additionalImages,
    this.authorProfileUrl,
    this.authorName,
    this.address,
    this.detailedAddress,
    this.description,
    this.area,
    this.currentFloor,
    this.totalFloor,
    this.availableDate,
    this.immediateEnter,
  });

  EditRoomPostState copyWith({
    Object? deposit = unchanged,
    Object? monthlyRent = unchanged,
    Object? maintenanceFee = unchanged,

    String? id,
    String? postType,
    String? thumbnailUrl,
    String? title,
    bool? isTransferred,
    String? location,
    String? buildingType,
    String? propertyType,
    String? rentType,
    // int? deposit,
    // int? monthlyRent,
    // int? maintenanceFee,
    String? area,
    String? currentFloor,
    String? totalFloor,
    List<String>? options,
    List<String>? facilities,
    List<String>? conditions,
    int? likes,
    int? comments,
    int? chatRooms,
    DateTime? createdAt,
    List<String>? additionalImages,
    String? authorName,
    String? authorProfileUrl,
    String? authorProfile,
    String? address,
    String? detailAddress,
    String? description,
    String? availableDate,
    bool? immediateEnter,
  }) {
    return EditRoomPostState(
      id: id ?? this.id,
      postType: postType ?? this.postType,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      title: title ?? this.title,
      isTransferred: isTransferred ?? this.isTransferred,
      location: location ?? this.location,
      buildingType: buildingType ?? this.buildingType,
      propertyType: propertyType ?? this.propertyType,
      rentType: rentType ?? this.rentType,
      deposit: deposit == unchanged ? this.deposit : deposit as int?,
      monthlyRent: monthlyRent == unchanged ? this.monthlyRent : monthlyRent as int?,
      maintenanceFee: maintenanceFee == unchanged ? this.maintenanceFee : maintenanceFee as int?,
      currentFloor: currentFloor ?? this.currentFloor,
      totalFloor: totalFloor ?? this.totalFloor,
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
      detailedAddress: detailAddress ?? this.detailedAddress,
      description: description ?? this.description,
      area: area ?? this.area,
      availableDate: availableDate ?? this.availableDate,
      immediateEnter: immediateEnter ?? this.immediateEnter,
    );
  }

  factory EditRoomPostState.fromOriginal(RoomDetailModel original) {
    return EditRoomPostState(
      id: original.id,
      postType: original.postType,
      thumbnailUrl: original.thumbnailUrl,
      title: original.title,
      isTransferred: original.isTransferred,
      location: original.location,
      buildingType: original.buildingType,
      propertyType: original.propertyType,
      rentType: original.rentType,
      deposit: original.deposit,
      monthlyRent: original.monthlyRent!,
      maintenanceFee: original.maintenance,
      options: original.options ?? [],
      facilities: original.facilities ?? [],
      conditions: original.conditions ?? [],
      likes: original.likes,
      comments: original.comments,
      chatRooms: original.chatRooms,
      createdAt: original.createdAt,
      additionalImages: original.additionalImages,
      authorProfileUrl: original.authorProfileUrl,
      authorName: original.authorName,
      address: original.address,
      detailedAddress: original.detailedAddress,
      description: original.description,
      area: original.area,
      currentFloor: original.currentFloor,
      totalFloor: original.totalFloor,
      availableDate: original.availableDate,
      immediateEnter: original.immediateEnter,
    );
  }

  DateTime? getStartDate() {
    if (availableDate == null) return null;

    // 단기 양도인 경우 "2025년 5월 20일 ~ 2025년 6월 20일" 형식
    if (rentType == "단기양도") {
      final dates = availableDate!.split(' ~ ');
      return _parseDate(dates[0]);
    }

    // 월세, 전세인 경우 "2025년 5월 20일" 형식
    return _parseDate(availableDate!);
  }

  DateTime? getEndDate() {
    if (availableDate == null || rentType != "단기양도") return null;

    final dates = availableDate!.split(' ~ ');
    if (dates.length != 2) return null;

    return _parseDate(dates[1]);
  }

  // 날짜 문자열을 DateTime으로 파싱
  static DateTime? _parseDate(String date) {
    final regex = RegExp(r'(\d{4})년\s+(\d{1,2})월\s+(\d{1,2})일');
    final match = regex.firstMatch(date);

    if (match == null) return null;

    return DateTime(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
    );
  }
}

class EditRoomPostNotifier extends StateNotifier<EditRoomPostState> {
  EditRoomPostNotifier() : super(EditRoomPostState(
    id: '1',
    postType: '자취방',
    thumbnailUrl: '/Users/astraglus/Library/Developer/CoreSimulator/Devices/82FA348D-F0DB-42BE-BAE7-2C83EE432433/data/Containers/Data/Application/0BBA6B6F-9C55-478E-B409-2B26E2A8C078/tmp/image_picker_EDA014CA-35DA-4D90-A30F-572E187BA1F6-1155-0000055850B04BAF.jpg',
    title: '모양아파트 101동',
    isTransferred: false,
    location: '안서동',
    buildingType: '오피스텔',
    propertyType: '원룸(오픈형)',
    rentType: '월세',
    deposit: 500,
    monthlyRent: 50,
    maintenanceFee: 5,
    options: ['에어컨', '세탁기'],
    facilities: ['주차장', 'CCTV'],
    conditions: ['2인 거주 가능', '여성 전용'],
    likes: 10,
    comments: 5,
    chatRooms: 2,
    createdAt: DateTime.now(),
    additionalImages: [
      '/Users/astraglus/Library/Developer/CoreSimulator/Devices/82FA348D-F0DB-42BE-BAE7-2C83EE432433/data/Containers/Data/Application/0BBA6B6F-9C55-478E-B409-2B26E2A8C078/tmp/image_picker_1E69B777-3AF0-44E7-9BD5-64F089140B56-1155-000006390BAF464D.jpg',
      '/Users/astraglus/Library/Developer/CoreSimulator/Devices/82FA348D-F0DB-42BE-BAE7-2C83EE432433/data/Containers/Data/Application/0BBA6B6F-9C55-478E-B409-2B26E2A8C078/tmp/image_picker_34437C57-0B62-458A-A6B4-E6F1201D33E4-1155-0000063966BADB42.jpg',
      '/Users/astraglus/Library/Developer/CoreSimulator/Devices/82FA348D-F0DB-42BE-BAE7-2C83EE432433/data/Containers/Data/Application/0BBA6B6F-9C55-478E-B409-2B26E2A8C078/tmp/image_picker_999DA050-84B3-4D4B-9D83-D83A69BFB3B1-1155-0000063967016F5D.jpg'
    ],
    authorProfileUrl: 'https://example.com/profile.jpg',
    authorName: 'John Doe',
    address: '충남 천안시 동남구 상명대길 23-6',
    detailedAddress: 'B동 307호',
    description: '자취방 양도 게시글 수정하는 더미데이터 입니다.',
    area: '33',
    currentFloor: '7',
    totalFloor: '15',
    availableDate: '2025년 5월 20일',
    immediateEnter: false,
  ));

  void initializeWithOriginal(RoomDetailModel original) {
    state = EditRoomPostState.fromOriginal(original);
  }

  void updateBuildingType(String type) {
    state = state.copyWith(buildingType: type);
  }

  void updatePropertyType(String type) {
    state = state.copyWith(propertyType: type);
  }

  void updateRentType(String type) {
    state = state.copyWith(rentType: type);
  }

  void updatePriceInfo({int? deposit, int? monthlyRent, int? maintenanceFee}) {
    state = state.copyWith(
      deposit: deposit,
      monthlyRent: monthlyRent,
      maintenanceFee: maintenanceFee,
    );
  }

  void updateRoomInfo({String? area, String? currentFloor, String? totalFloor}) {
    state = state.copyWith(
      area: area,
      currentFloor: currentFloor,
      totalFloor: totalFloor,
    );
  }

  void updateOptions(List<String> options) {
    state = state.copyWith(options: options);
  }

  void updateFacilities(List<String> facilities) {
    state = state.copyWith(facilities: facilities);
  }

  void updateConditions(List<String> conditions) {
    state = state.copyWith(conditions: conditions);
  }

  void updateDate({DateTime? startDate, DateTime? endDate, bool? immediateIn}) {
    final formattedDate = _formatDate(startDate, endDate);

    state = state.copyWith(
      availableDate: formattedDate,
      immediateEnter: immediateIn,
    );
  }

  String? _formatDate(DateTime? startDate, DateTime? endDate) {
    if (startDate == null) return null;

    final dateFormat = (d) => '${d.year}년 ${d.month.toString().padLeft(2, '0')}월 ${d.day.toString().padLeft(2, '0')}일';

    if (endDate != null && state.rentType == "단기양도") {
      // 단기양도의 경우
      return '${dateFormat(startDate)} ~ ${dateFormat(endDate)}';
    } else {
      // 일반 입주가능일
      return dateFormat(startDate);
    }
  }

  void addImages(List<File> newImages) {
    final currentImages = state.additionalImages ?? [];
    final newImagePaths = newImages.map((file) => file.path).toList();

    state = state.copyWith(
      additionalImages: [...currentImages, ...newImagePaths],
    );
  }

  void removeImage(int index) {
    if (state.additionalImages != null && index < state.additionalImages!.length) {
      final updatedImages = List<String>.from(state.additionalImages!);
      updatedImages.removeAt(index);

      state = state.copyWith(
        additionalImages: updatedImages,
      );
    }
  }

  void reorderImages(int oldIndex, int newIndex) {
    if (state.additionalImages != null) {
      final updatedImages = List<String>.from(state.additionalImages!);
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final String item = updatedImages.removeAt(oldIndex);
      updatedImages.insert(newIndex, item);

      state = state.copyWith(
        additionalImages: updatedImages,
      );
    }
  }

  void updateTitleAndContent({String? title, String? description}) {
    state = state.copyWith(
      title: title,
      description: description,
    );
  }

  void resetAll() {
    state = EditRoomPostState();
  }
}
