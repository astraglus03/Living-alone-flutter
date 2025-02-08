import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:livingalone/chat/models/chat_message_model.dart';
import 'package:livingalone/chat/models/chat_room_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// API Repository Implementation (주석 처리)
/*
@RestApi()
abstract class ApiChatRepository implements ChatRepository {
  factory ApiChatRepository(Dio dio, {String baseUrl}) = _ApiChatRepository;

  @GET('/chats/rooms')
  Future<List<ChatRoom>> getChatRooms();

  @GET('/chats/rooms/{roomId}/messages')
  Future<List<ChatMessage>> getChatMessages(@Path() String roomId);

  @POST('/chats/rooms/{roomId}/messages')
  Future<ChatMessage> sendMessage(
    @Path() String roomId,
    @Body() Map<String, String> message,
  );

  @PUT('/chats/rooms/{roomId}/read')
  Future<void> markAsRead(@Path() String roomId);
}
*/

// API Repository Interface
abstract class ChatRepository {
  Future<List<ChatRoom>> getChatRooms();
  Future<List<ChatMessage>> getChatMessages(String roomId);
  Future<ChatMessage> sendMessage(String roomId, String content);
  Future<void> markAsRead(String roomId);
}

// Dummy Repository Implementation
class DummyChatRepository implements ChatRepository {
  final List<ChatRoom> _rooms = [
    ChatRoom(
      roomId: '1',
      opponentName: '상명대 취준생',
      opponentProfileUrl: 'https://picsum.photos/200',
      title: '역삼동 원룸 양도합니다',
      lastMessage: '네 가능합니다!',
      type: 'ROOM',
      lastMessageTime: DateTime.now().subtract(Duration(minutes: 5)),
      hasUnreadMessages: true,
      location: '안서동',
      thumbnailUrl: 'https://picsum.photos/300/200',
      buildingType: '아파트',
      propertyType: '원룸',
      rentType: '단기양도',
      deposit: 500,
      monthlyRent: 50,
      maintenance: 5,
    ),
    ChatRoom(
      roomId: '2',
      opponentName: '앱 개발자1',
      opponentProfileUrl: 'https://picsum.photos/201',
      title: '헬스장 3개월 이용권 판매합니다',
      lastMessage: '네고 가능할까요?',
      type: 'TICKET',
      lastMessageTime: DateTime.now().subtract(Duration(hours: 1)),
      hasUnreadMessages: false,
      location: '역삼동',
      thumbnailUrl: 'https://picsum.photos/300/201',
      ticketType: '헬스장 이용권',
      remainingDays: 90,
      price: 150000,
    ),
  ];

  final List<ChatMessage> _messages = [
    ChatMessage(
      messageId: '1',
      roomId: '1',
      senderId: 'user1',
      content: '안녕하세요, 매물 문의드립니다.',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      isRead: true,
      messageType: 'TEXT',
    ),
    ChatMessage(
      messageId: '2',
      roomId: '1',
      senderId: 'user2',
      content: '네, 어떤 점이 궁금하신가요?',
      createdAt: DateTime.now().subtract(Duration(hours: 23)),
      isRead: true,
      messageType: 'TEXT',
    ),
  ];

  @override
  Future<List<ChatRoom>> getChatRooms() async {
    await Future.delayed(Duration(milliseconds: 500));
    return _rooms;
  }

  @override
  Future<List<ChatMessage>> getChatMessages(String roomId) async {
    await Future.delayed(Duration(milliseconds: 500));
    return _messages.where((message) => message.roomId == roomId).toList();
  }

  @override
  Future<ChatMessage> sendMessage(String roomId, String content) async {
    await Future.delayed(Duration(milliseconds: 500));
    final newMessage = ChatMessage(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      roomId: roomId,
      senderId: 'user1', // Current user
      content: content,
      createdAt: DateTime.now(),
      isRead: false,
      messageType: 'TEXT',
    );
    _messages.add(newMessage);

    // Update last message in chat room
    final roomIndex = _rooms.indexWhere((room) => room.roomId == roomId);
    if (roomIndex != -1) {
      _rooms[roomIndex] = _rooms[roomIndex].copyWith(
        lastMessage: content,
        lastMessageTime: DateTime.now(),
      );
    }

    return newMessage;
  }

  @override
  Future<void> markAsRead(String roomId) async {
    await Future.delayed(Duration(milliseconds: 500));
    final roomIndex = _rooms.indexWhere((room) => room.roomId == roomId);
    if (roomIndex != -1) {
      _rooms[roomIndex] = _rooms[roomIndex].copyWith(hasUnreadMessages: false);
    }
  }
}