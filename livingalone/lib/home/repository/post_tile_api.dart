import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/post_tile_model.dart';

part 'post_tile_api.g.dart'; // Build runner가 생성할 파일

@RestApi(baseUrl: "https://api.example.com")
abstract class PostApi {
  factory PostApi(Dio dio, {String baseUrl}) = _PostApi;

  @GET("/posts")
  Future<List<Post>> getPosts(@Query("page") int page, @Query("limit") int limit);

  @POST("/posts")
  Future<void> createPost(@Body() Post post);

  @PUT("/posts/{id}")
  Future<void> updatePost(@Path("id") String id, @Body() Post post);

  @DELETE("/posts/{id}")
  Future<void> deletePost(@Path("id") String id);
}
