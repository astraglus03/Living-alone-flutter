import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'view_models/user_viewmodel.dart';
import 'views/home_page.dart';
import 'views/users_page.dart';
import 'views/settings_page.dart';
import 'views/profile_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/users', builder: (context, state) => const UsersPage()),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsPage()),
      GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
    ],
    initialLocation: '/',
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: MaterialApp.router(
        routerConfig: MyApp()._router,
        title: 'Living Alone',
      ),
    );
  }
}