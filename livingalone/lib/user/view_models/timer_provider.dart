import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerState {
  final bool isActive;
  final int timeLeft;

  TimerState({
    required this.isActive,
    required this.timeLeft,
  });

  TimerState copyWith({
    bool? isActive,
    int? timeLeft,
  }) {
    return TimerState(
      isActive: isActive ?? this.isActive,
      timeLeft: timeLeft ?? this.timeLeft,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  Timer? _timer;
  
  TimerNotifier() : super(TimerState(isActive: false, timeLeft: 180));

  void startTimer() {
    _timer?.cancel();
    state = TimerState(isActive: true, timeLeft: 180);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft > 0) {
        state = state.copyWith(timeLeft: state.timeLeft - 1);
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    state = state.copyWith(isActive: false);
  }

  String formatTime() {
    int minutes = state.timeLeft ~/ 60;
    int seconds = state.timeLeft % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
}); 