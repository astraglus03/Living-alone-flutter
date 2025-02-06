import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/chat/models/chat_message_model.dart';
import 'package:livingalone/chat/models/chat_room_model.dart';
import 'package:livingalone/chat/repository/chat_repository.dart';

// Repository provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return DummyChatRepository();
});

// Chat Room Provider
final chatRoomProvider = StateNotifierProvider<ChatRoomNotifier, ChatRoomState>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatRoomNotifier(repository);
});

// Chat Message Provider
final chatMessageProvider = StateNotifierProvider.family<ChatMessageNotifier, ChatMessageState, String>((ref, roomId) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatMessageNotifier(repository, roomId, ref);
});

// Chat Room State
class ChatRoomState {
  final List<ChatRoom> rooms;
  final bool isLoading;
  final String? error;

  ChatRoomState({
    required this.rooms,
    required this.isLoading,
    this.error,
  });

  ChatRoomState copyWith({
    List<ChatRoom>? rooms,
    bool? isLoading,
    String? error,
  }) {
    return ChatRoomState(
      rooms: rooms ?? this.rooms,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Chat Room Notifier
class ChatRoomNotifier extends StateNotifier<ChatRoomState> {
  final ChatRepository _repository;

  ChatRoomNotifier(this._repository)
      : super(ChatRoomState(rooms: [], isLoading: false)) {
    loadRooms();
  }

  Future<void> loadRooms() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final rooms = await _repository.getChatRooms();
      state = state.copyWith(rooms: rooms, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '채팅방을 불러오는데 실패했습니다.',
      );
    }
  }

  void updateLastMessage(String roomId, String message, DateTime timestamp, bool hasUnreadMessages) {
    final updatedRooms = state.rooms.map((room) {
      if (room.roomId == roomId) {
        return room.copyWith(
          lastMessage: message,
          lastMessageTime: timestamp,
          hasUnreadMessages: hasUnreadMessages,
        );
      }
      return room;
    }).toList();

    // Sort rooms by last message time
    updatedRooms.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

    state = state.copyWith(rooms: updatedRooms);
  }
}

// Chat Message State
class ChatMessageState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  ChatMessageState({
    required this.messages,
    required this.isLoading,
    this.error,
  });

  ChatMessageState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatMessageState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Chat Message Notifier
class ChatMessageNotifier extends StateNotifier<ChatMessageState> {
  final ChatRepository _repository;
  final String roomId;
  final Ref _ref;

  ChatMessageNotifier(this._repository, this.roomId, this._ref)
      : super(ChatMessageState(messages: [], isLoading: false)) {
    loadMessages();
  }

  Future<void> loadMessages() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final messages = await _repository.getChatMessages(roomId);
      state = state.copyWith(messages: messages, isLoading: false);

      // Update chat room's last message if there are messages
      if (messages.isNotEmpty) {
        final lastMessage = messages.last;
        final chatRoomNotifier = _ref.read(chatRoomProvider.notifier);
        chatRoomNotifier.updateLastMessage(
          roomId,
          lastMessage.content,
          lastMessage.createdAt,
          lastMessage.senderId != 'user1', // hasUnreadMessages is true only if sender is not current user
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '메시지를 불러오는데 실패했습니다.',
      );
    }
  }

  Future<void> sendMessage(String content) async {
    try {
      final newMessage = await _repository.sendMessage(roomId, content);
      state = state.copyWith(
        messages: [...state.messages, newMessage],
      );

      // Update chat room list with new message
      final chatRoomNotifier = _ref.read(chatRoomProvider.notifier);
      chatRoomNotifier.updateLastMessage(
        roomId,
        content,
        DateTime.now(),
        false, // hasUnreadMessages is false because I sent the message
      );
    } catch (e) {
      // Handle error silently
    }
  }
}

// All messages provider
final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, Map<String, List<ChatMessage>>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatMessagesNotifier(repository, ref);
});

// Last message provider for each room
final lastMessageProvider = Provider.family<ChatMessage?, String>((ref, roomId) {
  final messages = ref.watch(chatMessagesProvider)[roomId] ?? [];
  return messages.isEmpty ? null : messages.last;
});

// Messages notifier to manage all chat messages
class ChatMessagesNotifier extends StateNotifier<Map<String, List<ChatMessage>>> {
  final ChatRepository _repository;
  final Ref _ref;

  ChatMessagesNotifier(this._repository, this._ref) : super({});

  Future<void> loadMessages(String roomId) async {
    try {
      final messages = await _repository.getChatMessages(roomId);
      state = {...state, roomId: messages};
    } catch (e) {
      // Handle error
    }
  }

  Future<void> sendMessage(String roomId, String content) async {
    try {
      final newMessage = await _repository.sendMessage(roomId, content);
      final currentMessages = state[roomId] ?? [];
      state = {
        ...state,
        roomId: [...currentMessages, newMessage],
      };
    } catch (e) {
      // Handle error
    }
  }

  Future<void> markAsRead(String roomId) async {
    try {
      await _repository.markAsRead(roomId);
      final messages = state[roomId] ?? [];
      final updatedMessages = messages.map((msg) => msg.copyWith(isRead: true)).toList();
      state = {...state, roomId: updatedMessages};

      // Update chat room's unread status
      final chatRoomNotifier = _ref.read(chatRoomProvider.notifier);
      chatRoomNotifier.updateLastMessage(
        roomId,
        updatedMessages.last.content,
        updatedMessages.last.createdAt,
        false, // Set hasUnreadMessages to false
      );
    } catch (e) {
      // Handle error
    }
  }
}

// Message provider for a specific room
final roomMessagesProvider = Provider.family<List<ChatMessage>, String>((ref, roomId) {
  final allMessages = ref.watch(chatMessagesProvider);
  return allMessages[roomId] ?? [];
});

// Sorted chat rooms provider
final sortedChatRoomsProvider = Provider<List<ChatRoom>>((ref) {
  final rooms = ref.watch(chatRoomProvider).rooms;
  final allMessages = ref.watch(chatMessagesProvider);
  
  // Create a list of rooms with their last messages
  final roomsWithLastMessage = rooms.map((room) {
    final messages = allMessages[room.roomId] ?? [];
    final lastMessage = messages.isEmpty ? null : messages.last;
    return (room: room, lastMessage: lastMessage);
  }).toList();
  
  // Sort rooms by last message time
  roomsWithLastMessage.sort((a, b) {
    final aTime = a.lastMessage?.createdAt ?? DateTime(1970);
    final bTime = b.lastMessage?.createdAt ?? DateTime(1970);
    return bTime.compareTo(aTime);
  });
  
  return roomsWithLastMessage.map((e) => e.room).toList();
});

// Unread messages status provider
final hasUnreadMessagesProvider = Provider.family<bool, String>((ref, roomId) {
  final messages = ref.watch(roomMessagesProvider(roomId));
  if (messages.isEmpty) return false;
  
  // Check if there are any unread messages from the other user
  return messages.any((msg) => 
    !msg.isRead && msg.senderId != ref.read(currentUserIdProvider)
  );
});

// Current user ID provider (you'll need to implement this based on your auth system)
final currentUserIdProvider = Provider<String>((ref) {
  // TODO: Implement this based on your authentication system
  return 'user1';
});

