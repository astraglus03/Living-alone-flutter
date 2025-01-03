import 'package:flutter/material.dart';
import 'package:livingalone/handover/view/add_room_handover_screen1.dart';
import 'package:livingalone/handover/view/check_handover_base_screen.dart';
import 'package:livingalone/home/component/post_type.dart';

class CheckRoomHandoverScreen extends StatelessWidget {
  static String get routeName => 'roomHandoverCheck';

  @override
  Widget build(BuildContext context) {
    return CheckHandoverBaseScreen(
      type: PostType.room,
      nextScreen: AddRoomHandoverScreen1(),
    );
  }
} 