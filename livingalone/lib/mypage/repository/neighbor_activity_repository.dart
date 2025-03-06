import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/mypage/models/neighbor_activity_model.dart';

// TODO: API 연동 시 사용할 코드
// import 'package:dio/dio.dart' hide Headers;
// import 'package:retrofit/retrofit.dart';
// import 'package:livingalone/common/const/const.dart';
// 
// part 'neighbor_activity_repository.g.dart';
//
// final neighborActivityRepositoryProvider = Provider<NeighborActivityRepository>((ref) {
//   final dio = ref.watch(dioProvider);
//   return NeighborActivityRepository(dio, baseUrl: 'http://$ip/api/v1');
// });
//
// @RestApi()
// abstract class NeighborActivityRepository {
//   factory NeighborActivityRepository(Dio dio, {String baseUrl}) = _NeighborActivityRepository;
// 
//   @GET('/neighbor/activities')
//   Future<List<NeighborActivityModel>> getActivities({
//     @Query('type') String? type,
//   });
// 
//   @POST('/neighbor/activities/{id}/like')
//   Future<void> toggleLike(@Path() String id);
// }

// TODO: API 연동 시 사용할 코드
// final neighborActivityRepositoryProvider = Provider<NeighborActivityRepository>((ref) {
//   final dio = ref.watch(dioProvider);
//   return NeighborActivityRepository(dio, baseUrl: 'http://$ip/api/v1');
// });

// Repository Provider (더미데이터용)
final neighborActivityRepositoryProvider = Provider<NeighborActivityRepository>((ref) {
  return NeighborActivityRepository();
});

class NeighborActivityRepository {
  final List<NeighborActivityModel> _activities = [
    NeighborActivityModel(
      id: '1',
      title: '안서동 맛집 추천해주세요!',
      content: '안서동에 새로 이사왔는데 맛집 추천 부탁드립니다~\n회사 동료들과 같이 가기 좋은 곳이면 더 좋을 것 같아요!',
      location: '안서동',
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
      viewCount: 45,
      commentCount: 12,
      likeCount: 8,
      isLiked: true,
      category: '동네맛집',
      username: '안서동주민',
      isMyPost: true,
      isParticipated: false,
    ),
    NeighborActivityModel(
      id: '2',
      title: '안서동 헬스장 같이 다니실 분!',
      content: '안서동에서 같이 헬스장 다니실 분 구해요~ 저는 주 4회 저녁에 운동하고 있어요.',
      location: '안서동',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      viewCount: 32,
      commentCount: 5,
      likeCount: 3,
      isLiked: false,
      category: '취미생활',
      username: '운동하는청년',
      isMyPost: false,
      isParticipated: true,
      thumbnailUrl: 'https://picsum.photos/200',
    ),
    NeighborActivityModel(
      id: '3',
      title: '안서동 신호등 공사 언제 끝나나요?',
      content: '안서동 사거리 신호등 공사가 한달째 진행중인데 혹시 언제 끝나는지 아시는 분 계신가요?',
      location: '안서동',
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      viewCount: 128,
      commentCount: 15,
      likeCount: 22,
      isLiked: true,
      category: '동네질문',
      username: '궁금이',
      isMyPost: false,
      isParticipated: true,
    ),
  ];

  Future<List<NeighborActivityModel>> getActivities({String? type}) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (type == 'my') {
      return _activities.where((activity) => activity.isMyPost).toList();
    } else if (type == 'participated') {
      return _activities.where((activity) => activity.isParticipated).toList();
    }
    return _activities;
  }

  Future<void> toggleLike(String id) async {
    await Future.delayed(Duration(milliseconds: 300));
    final index = _activities.indexWhere((activity) => activity.id == id);
    if (index != -1) {
      final activity = _activities[index];
      _activities[index] = NeighborActivityModel(
        id: activity.id,
        title: activity.title,
        content: activity.content,
        location: activity.location,
        createdAt: activity.createdAt,
        viewCount: activity.viewCount,
        commentCount: activity.commentCount,
        likeCount: activity.isLiked ? activity.likeCount - 1 : activity.likeCount + 1,
        isLiked: !activity.isLiked,
        thumbnailUrl: activity.thumbnailUrl,
        category: activity.category,
        username: activity.username,
        userProfileUrl: activity.userProfileUrl,
        isMyPost: activity.isMyPost,
        isParticipated: activity.isParticipated,
      );
    }
  }
} 