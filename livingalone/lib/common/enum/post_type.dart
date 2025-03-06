enum PostType {
  room,
  ticket;

  String get label {
    switch (this) {
      case PostType.room:
        return '자취방';
      case PostType.ticket:
        return '이용권';
    }
  }
}
