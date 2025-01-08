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



// 이용권 유형
enum TicketType {
  health,    // 헬스장 이용권
  healthPt,      // 헬스장 PT
  pilates,      // 필라테스
  yoga,         // 요가
  swim,         // 수영
  swimLecture,   // 수영 강습
  studyRoom,     //독서실
  studyCafe,    //스터디카페
  skinCare,     //피부관리
  massage,      //마사지
  practiceRoom,  //연습실
  etc;          // 기타

  String get label {
    switch (this) {
      case TicketType.health: return '헬스장';
      case TicketType.healthPt: return '헬스PT';
      case TicketType.pilates: return '필라테스';
      case TicketType.yoga: return '요가';
      case TicketType.swim: return '수영장';
      case TicketType.swimLecture: return '수영강습';
      case TicketType.studyRoom: return '독서실';
      case TicketType.studyCafe: return '스터디카페';
      case TicketType.skinCare: return '피부관리';
      case TicketType.massage: return '마사지';
      case TicketType.practiceRoom: return '연습실';
      case TicketType.etc: return '기타';
    }
  }
}