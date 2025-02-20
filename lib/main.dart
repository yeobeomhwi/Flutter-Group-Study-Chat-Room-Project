import 'package:app_team2/router/r_router.dart';
import 'package:app_team2/services/sv_chatService.dart';
import 'package:app_team2/services/sv_notification.dart';
import 'package:app_team2/services/sv_userService.dart';
import 'package:app_team2/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => UserService(),
      ),
      ChangeNotifierProvider(
        create: (context) => ChatService(),
      ),
    ],
    child: const MyApp(),
  ));
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((_) {
    // Native Splash 스크린을 보존합니다.
    FlutterNativeSplash.remove();
    NotificationService.instance.permissionRequest();
    NotificationService.instance.initializeNotification();
  }).catchError((error) {
    // Firebase 초기화 실패 시 에러 처리
    // print("Firebase 초기화 실패: $error");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig: CustomRouter.router,
        title: 'alarm_app',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(color: Colors.white),
          drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
          useMaterial3: true,
        ));
  }
}
