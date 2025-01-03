import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/room_filter_model.dart';


final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(FilterState());

  void updateFilter(FilterState newState) {
    state = newState;
  }

  void resetFilter() {
    state = FilterState();
  }
}
