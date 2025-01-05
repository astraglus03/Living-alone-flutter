import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/handover/view_models/handover_check_provider.dart';
import 'dart:io';  // File 타입을 위해 추가
import 'dart:convert';  // json 파싱을 위해 추가
import 'dart:async';  // http 호출을 위해 추가
import 'package:http/http.dart' as http;  // http 패키지를 위해 추가
import 'package:dio/dio.dart';  // http 대신 dio 사용

// 방 양도 작성 상태를 관리하는 Provider
final roomHandoverProvider = StateNotifierProvider<RoomHandoverNotifier, RoomHandoverState>((ref) {
  return RoomHandoverNotifier(ref.read(handoverCheckProvider));
});

// 방 양도 작성에 필요한 모든 데이터를 담는 State
class RoomHandoverState {
  final String? address;           // 주소 (1/8)
  final String? detailAddress;     // 상세주소 (1/8)
  final BuildingType? buildingType; // 건물 유형 (2/8)
  final PropertyType? propertyType; // 매물 종류 (3/8)
  final RentType? rentType;        // 임대 방식 (4/8)
  final int? deposit;              // 보증금 (5/8) - 전세, 월세일 때 필수
  final int? monthlyRent;          // 월세 (5/8) - 월세, 단기양도일 때만 필수
  final int? maintenance;          // 관리비 (5/8) - 필수
  final Set<RoomOption> options;   // 옵션 목록 (6/8) - 선택사항
  final Set<Facility> facilities;  // 시설 목록 (6/8) - 선택사항
  final Set<RoomCondition> conditions; // 조건 목록 (6/8) - 선택사항
  final String? availableDate;     // 입주 가능일 (7/8) - 필수
  final bool immediateIn;          // 즉시입주 여부 (7/8)
  final List<File> images;       // String에서 File로 변경
  final String? description;       // 상세 설명 (8/8) - 필수
  final String? area;              // 면적 (6/8) - 필수
  final String? floor;             // 층수 (6/8) - 필수

  RoomHandoverState({
    this.address,
    this.detailAddress,
    this.buildingType,
    this.propertyType,
    this.rentType,
    this.deposit,
    this.monthlyRent,
    this.maintenance,
    this.options = const {},       // 기본값 빈 Set
    this.facilities = const {},    // 기본값 빈 Set
    this.conditions = const {},    // 기본값 빈 Set
    this.availableDate,
    this.images = const [],      // 기본값 빈 리스트
    this.description,
    this.area,
    this.floor,
    this.immediateIn = false,      // 기본값 false
  });

  // 복사본을 만드는 메서드
  RoomHandoverState copyWith({
    String? address,
    String? detailAddress,
    BuildingType? buildingType,
    PropertyType? propertyType,
    RentType? rentType,
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
      description: description ?? this.description,
      area: area ?? this.area,
      floor: floor ?? this.floor,
      immediateIn: immediateIn ?? this.immediateIn,
    );
  }

  // 모든 필수 필드가 채워졌는지 확인
  bool get isValid {
    // 기본 필수 필드 검증
    if (address == null ||
        buildingType == null ||
        propertyType == null ||
        rentType == null ||
        maintenance == null ||
        area == null ||
        floor == null ||
        description == null ||
        images.isEmpty) {
      return false;
    }

    // 임대 방식별 추가 검증
    switch (rentType) {
      case RentType.monthlyRent:
        return deposit != null && monthlyRent != null;
      case RentType.wholeRent:
        return deposit != null;
      case RentType.shortRent:
        return monthlyRent != null;
      default:
        return false;
    }
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
    BuildingType? buildingType,
    PropertyType? propertyType,
    RentType? rentType,
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
      'address': state.address,
      'detailAddress': state.detailAddress,
      'buildingType': state.buildingType?.name,
      'propertyType': state.propertyType?.name,
      'rentType': state.rentType?.name,
      'deposit': state.deposit?.toString(),
      'monthlyRent': state.monthlyRent?.toString(),
      'maintenance': state.maintenance?.toString(),
      'options': state.options.map((e) => e.name).toList().join(','),
      'facilities': state.facilities.map((e) => e.name).toList().join(','),
      'conditions': state.conditions.map((e) => e.name).toList().join(','),
      'availableDate': state.availableDate,
      'immediateIn': state.immediateIn.toString(),
      'area': state.area,
      'floor': state.floor,
      'description': state.description,
      'checkConfirmed': checkState.isChecked.toString(),
      'checkConfirmedAt': checkState.checkedAt?.toIso8601String(),
    });

    // 이미지 파일 추가
    for (var i = 0; i < state.images.length; i++) {
      final file = state.images[i];
      formData.files.add(
        MapEntry(
          'images',  // 서버에서 기대하는 필드 이름
          await MultipartFile.fromFile(
            file.path,
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
            // 'Authorization': 'Bearer your_token',
          },
          contentType: 'multipart/form-data',
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