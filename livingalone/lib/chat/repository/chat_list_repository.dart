import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/chat/models/chat_room_model.dart';
import 'package:livingalone/common/const/const.dart';
import 'package:livingalone/common/dio/dio.dart';

final chatListRepositoryProvider = Provider<ChatListRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return ChatListRepository(dio, baseUrl: 'http://$ip/api/v1');
  },
);

class ChatListRepository {
  final String baseUrl;
  final Dio dio;

  ChatListRepository(this.dio, {required this.baseUrl});

  Future<List<ChatRoom>> getChatRooms() async {
    try {
      final response = await dio.get<List<dynamic>>(
        '$baseUrl/chat/rooms',
      );

      return response.data!
          .map<ChatRoom>(
            (item) => ChatRoom.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  // 채팅방 나가기
  Future<void> leaveChatRoom(String roomId) async {
    try {
      await dio.delete(
        '$baseUrl/chat/rooms/$roomId',
      );
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  // 채팅방 생성 (상세 페이지에서 채팅 시작할 때 사용)
  Future<ChatRoom> createChatRoom({
    required String postId,
    required String postType,  // 'TICKET' or 'ROOM'
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/chat/rooms',
        data: {
          'postId': postId,
          'postType': postType,
        },
      );

      return ChatRoom.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}