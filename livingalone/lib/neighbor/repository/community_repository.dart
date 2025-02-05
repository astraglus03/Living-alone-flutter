import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/const/const.dart';
import 'package:livingalone/common/dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:livingalone/neighbor/models/post_community_model.dart';
import 'package:livingalone/neighbor/models/post_detail_model.dart';
part 'community_repository.g.dart';

// 실제 API 연동 시 사용할 Provider
final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  // return CommunityRepository(ref.watch(dioProvider), baseUrl: 'https://$ip/community');
  // 현재는 더미 데이터 사용
  return DummyCommunityRepository();
});

// API 연동 전 더미 데이터를 위한 구현체
class DummyCommunityRepository implements CommunityRepository {
  @override
  Future<void> createPost({
    required String communityId,
    required PostCommunityModel body,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  @override
  Future<void> deletePost({
    required String communityId,
    required String postId,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  @override
  Future<PostDetailModel> getPostDetail({
    required String communityId,
    required String postId,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    return PostDetailModel.getDummy();
  }

  @override
  Future<void> likePost({
    required String communityId,
    required String postId,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  @override
  Future<void> unlikePost({
    required String communityId,
    required String postId,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  @override
  Future<void> updatePost({
    required String communityId,
    required String postId,
    required PostCommunityModel body,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  @override
  Future<String> uploadImage({
    required String communityId,
    required String filePath,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    return 'https://picsum.photos/200/300';
  }
}

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
  @Headers({"accessToken": "true"})
  Future<void> createPost({
    @Path("communityId") required String communityId,
    @Body() required PostCommunityModel body,
  });

  // 4. 게시글 수정
  @PUT("/communities/{communityId}/posts/{postId}")
  @Headers({"accessToken": "true"})
  Future<void> updatePost({
    @Path("communityId") required String communityId,
    @Path("postId") required String postId,
    @Body() required PostCommunityModel body,
  });

  // 5. 게시글 삭제
  @DELETE("/communities/{communityId}/posts/{postId}")
  @Headers({"accessToken": "true"})
  Future<void> deletePost({
    @Path("communityId") required String communityId,
    @Path("postId") required String postId,
  });

  // 게시글 상세 조회
  @GET("/communities/{communityId}/posts/{postId}")
  Future<PostDetailModel> getPostDetail({
    @Path("communityId") required String communityId,
    @Path("postId") required String postId,
  });

  // 게시글 좋아요
  @POST("/communities/{communityId}/posts/{postId}/like")
  @Headers({"accessToken": "true"})
  Future<void> likePost({
    @Path("communityId") required String communityId,
    @Path("postId") required String postId,
  });

  // 게시글 좋아요 취소
  @DELETE("/communities/{communityId}/posts/{postId}/like")
  @Headers({"accessToken": "true"})
  Future<void> unlikePost({
    @Path("communityId") required String communityId,
    @Path("postId") required String postId,
  });

  // 이미지 업로드
  @POST("/communities/{communityId}/posts/images")
  @Headers({"accessToken": "true"})
  Future<String> uploadImage({
    @Path("communityId") required String communityId,
    @Part() required String filePath,
  });
}
