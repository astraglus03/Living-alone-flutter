import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/const/const.dart';
import 'package:livingalone/common/dio/dio.dart';
import 'package:livingalone/mypage/models/inquiry_model.dart';
import 'package:retrofit/retrofit.dart';

part 'inquiry_repository.g.dart';

final inquiryRepositoryProvider = Provider<InquiryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return InquiryRepository(dio, baseUrl: 'http://$ip/api/v1/inquiries');
});

// 더미 데이터용 Repository Provider
final dummyInquiryRepositoryProvider = Provider<DummyInquiryRepository>((ref) {
  return DummyInquiryRepository();
});

@RestApi()
abstract class InquiryRepository {
  factory InquiryRepository(Dio dio, {String baseUrl}) = _InquiryRepository;

  @GET('')
  @Headers({
    'accessToken': 'true'
  })
  Future<List<InquiryModel>> getInquiries();

  @POST('')
  @Headers({
    'accessToken': 'true'
  })
  Future<void> createInquiry({
    @Field('category') required String category,
    @Field('title') required String title,
    @Field('content') required String content,
  });
}

// 더미 데이터를 위한 Repository
class DummyInquiryRepository implements InquiryRepository {
  @override
  Future<List<InquiryModel>> getInquiries() async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      InquiryModel(
        id: '1',
        category: '이용 문의',
        title: '앱 사용 중 오류가 발생했습니다',
        content: '어제부터 앱이 자꾸 종료되는 현상이 발생하고 있습니다.',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
      ),
      InquiryModel(
        id: '2',
        category: '계정 문의',
        title: '계정 정보 변경 문의',
        content: '학교 정보를 변경하고 싶은데 어떻게 해야 하나요?',
        createdAt: DateTime.now().subtract(Duration(days: 3)),
        answer: '안녕하세요. 고객님, 회원가입 시 선택한 학교/캠퍼스는 가입 이후 변경할 수 없습니다. 다른 학교/캠퍼스로 변경을 원하실 경우, 현재 사용하시는 계정을 탈퇴하신 후 다시 회원가입을 해주시기 바랍니다.',
        answeredAt: DateTime.now().subtract(Duration(days: 2)),
      ),
    ];
  }

  @override
  Future<void> createInquiry({
    required String category,
    required String title,
    required String content,
  }) async {
    await Future.delayed(Duration(milliseconds: 500));
    return;
  }
}