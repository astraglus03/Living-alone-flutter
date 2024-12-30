import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/home/repository/post_tile_api.dart';

import '../models/post_tile_model.dart';


final postRepositoryProvider = Provider<PostRepository>((ref) {
  final dio = Dio();
  final api = PostApi(dio);
  return PostRepository(api);
});

class PostRepository {
  final PostApi _api;

  PostRepository(this._api);

  Future<List<Post>> fetchPosts(int page) async {
    try {
      return await _api.getPosts(page, 10);
    } catch (e) {
      return _dummyPosts;
    }
  }

  Future<void> createPost(Post post) => _api.createPost(post);
  Future<void> updatePost(String id, Post post) => _api.updatePost(id, post);
  Future<void> deletePost(String id) => _api.deletePost(id);

  // 더미 데이터
  final List<Post> _dummyPosts = List.generate(
    10,
        (index) => Post(
      id: 'dummy-$index',
      thumbnailUrl: 'https://picsum.photos/80/80',
      title: 'Dummy Post $index',
      subTitle1: '단기',
      subTitle2: '안서동',
      subTitle3: '원룸',
      subTitle4: '월세 41',
      likes: index * 10,
      comments: index * 5,
      scraps: index * 2,
      createdAt: DateTime.now().subtract(Duration(days: index)),
    ),
  );
}
