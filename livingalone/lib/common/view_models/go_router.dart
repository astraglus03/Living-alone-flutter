import 'package:go_router/go_router.dart';
import 'package:livingalone/chat/view/chat_list_screen.dart';
import 'package:livingalone/common/view/root_tab.dart';
import 'package:livingalone/common/view/splash_screen.dart';
import 'package:livingalone/map/view/map_screen.dart';
import 'package:livingalone/mypage/view/mypage_screen.dart';
import 'package:livingalone/neighbor/view/neighbor_communication_screen.dart';
import 'package:livingalone/user/view/signup_authentication_screen.dart';
import 'package:livingalone/user/view/signup_terms_detail_screen.dart';
import 'package:livingalone/user/view/signup_terms_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: <RouteBase>[
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => SplashScreen(),
    ),
    // TODO: 토큰 만료되었을때 로그인을 다시 해야하는데 그 스크린이 현재 피그마에 없음. 생기면 주석해제 사용
    // GoRoute(
    //   path: '/login',
    //   name: 'login',
    //   builder: (context, state) => LoginScreen(),
    // ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => SignupAuthenticationScreen(),
    ),
    GoRoute(
      path: '/terms',
      name: 'terms',
      builder: (context, state) => SignupTermsScreen(),
      // routes: [
      //   GoRoute(
      //     path: 'termsDetail/:rid',
      //     name: 'termsDetail',
      //     builder: (_,state) => TermsDetailScreen(
      //       id: state.pathParameters['rid']
      //     ),
      //   ),
      // ]
    ),
    GoRoute(
      path: '/',
      name: 'rootTab',
      builder: (context, state){
        return RootTab();
      },
      // routes: [
      //   // TODO: (자취방) 스크린 제작 후 주석 해제하여 사용 할 것.
      //   GoRoute(
      //     path: 'livingRoom/:rid',
      //     name: 'livingRoomDetail',
      //     builder: (context,state) => LivingRoomDetailScreen(
      //       id: state.pathParameters['rid'],
      //     ),
      //   ),
      //   // TODO: (이용권) 스크린 제작 후 주석 해제하여 사용 할 것.
      //   GoRoute(
      //     path: 'ticket/:rid',
      //     name: 'ticketDetail',
      //     builder: (_,state) => TicketScreen(
      //       id: state.pathParameters['rid'],
      //     ),
      //   ),
      // ],
    ),
    GoRoute(
      path: '/map',
      name: 'map',
      builder: (_, state) => MapScreen(),
    ),
    GoRoute(
      path: '/neighbor',
      name: 'neighbor',
      builder: (_,state){
        return NeighborCommunicationScreen();
      }
    ),
    GoRoute(
      path: '/chat',
      name: 'chat',
      builder: (_,state){
        return ChatListScreen();
      }
    ),
    GoRoute(
      path: '/mypage',
      name: 'mypage',
      builder: (_,state){
        return MyPageScreen();
      }
    ),
  ],
  // redirect: (state) {
  //   final loggedIn = checkIfLoggedIn();
  //   final loggingIn = state.location == '/login';
  //
  //   if (!loggedIn && !loggingIn) return '/login';
  //   if (loggedIn && (state.location == '/login' || state.location == '/signup')) return '/roottab';
  //   return null;
  // },
);
