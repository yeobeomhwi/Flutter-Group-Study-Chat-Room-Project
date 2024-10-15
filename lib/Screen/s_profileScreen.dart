import 'package:app_team2/services/sv_userService.dart';
import 'package:app_team2/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserService>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SafeArea(
          child: Center(
              child: Column(
        children: [
          Image.asset('assets/images/splash/group_study.png',
              width: MediaQuery.of(context).size.width * 0.5),
          Text('${userProvider.userSnapshot!['name']}'),
          const Text('예약한 방 목록'),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: primary_color),
                child:
                    const Text('이름 변경', style: TextStyle(color: Colors.white))),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: primary_color),
                child: const Text('프로필 사진 변경',
                    style: TextStyle(color: Colors.white))),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ElevatedButton(
                onPressed: () async {
                  await UserService.instance.logout();
                  GoRouter.of(context).go('/Login');
                },
                style: ElevatedButton.styleFrom(backgroundColor: primary_color),
                child:
                    const Text('로그아웃', style: TextStyle(color: Colors.white))),
          ),
        ],
      ))),
    );
  }
}
