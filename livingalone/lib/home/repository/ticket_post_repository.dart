import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ticket_post_model.dart';

final ticketPostRepositoryProvider = Provider<TicketPostRepository>((ref) {
  return TicketPostRepository();
});

class TicketPostRepository {
  Future<List<TicketPost>> fetchPosts(int page) async {
    // API 연동 전 더미 데이터 반환
    return List.generate(
      10,
      (index) => TicketPost(
        id: 'ticket-$index',
        title: '헬스장 3개월 이용권',
        likes: index * 2,
        comments: index * 3,
        scraps: index,
        createdAt: DateTime.now().subtract(Duration(hours: index)), subTitle1: '양도완료', subTitle2: '안서동', subTitle3: '스터디 카페', subTitle4: '20일',
      ),
    );
  }
} 