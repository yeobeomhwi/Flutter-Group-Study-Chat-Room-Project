import 'package:app_team2/Screen/filteringRoom/s_certificateScreen.dart';
import 'package:app_team2/Screen/filteringRoom/s_designScreen.dart';
import 'package:app_team2/Screen/filteringRoom/s_engScreen.dart';
import 'package:app_team2/Screen/filteringRoom/s_filteringMainScreen.dart';
import 'package:app_team2/Screen/filteringRoom/s_mathScreen.dart';
import 'package:app_team2/Screen/filteringRoom/s_programScreen.dart';
import 'package:app_team2/Screen/filteringRoom/s_readingScreen.dart';
import 'package:app_team2/Screen/filteringRoom/s_scienceScreen.dart';
import 'package:app_team2/Screen/filteringRoom/s_sportsScreen.dart';
import 'package:app_team2/Screen/s_chatScreen.dart';
import 'package:app_team2/Screen/s_createRoom.dart';
import 'package:app_team2/Screen/s_loginScreen.dart';
import 'package:app_team2/Screen/s_mainScreen.dart';
import 'package:app_team2/Screen/s_registrationScreen.dart';
import 'package:app_team2/router/r_routerObservser.dart';
import 'package:go_router/go_router.dart';

class CustomRouter {
  static GoRouter router = GoRouter(initialLocation: "/Login", observers: [
    RouterObserver()
  ], routes: [
    GoRoute(path: "/Login", builder: (context, state) => LoginScreen()),
    GoRoute(path: "/Main", builder: (context, state) => const MainScreen()),
    GoRoute(
        path: "/Chat",
        builder: (context, state) {
          return ChatScreen(
              room: (state.extra as Map<String, dynamic>)['room'],
              roomId: (state.extra as Map<String, dynamic>)['roomId']);
        }),
    GoRoute(
        path: "/CreateRoom",
        builder: (context, state) => const CreateRoomPage()),
    GoRoute(
        path: "/Registration",
        builder: (context, state) => RegistrationScreen()),
    GoRoute(
        path: "/Certificate",
        builder: (context, state) => const CertificateScreen()),
    GoRoute(
      path: "/Filtering",
      builder: (context, state) => const FilteringMainScreen(),
    ),
    GoRoute(
        path: "/Certificate",
        builder: (context, state) => const CertificateScreen()),
    GoRoute(path: "/Design", builder: (context, state) => const DesignScreen()),
    GoRoute(path: "/Eng", builder: (context, state) => const EngScreen()),
    GoRoute(path: "/Math", builder: (context, state) => const MathScreen()),
    GoRoute(
        path: "/Program", builder: (context, state) => const ProgramScreen()),
    GoRoute(
        path: "/Reading", builder: (context, state) => const ReadingScreen()),
    GoRoute(
        path: "/Science", builder: (context, state) => const ScienceScreen()),
    GoRoute(path: "/Sports", builder: (context, state) => const SportsScreen()),
  ]);
}
