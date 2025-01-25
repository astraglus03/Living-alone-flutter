import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/const/const.dart';
import 'package:livingalone/common/dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:livingalone/neighbor/models/post_community_model.dart';
part 'community_repository.g.dart';


final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = CommunityRepository(dio,baseUrl:'http://$ip/community');

  return repository;
});

@RestApi()
abstract class CommunityRepository {
  factory CommunityRepository(Dio dio, {String baseUrl}) = _CommunityRepository;

  // // 1. 커뮤니티 목록 조회
  // @GET("/communities")
  // Future<List<CommunityModel>> getCommunities({
  //   @Query("address") required String address,
  // });
  //
  // // 2. 커뮤니티 게시글 조회
  // @GET("/communities/{communityId}/posts")
  // Future<List<PostModel>> getPosts({
  //   @Path("communityId") required String communityId,
  // });

  // 3. 게시글 작성
  @POST("/communities/{communityId}/posts")
  @Headers({"accessToken": "true"}) // 헤더 추가 가능
  Future<void> createPost({
    @Path("communityId") required String communityId,
    @Body() required PostCommunityModel body,
  });

  // // 4. 게시글 수정
  // @PUT("/communities/{communityId}/posts/{postId}")
  // Future<void> updatePost({
  //   @Path("communityId") required String communityId,
  //   @Path("postId") required String postId,
  //   @Body() required PostCommunityModel body,
  // });

  // 5. 게시글 삭제
  // @DELETE("/communities/{communityId}/posts/{postId}")
  // Future<void> deletePost({
  //   @Path("communityId") required String communityId,
  //   @Path("postId") required String postId,
  // });
}
