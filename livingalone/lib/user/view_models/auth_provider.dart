import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livingalone/common/view/splash_screen.dart';
import 'package:livingalone/user/models/user_model.dart';
import 'package:livingalone/user/view/find_password_auth_screen.dart';
import 'package:livingalone/user/view/find_password_screen.dart';
import 'package:livingalone/user/view/login_screen.dart';
import 'package:livingalone/user/view/redesign_password_screen.dart';
import 'package:livingalone/user/view/reset_password_complete_screen.dart';
import 'package:livingalone/user/view/signup_authentication_screen.dart';
import 'package:livingalone/user/view/signup_nickname_screen.dart';
import 'package:livingalone/user/view/signup_phone_verify_screen.dart';
import 'package:livingalone/user/view/signup_setting_password_screen.dart';
import 'package:livingalone/user/view/signup_terms_detail_screen.dart';
import 'package:livingalone/user/view/signup_terms_screen.dart';
import 'package:livingalone/user/view_models/user_me_provider.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
    GoRoute(
      path: '/splash',
      name: SplashScreen.routeName,
      builder: (_, __) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.routeName,
      builder: (_, __) => LoginScreen(),
    ),
    GoRoute(
      path: '/terms',
      name: SignupTermsScreen.routeName,
      builder: (_, __) => SignupTermsScreen(),
    ),
    // GoRoute(
    //   path: '/termsDetail',
    //   name: SignupTermsDetailScreen.routeName,
    //   builder: (_, state) => SignupTermsDetailScreen(onRead: ),
    // ),
    GoRoute(
      path: '/authentication',
      name: SignupAuthenticationScreen.routeName,
      builder: (_, __) => SignupAuthenticationScreen(),
    ),
    GoRoute(
      path: '/phone',
      name: SignupPhoneVerifyScreen.routeName,
      builder: (_, __) => SignupPhoneVerifyScreen(),
    ),
    GoRoute(
      path: '/password',
      name: SignupSettingPasswordScreen.routeName,
      builder: (_, __) => SignupSettingPasswordScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: SignupNicknameScreen.routeName,
      builder: (_, __) => SignupNicknameScreen(),
    ),
    GoRoute(
      path: '/find-password',
      name: FindPasswordScreen.routeName,
      builder: (_, __) => FindPasswordScreen(),
    ),
    GoRoute(
      path: '/password-auth',
      name: FindPasswordAuthScreen.routeName,
      builder: (_, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return FindPasswordAuthScreen(
          email: extra['email'],
          verificationCode: extra['verificationCode'],
        );
      },
    ),
    GoRoute(
      path: '/reset-password',
      name: RedesignPasswordScreen.routeName,
      builder: (_, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return RedesignPasswordScreen(
          email: extra['email'],
          verificationCode: extra['code'],
        );
      },
    ),
    GoRoute(
      path: '/password-finish',
      name: ResetPasswordCompleteScreen.routeName,
      builder: (_, __) => ResetPasswordCompleteScreen(),
    ),
  ];

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);
    final currentPath = state.matchedLocation;

    // 로딩 중일 때
    if (user is UserModelLoading) {
      return '/splash';
    }

    // 로그인된 상태
    if (user is UserModel) {
      // 스플래시나 로그인 화면이면 메인으로
      if (currentPath == '/splash' || currentPath == '/login') {
        return '/';
      }
      return null;
    }

    // 로그인되지 않은 상태
    if (user == null || user is UserModelError) {
      // 스플래시 화면이면 로그인으로
      if (currentPath == '/splash') {
        return '/login';
      }

      // 허용된 경로들
      final allowedPaths = [
        '/login',
        '/terms',
        '/termsDetail'
        '/authentication',
        '/phone',
        '/password',
        '/profile',
        '/find-password',
        '/password-auth',
        '/reset-password',
        '/password-finish',
      ];

      // 허용되지 않은 경로면 로그인으로
      if (!allowedPaths.contains(currentPath)) {
        return '/login';
      }
    }

    return null;
  }
}
