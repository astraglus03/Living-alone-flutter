import 'package:dio/dio.dart';
import '../models/user.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ''));

  Future<List<User>> fetchUsers() async {
    try {
      Response response = await _dio.get('/users');
      return (response.data as List).map((json) => User.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load users');
    }
  }
}
