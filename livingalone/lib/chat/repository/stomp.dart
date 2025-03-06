// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:stomp_dart_client/stomp_dart_client.dart';
// import '../models/chat_room_model.dart';
//
// class ChatSocket {
//   late StompClient _stompClient;
//   Function(ChatRoom)? onNewChatRoom;
//
//   ChatSocket() {
//     _stompClient = StompClient(
//       config: StompConfig(
//         url: 'wss://yourapi.com/ws',
//         onConnect: _onConnect,
//       ),
//     );
//     _stompClient.activate();
//   }
//
//   void _onConnect(StompFrame frame) {
//     _stompClient.subscribe(
//       destination: '/topic/chatrooms',
//       callback: (frame) {
//         if (frame.body != null) {
//           final newChatRoom = ChatRoom.fromJson(frame.body!);
//           if (onNewChatRoom != null) {
//             onNewChatRoom!(newChatRoom);
//           }
//         }
//       },
//     );
//   }
//
//   void listen(Function(ChatRoom) callback) {
//     onNewChatRoom = callback;
//   }
// }
//
// final chatSocketProvider = Provider((ref) => ChatSocket());
