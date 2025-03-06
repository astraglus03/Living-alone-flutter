// lib/mypage/repository/notice_repository.dart
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/const/const.dart';
import 'package:livingalone/common/dio/dio.dart';
import 'package:livingalone/mypage/models/notice_model.dart';
import 'package:retrofit/retrofit.dart';

part 'notice_repository.g.dart';

final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return NoticeRepository(dio, baseUrl: 'http://$ip/api/v1/notices');
});

@RestApi()
abstract class NoticeRepository {
  factory NoticeRepository(Dio dio, {String baseUrl}) = _NoticeRepository;

  @GET('')
  Future<List<NoticeModel>> getNotices();

  @GET('/{id}')
  Future<NoticeModel> getNoticeDetail({
    @Path() required String id,
  });
}

// 더미 데이터용 Repository
class DummyNoticeRepository implements NoticeRepository {
  @override
  Future<List<NoticeModel>> getNotices() async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      NoticeModel(
        id: '1',
        title: '[공지]시스템 점검 안내',
        content: '더 나은 서비스를 위해 2025년 2월 3일(월) 오전 2시부터 5시까지 시스템 점검이 진행됩니다.\n\n이 시간 동안 앱 이용이 제한될 수 있으니 양해 부탁드립니다. 점검 후 더욱 편리한 서비스를 제공하겠습니다.\n\n감사합니다.',
        createdAt: DateTime.parse('2024-01-17'),
      ),
      NoticeModel(
        id: '2',
        title: '[공지]개인정보처리방침 변경 예정',
        content: '개인정보처리방침이 변경될 예정입니다...',
        createdAt: DateTime.parse('2024-01-12'),
      ),
      NoticeModel(
        id: '3',
        title: '[새소식]새로운 기능 업데이트 안내',
        content: '새로운 기능이 추가되었습니다...',
        createdAt: DateTime.parse('2024-01-01'),
      ),
    ];
  }

  @override
  Future<NoticeModel> getNoticeDetail({required String id}) async {
    await Future.delayed(Duration(milliseconds: 500));
    return NoticeModel(
      id: id,
      title: '[공지]시스템 점검 안내',
      content: '더 나은 서비스를 위해 2025년 2월 3일(월) 오전 2시부터 5시까지 시스템 점검이 진행됩니다.\n\n이 시간 동안 앱 이용이 제한될 수 있으니 양해 부탁드립니다. 점검 후 더욱 편리한 서비스를 제공하겠습니다.\n\n감사합니다.',
      createdAt: DateTime.parse('2024-01-17'),
    );
  }
}