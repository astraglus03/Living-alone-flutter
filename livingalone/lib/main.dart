import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/common/view/root_tab.dart';
import 'package:livingalone/handover/view/add_room_handover_screen1.dart';
import 'package:livingalone/handover/view/add_room_handover_screen2.dart';
import 'package:livingalone/handover/view/add_room_handover_screen3.dart';
import 'package:livingalone/handover/view/add_room_handover_screen4.dart';
import 'package:livingalone/handover/view/add_room_handover_screen6.dart';
import 'package:livingalone/handover/view/add_room_handover_screen7.dart';
import 'package:livingalone/handover/view/add_room_handover_screen8.dart';
import 'package:livingalone/handover/view/add_ticket_handover_screen1.dart';
import 'package:livingalone/handover/view/add_ticket_handover_screen2.dart';
import 'package:livingalone/handover/view/add_ticket_handover_screen4.dart';
import 'package:livingalone/handover/view/add_ticket_handover_screen6.dart';
import 'package:livingalone/post_modify/view/edit_room_post_screen.dart';
import 'package:livingalone/home/view/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:livingalone/home/view/living_detail_screen.dart';
import 'package:livingalone/report/report_screen.dart';
import 'package:livingalone/user/view/login_screen.dart';
import 'package:livingalone/user/view/redesign_password_screen.dart';
import 'package:livingalone/user/view/signup_authentication_screen.dart';
import 'package:livingalone/user/view/signup_nickname_screen.dart';
import 'package:livingalone/user/view/signup_setting_password_screen.dart';
import 'package:livingalone/user/view/signup_terms_screen.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 가로모드로 하게되면 심각한 overflow와 폰트, 깨짐. 모든 반은형으로 하기전까지 코드 필수.
  SystemChrome.setPreferredOrientations(([
    DeviceOrientation.portraitUp
  ]));
  initializeDateFormatting('ko_KR').then((_) => runApp(ProviderScope(child:MyApp())));
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
            // home: LivingDetailScreen(postType: PostType.ticket, postId: '10',),
            home: RootTab()
            // home: AddRoomHandoverScreen7(rentType: RentType.shortRent,),
            // home: AddTicketHandoverScreen2()
          ),
        );
      }
    );
  }
}