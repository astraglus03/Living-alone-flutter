import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/const/const.dart';
import 'package:livingalone/common/dio/dio.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/mypage/models/favorite_model.dart';
import 'package:retrofit/retrofit.dart';

part 'favorite_repository.g.dart';

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return FavoriteRepository(dio, baseUrl: 'http://$ip/api/v1/favorites');
});

@RestApi()
abstract class FavoriteRepository {
  factory FavoriteRepository(Dio dio, {String baseUrl}) = _FavoriteRepository;

  // 찜 목록 조회
  @GET('')
  Future<List<FavoriteModel>> getFavorites({
    @Query('type') String? type,
  });

  // 찜하기
  @POST('/{itemId}')
  Future<FavoriteModel> addFavorite({
    @Path() required String itemId,
    @Query('type') required String type,
  });

  // 찜 취소
  @DELETE('/{itemId}')
  Future<void> removeFavorite({
    @Path() required String itemId,
    @Query('type') required String type,
  });
}

// 더미 데이터용 Provider
final dummyFavoriteRepositoryProvider = Provider<DummyFavoriteRepository>((ref) {
  return DummyFavoriteRepository();
});

class DummyFavoriteRepository implements FavoriteRepository {
  final List<FavoriteModel> _favorites = [
    // 자취방 더미 데이터
    FavoriteModel(
      id: '1',
      itemId: '1',
      type: PostType.room,
      title: '노블하우스빌',
      thumbnailUrl: 'https://picsum.photos/200',
      isTransferred: false,
      location: '안서동',
      buildingType: '오피스텔',
      propertyType: '투룸',
      rentType: '단기',
      deposit: 500,
      monthlyRent: 50,
      maintenance: 5,
      viewCount: 23,
      commentCount: 4,
      chatCount: 1,
      createdAt: DateTime.now().subtract(Duration(hours: 1, minutes: 10)),
      isFavorite: true,
    ),
    // 이용권 더미 데이터
    FavoriteModel(
      id: '2',
      itemId: '2',
      type: PostType.ticket,
      title: '미녀와야수짐 안서점',
      thumbnailUrl: 'https://picsum.photos/200',
      isTransferred: false,
      location: '안서동',
      ticketType: '헬스PT',
      viewCount: 23,
      commentCount: 4,
      chatCount: 1,
      createdAt: DateTime.now().subtract(Duration(hours: 1, minutes: 10)),
      isFavorite: true,
    ),
    // 자취방 더미 데이터 (양도완료)
    FavoriteModel(
      id: '3',
      itemId: '3',
      type: PostType.room,
      title: '안서동보아파트 101동',
      thumbnailUrl: 'https://picsum.photos/200',
      isTransferred: true,
      location: '안서동',
      buildingType: '아파트',
      propertyType: '원룸',
      rentType: '월세',
      deposit: 500,
      monthlyRent: 35,
      maintenance: 5,
      viewCount: 23,
      commentCount: 4,
      chatCount: 1,
      createdAt: DateTime.now().subtract(Duration(hours: 1, minutes: 10)),
      isFavorite: true,
    ),
  ];

  @override
  Future<List<FavoriteModel>> getFavorites({String? type}) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (type != null) {
      return _favorites
          .where((favorite) => favorite.type.toString() == type)
          .toList();
    }
    return _favorites;
  }

  @override
  Future<FavoriteModel> addFavorite({
    required String itemId,
    required String type,
  }) async {
    await Future.delayed(Duration(milliseconds: 500));
    final favorite = FavoriteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      itemId: itemId,
      type: PostType.values.firstWhere(
        (e) => e.toString() == type,
      ),
      title: '새로운 찜 아이템',
      isTransferred: false,
      location: '안서동',
      viewCount: 0,
      commentCount: 0,
      chatCount: 0,
      createdAt: DateTime.now(),
      isFavorite: true,
    );
    _favorites.add(favorite);
    return favorite;
  }

  @override
  Future<void> removeFavorite({
    required String itemId,
    required String type,
  }) async {
    await Future.delayed(Duration(milliseconds: 500));
    _favorites.removeWhere((favorite) => favorite.itemId == itemId);
  }
} 