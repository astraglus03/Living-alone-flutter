import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<User>? users;

  Future<void> loadUsers() async {
    users = await _apiService.fetchUsers();
    notifyListeners();
  }
}
