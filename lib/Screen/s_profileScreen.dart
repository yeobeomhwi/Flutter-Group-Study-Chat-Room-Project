import 'package:app_team2/services/sv_userService.dart';
import 'package:app_team2/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../components/dialog/di_changeNameDialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  String? _profileImageUrl; // 프로필 이미지 URL
  String? _userName; // 사용자 이름

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // 사용자 데이터 가져오기
  }

  // Firestore에서 사용자 이름과 프로필 이미지 가져오기
  Future<void> _fetchUserData() async {
    try {
      final userData =
          await _userService.getUserNameImage(); // Firestore에서 데이터 가져오기
      setState(() {
        _profileImageUrl = userData['profileimage']; // 프로필 이미지 URL 저장
        _userName = userData['name']; // 사용자 이름 저장
      });
    } catch (e) {
      print('사용자 데이터를 가져오는 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserService>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 프로필 이미지를 ClipOval로 감싸서 원형으로 만들기
              ClipOval(
                child: _profileImageUrl != null // 이미지 URL이 null이 아니면 출력
                    ? Image.network(
                        _profileImageUrl!,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height:
                            MediaQuery.of(context).size.width * 0.5, // 높이 추가
                        fit: BoxFit.cover, // 이미지 비율 유지
                      )
                    : Image.asset(
                        'assets/default_profile.png', // 기본 이미지
                        width: MediaQuery.of(context).size.width * 0.5,
                        height:
                            MediaQuery.of(context).size.width * 0.5, // 높이 추가
                        fit: BoxFit.cover, // 이미지 비율 유지
                      ),
              ),

              const SizedBox(height: 10),
              // 사용자 이름 표시
              Text(_userName ?? 'Loading...',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () => ChangeNameDialog.show(
                      context, _userService, _fetchUserData), // 모달 호출
                  style:
                      ElevatedButton.styleFrom(backgroundColor: primary_color),
                  child: const Text('이름 변경',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () async {
                    await _userService.updateProfileImage(); // 프로필 사진 변경 기능 추가
                    await _fetchUserData(); // 사용자 데이터 다시 가져오기
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: primary_color),
                  child: const Text('프로필 사진 변경',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () async {
                    await UserService.instance.logout();
                    GoRouter.of(context).go('/Login');
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: primary_color),
                  child:
                      const Text('로그아웃', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
