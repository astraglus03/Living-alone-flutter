import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ticket_filter_model.dart';

final ticketFilterProvider = StateNotifierProvider<TicketFilterNotifier, TicketFilterState>((ref) {
  return TicketFilterNotifier();
});

class TicketFilterNotifier extends StateNotifier<TicketFilterState> {
  TicketFilterNotifier() : super(TicketFilterState());

  void updateFilter(TicketFilterState newState) {
    state = newState;
  }

  void resetFilter() {
    state = TicketFilterState();
  }
} 