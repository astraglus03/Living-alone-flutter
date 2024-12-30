import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/view/root_tab.dart';
import 'package:livingalone/common/view/splash_screen.dart';
import 'package:livingalone/user/view/find_password_screen.dart';
import 'package:livingalone/user/view/signup_complete_screen.dart';
import 'package:livingalone/user/view/login_screen.dart';
import 'package:livingalone/user/view/signup_nickname_screen.dart';
import 'package:livingalone/user/view/signup_phone_verify_screen.dart';
import 'package:livingalone/user/view/signup_setting_password_screen.dart';
import 'package:livingalone/user/view/signup_authentication_screen.dart';
import 'package:livingalone/user/view/signup_terms_detail_screen.dart';
import 'package:livingalone/user/view/signup_terms_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,  // 텍스트 크기 자동 조정
      splitScreenMode: true,  // 분할 화면 모드
      builder:(_ ,child){
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: MaterialApp(
            theme: ThemeData(
              fontFamily: 'SUIT',
            ),
            debugShowCheckedModeBanner: false,
            home: FindPasswordScreen(),
          ),
        );
      }
    );
  }
}