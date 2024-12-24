import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/view/root_tab.dart';
import 'package:livingalone/common/view/splash_screen.dart';
import 'package:livingalone/user/view/login_screen.dart';
import 'package:livingalone/user/view/signup_screen.dart';
import 'package:livingalone/user/view/terms_detail_screen.dart';
import 'package:livingalone/user/view/terms_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context,ref) {
    // final router = ref.watch(routerProvider);
    // return MaterialApp.router(
    //     debugShowCheckedModeBanner: false,
    //     routerConfig: MyApp()._router,
    //     title: 'Living Alone',
    // );
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'SUIT',
      ),
      debugShowCheckedModeBanner: false,
      home: RootTab(),
    );
  }
}