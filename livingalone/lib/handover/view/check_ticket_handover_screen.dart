import 'package:flutter/material.dart';
import 'package:livingalone/handover/view/check_handover_base_screen.dart';
import 'package:livingalone/home/component/post_type.dart';
import 'package:livingalone/handover/view/add_ticket_handover_screen1.dart';


class CheckTicketHandoverScreen extends StatelessWidget {
  static String get routeName => 'ticketHandoverCheck';

  @override
  Widget build(BuildContext context) {
    return CheckHandoverBaseScreen(
      type: PostType.ticket,
      nextScreen: AddTicketHandoverScreen1(),
    );
  }
}