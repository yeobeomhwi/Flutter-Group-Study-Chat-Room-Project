import 'package:app_team2/components/w_roomCard.dart';
import 'package:app_team2/services/sv_userService.dart';
import 'package:app_team2/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../components/dialog/di_changeNameDialog.dart';
import '../services/sv_chatService.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase 인증 인스턴스
  String currentUserId = ''; // 현재 로그인한 사용자 ID

  String? _profileImageUrl;
  String? _userName;
  List<dynamic>? _participationList;

  @override
  void initState() {
    super.initState();
    _userService.getCurrentUser().then((_) {
      setState(() {
        currentUserId = _userService.currentUserId; // 사용자 ID 설정
      });
      _fetchUserData();
    }).catchError((error) {
      print('사용자 정보를 가져오는 중 오류 발생: $error');
    });
  }


  Future<void> _fetchUserData() async {
    try {
      final userData = await _userService.getUserNameImage();
      setState(() {
        _profileImageUrl = userData['profileimage'];
        _userName = userData['name'];
        _participationList = userData['participationList'] != null
            ? List<dynamic>.from(userData['participationList'])
            : [];
      });
    } catch (e) {
      print('사용자 데이터를 가져오는 중 오류 발생: $e');
    }
  }

  Future<List<DocumentSnapshot>> _fetchRooms() async {
    try {
      List<DocumentSnapshot> rooms = [];
      if (_participationList != null) {
        for (String roomId in _participationList!) {
          DocumentSnapshot roomSnapshot =
              await _firestore.collection('study_rooms').doc(roomId).get();
          rooms.add(roomSnapshot);
        }
      }
      return rooms;
    } catch (e) {
      print('방 데이터를 가져오는 중 오류 발생: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ClipOval(
                child: _profileImageUrl != null
                    ? Image.network(
                        _profileImageUrl!,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/default_profile.png',
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 10),
              Text(_userName ?? 'Loading...',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),

              // 참여 방 데이터 표시
              Expanded(
                child: FutureBuilder<List<DocumentSnapshot>>(
                  future: _fetchRooms(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('오류가 발생했습니다.'));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      List<DocumentSnapshot> rooms = snapshot.data!;
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          var roomData =
                              rooms[index].data() as Map<String, dynamic>;

                          return Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Card(
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            roomData['title'] ?? '방 제목 없음',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(roomData['host'] ?? '호스트 정보 없음'),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: const Text('참여하기'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('참여 중인 방이 없습니다.'));
                    }
                  },
                ),
              ),

              const SizedBox(height: 10),
              // 이름 변경, 프로필 사진 변경, 로그아웃 버튼
              _buildActionButton(context, '이름 변경', () {
                ChangeNameDialog.show(context, _userService, _fetchUserData);
              }),
              _buildActionButton(context, '프로필 사진 변경', () async {
                await _userService.updateProfileImage();
                await _fetchUserData();
              }),
              _buildActionButton(context, '로그아웃', () async {
                await UserService.instance.logout();
                GoRouter.of(context).go('/Login');
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: primary_color),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
