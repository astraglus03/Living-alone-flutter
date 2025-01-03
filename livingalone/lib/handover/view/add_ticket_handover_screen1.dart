import 'package:flutter/material.dart';
import 'package:livingalone/handover/view/add_handover_base_screen1.dart';
import 'package:livingalone/handover/view/add_ticket_handover_screen2.dart';
import 'package:livingalone/home/component/post_type.dart';

class AddTicketHandoverScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AddHandoverBaseScreen1(
      type: PostType.ticket,
      nextScreen: AddTicketHandoverScreen2(),
    );
  }
}
