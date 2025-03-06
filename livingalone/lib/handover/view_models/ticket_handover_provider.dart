import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:livingalone/common/enum/ticket_enums.dart';
import 'package:livingalone/handover/view_models/handover_check_provider.dart';


final ticketHandoverProvider = StateNotifierProvider<TicketHandoverNotifier, TicketHandoverState>((ref) {
  return TicketHandoverNotifier(ref.read(ticketHandoverCheckProvider));
});

class TicketHandoverState {
  final String? address;
  final String? detailAddress;
  final String? ticketType;
  final int? price;
  final int? transferPrice;
  final int? remainingCount;
  final int? remainingHours;
  final DateTime? expiryDate;
  final List<File> images;
  final String? title;
  final String? description;

  TicketHandoverState({
    this.address,
    this.detailAddress,
    this.ticketType,
    this.price,
    this.transferPrice,
    this.remainingCount,
    this.remainingHours,
    this.expiryDate,
    this.images = const [],
    this.title,
    this.description,
  });

  TicketHandoverState copyWith({
    String? address,
    String? detailAddress,
    String? ticketType,
    int? price,
    int? transferPrice,
    int? remainingCount,
    int? remainingHours,
    DateTime? expiryDate,
    List<File>? images,
    String? title,
    String? description,
  }) {
    return TicketHandoverState(
      address: address ?? this.address,
      detailAddress: detailAddress ?? this.detailAddress,
      ticketType: ticketType ?? this.ticketType,
      price: price ?? this.price,
      transferPrice : transferPrice ?? this.transferPrice,
      remainingCount: remainingCount ?? this.remainingCount,
      remainingHours: remainingHours ?? this.remainingHours,
      expiryDate: expiryDate ?? this.expiryDate,
      images: images ?? this.images,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  bool get isValid {
    if (address == null || 
        detailAddress == null ||
        ticketType == null || 
        price == null ||
        transferPrice == null ||
        images.isEmpty ||
        title == null || 
        description == null) {
      return false;
    }

    // 최소한 하나의 제한 조건은 있어야 함
    if (remainingCount == null && 
        remainingHours == null && 
        expiryDate == null) {
      return false;
    }

    return true;
  }
}

class TicketHandoverNotifier extends StateNotifier<TicketHandoverState> {
  final HandoverCheckState checkState;
  final dio = Dio();

  TicketHandoverNotifier(this.checkState) : super(TicketHandoverState());

  void update({
    String? address,
    String? detailAddress,
    String? ticketType,
    int? price,
    int? transferPrice,
    int? remainingCount,
    int? remainingHours,
    DateTime? expiryDate,
    List<File>? images,
    String? title,
    String? description,
  }) {
    state = state.copyWith(
      address: address,
      detailAddress: detailAddress,
      ticketType: ticketType,
      price: price,
      transferPrice: transferPrice,
      remainingCount: remainingCount,
      remainingHours: remainingHours,
      expiryDate: expiryDate,
      images: images,
      title: title,
      description: description,
    );
  }

  void addImages(List<File> newImages) {
    final updatedImages = List<File>.from(state.images)..addAll(newImages);
    update(images: updatedImages);
  }

  void removeImage(int index) {
    final updatedImages = List<File>.from(state.images)..removeAt(index);
    update(images: updatedImages);
  }

  Future<void> submit() async {
    if (!state.isValid) return;

    final formData = FormData.fromMap({
      'address': state.address,
      'detailAddress': state.detailAddress,
      'ticketType': state.ticketType,
      'price': state.price.toString(),
      'transferPrice': state.transferPrice.toString(),
      'remainingCount': state.remainingCount?.toString(),
      'remainingHours': state.remainingHours?.toString(),
      'expiryDate': state.expiryDate?.toIso8601String(),
      'title': state.title,
      'description': state.description,
      'checkConfirmed': checkState.isChecked.toString(),
      'checkConfirmedAt': checkState.checkedAt?.toIso8601String(),
    });

    for (var i = 0; i < state.images.length; i++) {
      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(state.images[i].path, filename: 'image_$i.jpg'),
        ),
      );
    }

    try {
      final response = await dio.post(
        'your_api_endpoint',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to upload: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
