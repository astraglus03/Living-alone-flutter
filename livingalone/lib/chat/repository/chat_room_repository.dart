import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/chat/models/message_model.dart';
import 'package:livingalone/common/const/const.dart';
import 'package:livingalone/common/dio/dio.dart';

final chatRoomRepositoryProvider = Provider<ChatRoomRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return ChatRoomRepository(dio, baseUrl: 'http://$ip/api/v1');
  },
);

class ChatRoomRepository {
  final String baseUrl;
  final Dio dio;

  ChatRoomRepository(this.dio, {required this.baseUrl});

  // 채팅 메시지 목록 조회
  Future<List<ChatMessage>> getMessages(String roomId) async {
    try {
      final response = await dio.get<List<dynamic>>(
        '$baseUrl/chat/rooms/$roomId/messages',
      );

      return response.data!
          .map<ChatMessage>(
            (item) => ChatMessage.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  // 메시지 전송
  Future<ChatMessage> sendMessage(String roomId, String content) async {
    try {
      final response = await dio.post(
        '$baseUrl/chat/rooms/$roomId/messages',
        data: {
          'content': content,
        },
      );

      return ChatMessage.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  // 이미지 메시지 전송
  Future<ChatMessage> sendImageMessage(String roomId, String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await dio.post(
        '$baseUrl/chat/rooms/$roomId/messages/image',
        data: formData,
      );

      return ChatMessage.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  // 메시지 읽음 처리
  Future<void> markAsRead(String roomId) async {
    try {
      await dio.post(
        '$baseUrl/chat/rooms/$roomId/read',
      );
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
