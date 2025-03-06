import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/mypage/models/nickname_check_response.dart';
import 'package:livingalone/user/models/user_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:livingalone/common/const/const.dart';
import 'package:livingalone/common/dio/dio.dart';

part 'mypage_repository.g.dart';

final myPageRepositoryProvider = Provider<MyPageRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MyPageRepository(dio, baseUrl: 'http://$ip/api/v1/mypage');
});

@RestApi()
abstract class MyPageRepository {
  factory MyPageRepository(Dio dio, {String baseUrl}) = _MyPageRepository;


}