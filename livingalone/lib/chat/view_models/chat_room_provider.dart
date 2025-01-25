import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/chat/models/message_model.dart';
import 'package:livingalone/chat/view_models/chat_list_provider.dart';
import 'package:livingalone/chat/repository/chat_room_repository.dart';

final chatMessagesProvider = StateNotifierProvider.family<ChatMessagesNotifier, List<ChatMessage>, String>(
  (ref, roomId) => ChatMessagesNotifier(
    repository: ref.watch(chatRoomRepositoryProvider),
    chatRoomsNotifier: ref.watch(chatRoomsProvider.notifier),
    roomId: roomId,
  ),
);

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  final ChatRoomRepository repository;
  final ChatRoomsNotifier chatRoomsNotifier;
  final String roomId;

  ChatMessagesNotifier({
    required this.repository,
    required this.chatRoomsNotifier,
    required this.roomId,
  }) : super([]) {
    // _initialize();
    _initializeDummyData();
  }

  // Future<void> _initialize() async {
  //   await _getMessages();
  //   _connectWebSocket();
  // }

  // Future<void> _getMessages() async {
  //   try {
  //     final messages = await repository.getMessages(roomId);
  //     state = messages;
  //     await repository.markAsRead(roomId);
  //   } catch (e) {
  //     print('Error fetching messages: $e');
  //   }
  // }

  void _initializeDummyData() {
    state = [
      ChatMessage(
        messageId: '1',
        senderId: 'other',
        content: '안녕하세요, 게시글 보고 연락드립니다.',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        isMe: false,
        isRead: true,
      ),
      ChatMessage(
        messageId: '2',
        senderId: 'me',
        content: '네, 안녕하세요. 아직 양도 가능합니다.',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        isMe: true,
        isRead: true,
      ),
      ChatMessage(
        messageId: '3',
        senderId: 'other',
        content: '혹시 가격 네고 가능할까요?',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isMe: false,
        isRead: true,
      ),
      ChatMessage(
        messageId: '4',
        senderId: 'me',
        content: '네, 어느 정도 생각하시나요?',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isMe: true,
        isRead: true,
      ),
      ChatMessage(
        messageId: '5',
        senderId: 'other',
        content: '사진 보내드립니다.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: false,
        isRead: true,
      ),
      ChatMessage(
        messageId: '6',
        senderId: 'other',
        content: '',
        imageUrl: 'https://picsum.photos/400/300',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: false,
        isRead: true,
      ),
      ChatMessage(
        messageId: '7',
        senderId: 'me',
        content: '네 확인했습니다. 내일 다시 연락드리겠습니다.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isMe: true,
        isRead: false,
      ),
    ];
  }

  Future<void> sendMessage(String content) async {
    // try {
    //   final message = await repository.sendMessage(roomId, content);
    //   state = [...state, message];
    //   chatRoomsNotifier.updateLastMessage(
    //     roomId,
    //     message.content,
    //     message.timestamp,
    //   );
    // } catch (e) {
    //   print('Error sending message: $e');
    // }

    // 더미 메시지 전송
    final newMessage = ChatMessage(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      content: content,
      timestamp: DateTime.now(),
      isMe: true,
      isRead: false,
    );

    state = [...state, newMessage];
    
    chatRoomsNotifier.updateLastMessage(
      roomId,
      content,
      newMessage.timestamp,
    );

    // 더미 응답 메시지 (테스트용)
    Future.delayed(const Duration(seconds: 1), () {
      final replyMessage = ChatMessage(
        messageId: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'other',
        content: '네, 알겠습니다.',
        timestamp: DateTime.now(),
        isMe: false,
        isRead: false,
      );
      state = [...state, replyMessage];
      
      chatRoomsNotifier.updateLastMessage(
        roomId,
        replyMessage.content,
        replyMessage.timestamp,
      );
    });
  }

  Future<void> sendImage(String imagePath) async {
    // try {
    //   final message = await repository.sendImageMessage(roomId, imagePath);
    //   state = [...state, message];
    //   chatRoomsNotifier.updateLastMessage(
    //     roomId,
    //     '사진',
    //     message.timestamp,
    //   );
    // } catch (e) {
    //   print('Error sending image: $e');
    // }

    // 더미 이미지 메시지 전송
    final newMessage = ChatMessage(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      content: '',
      imageUrl: 'https://picsum.photos/400/300',
      timestamp: DateTime.now(),
      isMe: true,
      isRead: false,
    );

    state = [...state, newMessage];
    
    chatRoomsNotifier.updateLastMessage(
      roomId,
      '사진',
      newMessage.timestamp,
    );

    // 더미 응답 메시지 (테스트용)
    Future.delayed(const Duration(seconds: 1), () {
      final replyMessage = ChatMessage(
        messageId: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'other',
        content: '사진 잘 보았습니다.',
        timestamp: DateTime.now(),
        isMe: false,
        isRead: false,
      );
      state = [...state, replyMessage];
      
      chatRoomsNotifier.updateLastMessage(
        roomId,
        replyMessage.content,
        replyMessage.timestamp,
      );
    });
  }
}
