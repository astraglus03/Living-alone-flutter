import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/home/models/ticket_detail_model.dart';

const unchanged = Object();

final editTicketPostProvider =
StateNotifierProvider<EditTicketPostNotifier, EditTicketPostState>((ref) {
  return EditTicketPostNotifier();
});

class EditTicketPostState {
  final String? id;
  final String? postType;
  final String? title;
  final String? location;
  final String? ticketType;
  final int? handoverPrice;
  final DateTime? createdAt;
  final bool? isTransferred;
  final List<String>? additionalImages;
  final String? authorProfileUrl;
  final String? authorName;
  final String? address;
  final String? detailedAddress;
  final int? remainingNum;
  final int? remainingTime;
  final int? maintenanceFee;
  final String? description;
  final String? availableDate;
  final bool? immediateEnter;

  EditTicketPostState({
    this.id,
    this.postType,
    this.title,
    this.location,
    this.ticketType,
    this.handoverPrice,
    this.createdAt,
    this.isTransferred,
    this.additionalImages,
    this.authorProfileUrl,
    this.authorName,
    this.address,
    this.detailedAddress,
    this.remainingNum,
    this.remainingTime,
    this.maintenanceFee,
    this.description,
    this.availableDate,
    this.immediateEnter,
  });

  EditTicketPostState copyWith({
    Object? remainingNum = unchanged,
    Object? remainingTime = unchanged,
    Object? availableDate = unchanged,

    String? id,
    String? postType,
    String? title,
    String? location,
    String? ticketType,
    int? maintenanceFee,
    DateTime? createdAt,
    bool? isTransferred,
    List<String>? additionalImages,
    String? authorProfileUrl,
    String? authorName,
    String? address,
    String? detailedAddress,
    // int? remainingNum,
    // int? remainingTime,
    // String? availableDate,
    String? description,
    bool? immediateEnter,
  }) {
    return EditTicketPostState(
      id: id ?? this.id,
      postType: postType ?? this.postType,
      title: title ?? this.title,
      location: location ?? this.location,
      ticketType: ticketType ?? this.ticketType,
      createdAt: createdAt ?? this.createdAt,
      isTransferred: isTransferred ?? this.isTransferred,
      additionalImages: additionalImages ?? this.additionalImages,
      authorProfileUrl: authorProfileUrl ?? this.authorProfileUrl,
      authorName: authorName ?? this.authorName,
      address: address ?? this.address,
      detailedAddress: detailedAddress ?? this.detailedAddress,
      remainingNum: remainingNum == unchanged ? this.remainingNum : remainingNum as int?,
      remainingTime: remainingTime == unchanged ? this.remainingTime : remainingTime as int?,
      availableDate: availableDate == unchanged ? this.availableDate : availableDate as String?,
      maintenanceFee: maintenanceFee ?? this.maintenanceFee,
      description: description ?? this.description,
      immediateEnter: immediateEnter ?? this.immediateEnter,
    );
  }

  factory EditTicketPostState.fromOriginal(TicketDetailModel original) {
    return EditTicketPostState(
      id: original.id,
      postType: original.postType,
      title: original.title,
      location: original.location,
      ticketType: original.ticketType,
      createdAt: original.createdAt,
      isTransferred: original.isTransferred,
      additionalImages: original.additionalImages,
      authorProfileUrl: original.authorProfileUrl,
      authorName: original.authorName,
      address: original.address,
      detailedAddress: original.detailedAddress,
      remainingNum: original.remainingNum,
      remainingTime: original.remainingTime,
      maintenanceFee: original.maintenanceFee,
      description: original.description,
      availableDate: original.availableDate,
      immediateEnter: original.immediateEnter,
    );
  }

  DateTime? parseDate(String date) {
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

class EditTicketPostNotifier extends StateNotifier<EditTicketPostState> {
  EditTicketPostNotifier()
      : super(EditTicketPostState(
    id: '2',
    postType: '이용권',
    title: '헬스장 이용권 양도합니다.',
    location: '서울특별시 마포구',
    ticketType: '헬스장',
    createdAt: DateTime.now(),
    isTransferred: false,
    additionalImages: [
      '/Users/astraglus/Library/Developer/CoreSimulator/Devices/82FA348D-F0DB-42BE-BAE7-2C83EE432433/data/Containers/Data/Application/0BBA6B6F-9C55-478E-B409-2B26E2A8C078/tmp/image_picker_1E69B777-3AF0-44E7-9BD5-64F089140B56-1155-000006390BAF464D.jpg',
      '/Users/astraglus/Library/Developer/CoreSimulator/Devices/82FA348D-F0DB-42BE-BAE7-2C83EE432433/data/Containers/Data/Application/0BBA6B6F-9C55-478E-B409-2B26E2A8C078/tmp/image_picker_34437C57-0B62-458A-A6B4-E6F1201D33E4-1155-0000063966BADB42.jpg',
      '/Users/astraglus/Library/Developer/CoreSimulator/Devices/82FA348D-F0DB-42BE-BAE7-2C83EE432433/data/Containers/Data/Application/0BBA6B6F-9C55-478E-B409-2B26E2A8C078/tmp/image_picker_999DA050-84B3-4D4B-9D83-D83A69BFB3B1-1155-0000063967016F5D.jpg'

    ],
    authorProfileUrl: 'https://example.com/profile.jpg',
    authorName: 'Jane Doe',
    address: '서울특별시 마포구 상암동 123-45',
    detailedAddress: 'A동 101호',
    remainingNum: 5,
    remainingTime: null,
    maintenanceFee: 10,
    description: '자취방 양도하기 이용권 더미 데이터 입니다.',
    availableDate: '2025년 6월 1일',
    immediateEnter: true,
  ));



  void initializeWithOriginal(TicketDetailModel original) {
    state = EditTicketPostState.fromOriginal(original);
  }

  void updateLocation(String location) {
    state = state.copyWith(location: location);
  }

  void updateTicketTypeInfo(String ticketType, int? maintenanceFee) {
    state = state.copyWith(
      ticketType: ticketType,
      maintenanceFee: maintenanceFee,
    );
  }

  void updateRemainingInfo({int? remainingNum, int? remainingTime,String? availableDate}) {

    state = state.copyWith(
      remainingNum: remainingNum,
      remainingTime: remainingTime,
      availableDate: availableDate,
    );
  }

  void updateTitleAndContent(String title,String description) {
    state = state.copyWith(
        title: title,
        description: description)
    ;
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

  void resetAll() {
    state = EditTicketPostState();
  }
}