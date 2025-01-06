import 'package:flutter/material.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/handover/view/add_handover_base_screen1.dart';
import 'package:livingalone/handover/view/add_room_handover_screen2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/handover/view_models/handover_check_provider.dart';
import 'package:livingalone/handover/view/check_handover_base_screen.dart';

class AddRoomHandoverScreen1 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AddHandoverBaseScreen1(
      type: PostType.room,
      nextScreen: AddRoomHandoverScreen2(),
    );
  }
}
