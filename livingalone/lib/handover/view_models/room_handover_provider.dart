import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/handover/view_models/handover_check_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';

// 방 양도 작성 상태를 관리하는 Provider
final roomHandoverProvider = StateNotifierProvider<RoomHandoverNotifier, RoomHandoverState>((ref) {
  return RoomHandoverNotifier(ref.read(roomHandoverCheckProvider));
});

// 방 양도 작성에 필요한 모든 데이터를 담는 State
class RoomHandoverState {
  // 필수 필드
  final String? address;           // 주소
  final String? detailAddress;     // 상세주소
  final String? buildingType; // 건물 유형
  final String? propertyType; // 매물 종류
  final String? rentType;        // 임대 방식
  final int? maintenance;          // 관리비
  final String? availableDate;     // 입주 가능일
  final bool immediateIn;          // 즉시입주 여부
  final String? title;
  final String? description;       // 상세 설명
  final String? area;              // 면적
  final String? floor;             // 층수

  // 선택 필드 (임대 방식에 따라 필수가 될 수 있음)
  final int? deposit;              // 보증금 (전세, 월세일 때 필수)
  final int? monthlyRent;          // 월세 (월세, 단기양도일 때만 필수)
  
  // 선택 필드
  final Set<RoomOption> options;   // 옵션 목록
  final Set<Facility> facilities;  // 시설 목록
  final Set<RoomCondition> conditions; // 조건 목록
  final List<File> images;         // 이미지 (최소 1장 필수)

  RoomHandoverState({
    this.address,
    this.detailAddress,
    this.buildingType,
    this.propertyType,
    this.rentType,
    this.deposit,
    this.monthlyRent,
    this.title,
    this.maintenance,
    this.options = const {},
    this.facilities = const {},
    this.conditions = const {},
    this.availableDate,
    this.images = const [],
    this.description,
    this.area,
    this.floor,
    this.immediateIn = false,
  });

  // 복사본을 만드는 메서드
  RoomHandoverState copyWith({
    String? address,
    String? detailAddress,
    String? buildingType,
    String? propertyType,
    String? rentType,
    int? deposit,
    int? monthlyRent,
    int? maintenance,
    Set<RoomOption>? options,
    Set<Facility>? facilities,
    Set<RoomCondition>? conditions,
    String? availableDate,
    List<File>? images,  // String에서 File로 변경
    String? title,
    String? description,
    String? area,
    String? floor,
    bool? immediateIn,
  }) {
    return RoomHandoverState(
      address: address ?? this.address,
      detailAddress: detailAddress ?? this.detailAddress,
      buildingType: buildingType ?? this.buildingType,
      propertyType: propertyType ?? this.propertyType,
      rentType: rentType ?? this.rentType,
      deposit: deposit ?? this.deposit,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      maintenance: maintenance ?? this.maintenance,
      options: options ?? this.options,
      facilities: facilities ?? this.facilities,
      conditions: conditions ?? this.conditions,
      availableDate: availableDate ?? this.availableDate,
      images: images ?? this.images,
      title: title ?? this.title,
      description: description ?? this.description,
      area: area ?? this.area,
      floor: floor ?? this.floor,
      immediateIn: immediateIn ?? this.immediateIn,
    );
  }

  // 모든 필수 필드가 채워졌는지 확인
  bool get isValid {
    // 1. 기본 필수 필드 검증
    if (address == null ||
        detailAddress == null ||
        buildingType == null ||
        propertyType == null ||
        rentType == null ||
        maintenance == null ||
        availableDate == null ||
        area == null ||
        floor == null ||
        title == null ||
        description == null ||
        images.isEmpty) {
      return false;
    }

    // // 2. 임대 방식별 추가 필수 필드 검증
    // switch (rentType!) {
    //   case RentType.monthlyRent:
    //     if (deposit == null || monthlyRent == null) return false;
    //   case RentType.wholeRent:
    //     if (deposit == null) return false;
    //   case RentType.shortRent:
    //     if (monthlyRent == null) return false;
    // }

    return true;
  }
}

class RoomHandoverNotifier extends StateNotifier<RoomHandoverState> {
  final HandoverCheckState checkState;
  final dio = Dio();  // dio 인스턴스 생성
  
  RoomHandoverNotifier(this.checkState) : super(RoomHandoverState());

