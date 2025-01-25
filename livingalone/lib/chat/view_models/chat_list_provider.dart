import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/chat/models/chat_room_model.dart';
import 'package:livingalone/chat/repository/chat_list_repository.dart';

final chatRoomsProvider = StateNotifierProvider<ChatRoomsNotifier, List<ChatRoom>>(
  (ref) => ChatRoomsNotifier(
    repository: ref.watch(chatListRepositoryProvider),
  ),
);

class ChatRoomsNotifier extends StateNotifier<List<ChatRoom>> {
  final ChatListRepository repository;

  ChatRoomsNotifier({
    required this.repository,
  }) : super([]) {
    // getChatRooms();
    _initializeDummyData();
  }

  void _initializeDummyData() {
    state = [
      ChatRoom(
        roomId: '1',
        opponentName: '고냠미1',
        opponentProfileUrl: 'https://picsum.photos/200',
        title: '안서동보아파트 101동',
        lastMessage: '네 알겠습니다. 확인해보고 연락드리겠습니다.',
        type: 'ROOM',
        updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        hasUnreadMessages: true,
      ),
      ChatRoom(
        roomId: '2',
        opponentName: '고냠미1',
        opponentProfileUrl: 'https://picsum.photos/201',
        title: '미녀와야수짐 안서점',
        lastMessage: '네고 가능하신가요?',
        type: 'TICKET',
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        hasUnreadMessages: false,
      ),
      ChatRoom(
        roomId: '3',
        opponentName: '고냠미1',
        opponentProfileUrl: '',
        title: '트윈빌라',
        lastMessage: '사진',
        type: 'ROOM',
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        hasUnreadMessages: true,
      ),
      ChatRoom(
        roomId: '4',
        opponentName: '고냠미1',
        opponentProfileUrl: 'https://picsum.photos/202',
        title: '천안시청 수영장 이용권',
        lastMessage: '안녕하세요, 양도 아직 가능한가요?',
        type: 'TICKET',
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        hasUnreadMessages: false,
      ),
    ];
  }

  // Future<void> getChatRooms() async {
  //   try {
  //     final rooms = await repository.getChatRooms();
  //     state = rooms;
  //   } catch (e) {
  //     print('Error fetching chat rooms: $e');
  //   }
  // }

  Future<void> leaveChatRoom(String roomId) async {
    // try {
    //   await repository.leaveChatRoom(roomId);
      state = state.where((room) => room.roomId != roomId).toList();
    // } catch (e) {
    //   print('Error leaving chat room: $e');
    // }
  }

  Future<void> createChatRoom({
    required String postId,
    required String postType,
  }) async {
    // try {
    //   final newRoom = await repository.createChatRoom(
    //     postId: postId,
    //     postType: postType,
    //   );
    //   state = [...state, newRoom];
    // } catch (e) {
    //   print('Error creating chat room: $e');
    // }

    // 더미 데이터로 채팅방 생성
    final newRoom = ChatRoom(
      roomId: DateTime.now().millisecondsSinceEpoch.toString(),
      opponentName: '새로운 사용자',
      opponentProfileUrl: 'https://picsum.photos/203',
      title: postType == 'ROOM' ? '새로운 자취방 양도' : '새로운 이용권 양도',
      lastMessage: '채팅이 시작되었습니다.',
      type: postType,
      updatedAt: DateTime.now(),
      hasUnreadMessages: false,
    );
    state = [...state, newRoom];
  }

  void updateLastMessage(String roomId, String message, DateTime timestamp) {
    state = state.map((room) {
      if (room.roomId == roomId) {
        return ChatRoom(
          roomId: room.roomId,
          opponentName: room.opponentName,
          opponentProfileUrl: room.opponentProfileUrl,
          title: room.title,
          lastMessage: message,
          type: room.type,
          updatedAt: timestamp,
          hasUnreadMessages: true,
        );
      }
      return room;
    }).toList();

    // 최신 메시지 순으로 정렬
    state.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }
}
