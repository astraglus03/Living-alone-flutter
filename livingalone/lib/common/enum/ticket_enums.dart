// 이용권 조건
enum LimitType {
  numberLimit,    // 횟수 제한
  timeLimit,      // 시간 제한
  periodLimit;      // 기간 제한

  String get label {
    switch (this) {
      case LimitType.numberLimit: return '횟수 제한';
      case LimitType.timeLimit: return '시간 제한';
      case LimitType.periodLimit: return '기간 제한';
    }
  }
}