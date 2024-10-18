import '../components/w_roomCard.dart' show RoomCard;
import 'package:app_team2/services/sv_userService.dart';
import 'package:app_team2/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      // print('사용자 정보를 가져오는 중 오류 발생: $error');
    });
  }

  Future<void> _fetchUserData() async {
    try {
      final userData = await _userService.getUserNameImageParticipationList();
      setState(() {
        _profileImageUrl = userData['profileimage'];
        _userName = userData['name'];
        _participationList = userData['participationList'] != null
            ? List<dynamic>.from(userData['participationList'])
            : [];
      });
    } catch (e) {
      // print('사용자 데이터를 가져오는 중 오류 발생: $e');
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
      // print('방 데이터를 가져오는 중 오류 발생: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 프로필 이미지
              Center(
                child: ClipOval(
                  child: _profileImageUrl != null
                      ? Image.network(
                    _profileImageUrl!,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.3,
                    height: MediaQuery
                        .of(context)
                        .size
                        .width * 0.3,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    'assets/images/default_profile.png',
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.3,
                    height: MediaQuery
                        .of(context)
                        .size
                        .width * 0.3,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 5),

              // 사용자 이름
              Text(
                _userName ?? 'Loading...',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
              const Divider(),
              const Text(
                '참여중인 방',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // 참여 방 데이터 표시
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.48, // 높이 조정
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
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          var roomData =
                          rooms[index].data() as Map<String, dynamic>;

                          final reservations =
                              roomData['reservations'] as List<dynamic>? ?? [];

                          return RoomCard(
                            title: roomData['title'],
                            host: roomData['host'],
                            content: roomData['content'],
                            startTime:
                            (roomData['startTime'] as Timestamp).toDate(),
                            endTime: (roomData['endTime'] as Timestamp)
                                .toDate(),
                            maxParticipants: roomData['maxParticipants'],
                            topic: roomData['topic'],
                            imageUrl: roomData['hostProfileImage'] != null &&
                                roomData['hostProfileImage'].isNotEmpty
                                ? roomData['hostProfileImage']
                                : 'https://picsum.photos/200/200',
                            // 프로필 이미지가 없을 때 기본 이미지 사용
                            reservations: reservations,
                            startStudy: roomData['startStudy'],
                            currentUserId: currentUserId,
                            docId: roomData['room_id'].toString(),
                            onCardTap: () {
                              Provider.of<ChatService>(context, listen: false)
                                  .listenUserData(rooms[index].id);
                              GoRouter.of(context).push('/Chat', extra: {
                                'room': roomData,
                                'roomId': rooms[index].id,
                              });
                            },
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('참여 중인 방이 없습니다.'));
                    }
                  },
                ),
              ),
              const Divider(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,  // 가로 크기를 최대치로 설정
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: primary_color,
            minimumSize: const Size(double.infinity, 48),  // 버튼의 높이를 48로 설정
          ),
          child: Text(label, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

}
