import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/mypage/models/handover_history_model.dart';

final handoverHistoryRepositoryProvider = Provider<HandoverHistoryRepository>((ref) {
  return HandoverHistoryRepository();
});

// TODO: API 연동 시 사용할 코드
// import 'package:dio/dio.dart';
// import 'package:retrofit/retrofit.dart';
// part 'handover_history_repository.g.dart';
// 
// @RestApi()
// abstract class HandoverHistoryRepository {
//   factory HandoverHistoryRepository(Dio dio, {String baseUrl}) = _HandoverHistoryRepository;
// 
//   @GET('/handover/history')
//   Future<List<HandoverHistoryModel>> getHandoverHistory({
//     @Query('type') String? type,
//   });
// 
//   @DELETE('/handover/history/{id}')
//   Future<void> deleteHandoverHistory(
//     @Path('id') String itemId,
//   );
// 
//   @PUT('/handover/history/{id}/transfer')
//   Future<void> completeHandover(
//     @Path('id') String itemId,
//   );
// }



class HandoverHistoryRepository {
  Future<List<HandoverHistoryModel>> getHandoverHistory({String? type}) async {
    await Future.delayed(Duration(seconds: 1)); // 로딩 시뮬레이션

    final List<HandoverHistoryModel> dummyData = [
      HandoverHistoryModel(
        itemId: '1',
        title: '안서동보아파트 101동',
        location: '안서동',
        type: PostType.room,
        thumbnailUrl: 'https://picsum.photos/200',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        viewCount: 23,
        commentCount: 4,
        chatCount: 1,
        isTransferred: true,
        buildingType: '아파트',
        propertyType: '단기임대',
        rentType: RentType.shortRent.label,
        deposit: 500,
        monthlyRent: 40,
      ),
      HandoverHistoryModel(
        itemId: '2',
        title: '헬스장 이용권 양도',
        location: '신부동',
        type: PostType.ticket,
        thumbnailUrl: 'https://picsum.photos/200',
        createdAt: DateTime.now().subtract(Duration(hours: 2)),
        viewCount: 15,
        commentCount: 2,
        chatCount: 3,
        isTransferred: false,
        ticketType: '헬스장 회원권',
        remainingDays: 30,
        price: 50000,
      ),
      HandoverHistoryModel(
        itemId: '3',
        title: '신부동 원룸',
        location: '안서동',
        type: PostType.room,
        thumbnailUrl: 'https://picsum.photos/200',
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        viewCount: 45,
        commentCount: 6,
        chatCount: 2,
        isTransferred: false,
        buildingType: '아파트',
        propertyType: '원룸',
        rentType: '전세',
        deposit: 3000,
      ),
    ];

    if (type != null) {
      return dummyData.where((item) => item.type.toString() == type).toList();
    }
    return dummyData;
  }

  Future<void> deleteHandoverHistory(String itemId) async {
    await Future.delayed(Duration(milliseconds: 500)); // 딜레이 시뮬레이션
  }

  Future<void> completeHandover(String itemId) async {
    await Future.delayed(Duration(milliseconds: 500)); // 딜레이 시뮬레이션
  }
} 