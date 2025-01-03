
import 'package:flutter_riverpod/flutter_riverpod.dart';


final boardTabProvider = StateNotifierProvider<BoardTabNotifier, int>((ref) {
  return BoardTabNotifier();
});

class BoardTabNotifier extends StateNotifier<int> {
  BoardTabNotifier() : super(0);

  void changeTab(int index) {
    state = index;
  }
}
