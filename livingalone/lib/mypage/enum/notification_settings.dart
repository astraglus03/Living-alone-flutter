enum NotificationType {
  all('모든 알림 끄기', '알림 수신이 즉시 중단됩니다.'),
  chat('채팅 알림', '채팅 메시지가 도착하거나 내가 언급된 경우'),
  comment('댓글 알림', '내가 쓴 글에 댓글이 추가되거나 내가 언급된 경우'),
  neighborhoodPost('양도 알림', '관심 금액이 낮아지거나 양도가 완료된 경우'),
  community('이웃소통 알림', '이웃 소통 게시판의 인기글 확인'),
  official('공지 알림', '서비스 관련 공지사항이나 계정 상태에 대한 알림');

  final String label;
  final String description;
  const NotificationType(this.label, this.description);
}