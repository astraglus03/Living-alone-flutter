import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/const/const.dart';
import 'package:livingalone/common/dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:livingalone/neighbor/models/neighbor_comment_model.dart';

part 'neighbor_comment_repository.g.dart';

final CommunityCommentRepositoryProvider = Provider.family<NeighborCommentRepository, String>((ref, id){
  final dio = ref.watch(dioProvider);

  return NeighborCommentRepository(dio, baseUrl: 'https://$ip/neighbor/$id/comment');
});

// 더미 데이터 Provider
final dummyCommentRepositoryProvider = Provider<DummyCommentRepository>((ref) {
  return DummyCommentRepository();
});

@RestApi()
abstract class NeighborCommentRepository {
  factory NeighborCommentRepository(Dio dio, {String baseUrl}) = _NeighborCommentRepository;

  @GET('/')
  Future<List<NeighborCommentModel>> getComments(@Path() String postId);

  @POST('/')
  Future<NeighborCommentModel> createComment(
    @Path() String postId,
    @Body() Map<String, dynamic> body,
  );

  @POST('/{commentId}/replies')
  Future<NeighborCommentModel> createReply(
    @Path() String postId,
    @Path() String commentId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/{commentId}')
  Future<void> deleteComment(
    @Path() String postId,
    @Path() String commentId,
  );

  @DELETE('/{commentId}/replies/{replyId}')
  Future<void> deleteReply(
    @Path() String postId,
    @Path() String commentId,
    @Path() String replyId,
  );
}

// 더미 데이터를 위한 별도 클래스
class DummyCommentRepository {
  Future<List<NeighborCommentModel>> getDummyComments(String postId) async {
    return NeighborCommentModel.getDummyComments();
  }

  Future<NeighborCommentModel> createDummyComment(
    String postId,
    Map<String, dynamic> body,
  ) async {
    return NeighborCommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: body['username'] as String,
      content: body['content'] as String,
      time: DateTime.now().toString(),
      isAuthor: true,
      userProfileUrl: "https://picsum.photos/50/53",
    );
  }

  Future<NeighborCommentModel> createDummyReply(
    String postId,
    String commentId,
    Map<String, dynamic> body,
  ) async {
    return NeighborCommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: body['username'] as String,
      content: body['content'] as String,
      time: DateTime.now().toString(),
      isAuthor: true,
      userProfileUrl: "https://picsum.photos/50/54",
    );
  }
} 