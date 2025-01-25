// 이용권 유형
enum CommunityType {
  lifeConcern,    // 생활고민
  buyTogether,    // 공동구매
  requestHelp,    // 도움요청
  shareInfo,      // 정보공유
  etc;          // 기타

  String get label {
    switch (this) {
      case CommunityType.lifeConcern: return '생활고민';
      case CommunityType.buyTogether: return '공동구매';
      case CommunityType.requestHelp: return '도움요청';
      case CommunityType.shareInfo: return '정보공유';
      case CommunityType.etc: return '기타';
    }
  }
}