  // 일반화된 업데이트 메서드
  void update({
    String? address,
    String? detailAddress,
    String? buildingType,
    String? propertyType,
    String? rentType,
    int? deposit,
    int? monthlyRent,
    int? maintenance,
    Set<RoomOption>? options,
    Set<Facility>? facilities,
    Set<RoomCondition>? conditions,
    String? availableDate,
    List<File>? images,  // String에서 File로 변경
    String? description,
    String? area,
    String? currentFloor,
    String? totalFloor,
    DateTime? startDate,
    DateTime? endDate,
    bool? immediateIn,
  }) {
    state = state.copyWith(
      address: address,
      detailAddress: detailAddress,
      buildingType: buildingType,
      propertyType: propertyType,
      rentType: rentType,
      deposit: deposit,
      monthlyRent: monthlyRent,
      maintenance: maintenance,
      options: options,
      facilities: facilities,
      conditions: conditions,
      availableDate: _formatDate(startDate, endDate),
      images: images,  // File 타입으로 전달
      description: description,
      area: area,
      floor: (currentFloor != null && totalFloor != null) 
          ? '$currentFloor/$totalFloor'
          : state.floor,
      immediateIn: immediateIn,
    );
  }

  String? _formatDate(DateTime? startDate, DateTime? endDate) {
    if (startDate == null) return null;
    
    final dateFormat = (d) => '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';
    
    if (endDate != null) {
      // 단기양도의 경우
      return '${dateFormat(startDate)} ~ ${dateFormat(endDate)}';
    } else {
      // 일반 입주가능일
      return dateFormat(startDate);
    }
  }

  // 옵션 토글은 특별한 로직이 필요해서 별도 메서드로 유지
  void toggleOption(RoomOption option) {
    final newOptions = Set<RoomOption>.from(state.options);
    if (newOptions.contains(option)) {
      newOptions.remove(option);
    } else {
      newOptions.add(option);
    }
    update(options: newOptions);
  }

  void toggleFacility(Facility facility) {
    final newFacilities = Set<Facility>.from(state.facilities);
    if (newFacilities.contains(facility)) {
      newFacilities.remove(facility);
    } else {
      newFacilities.add(facility);
    }
    update(facilities: newFacilities);
  }

  void toggleCondition(RoomCondition condition) {
    final newConditions = Set<RoomCondition>.from(state.conditions);
    if (newConditions.contains(condition)) {
      newConditions.remove(condition);
    } else {
      newConditions.add(condition);
    }
    update(conditions: newConditions);
  }

  // 이미지 추가 메서드
  void addImages(List<File> newImages) {
    final updatedImages = List<File>.from(state.images)..addAll(newImages);
    update(images: updatedImages);
  }

  // 이미지 제거 메서드
  void removeImage(int index) {
    final updatedImages = List<File>.from(state.images)..removeAt(index);
    update(images: updatedImages);
  }

  // 최종 제출
  Future<void> submit() async {
    if (!state.isValid) return;

    final formData = FormData.fromMap({
      // 필수 필드
      'address': state.address,
      'detailAddress': state.detailAddress,
      'buildingType': state.buildingType,  // enum의 label 사용
      'propertyType': state.propertyType,  // enum의 label 사용
      'rentType': state.rentType,          // enum의 label 사용
      'maintenance': state.maintenance,            // 숫자 타입 유지
      'availableDate': state.availableDate,
      'immediateIn': state.immediateIn,
      'description': state.description,
      'area': state.area,
      'floor': state.floor,

      // 조건부 필수 필드 (null일 수 있음)
      'deposit': state.deposit,                    // 숫자 타입 유지
      'monthlyRent': state.monthlyRent,           // 숫자 타입 유지

      // 선택 필드
      'options': state.options.isNotEmpty 
          ? state.options.map((e) => e.label).toList() 
          : null,
      'facilities': state.facilities.isNotEmpty 
          ? state.facilities.map((e) => e.label).toList() 
          : null,
      'conditions': state.conditions.isNotEmpty 
          ? state.conditions.map((e) => e.label).toList() 
          : null,

      // 체크 정보
      'checkConfirmed': checkState.isChecked,
      'checkConfirmedAt': checkState.checkedAt?.toIso8601String(),
    });

    // 이미지 파일 추가
    for (var i = 0; i < state.images.length; i++) {
      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(
            state.images[i].path,
            filename: 'image_$i.jpg',
          ),
        ),
      );
    }

    try {
      final response = await dio.post(
        'api',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to upload: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
} 