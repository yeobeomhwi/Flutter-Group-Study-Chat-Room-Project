import 'package:app_team2/services/sv_chatService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({super.key, required this.room});

  final room;

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatService>(context);
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(children: [
          const Text('참여 인원', style: TextStyle(fontSize: 32)),
          Text(
            '[${chatProvider.roomSnapshot!['reservations'].length} / ${chatProvider.roomSnapshot!['maxParticipants']}]',
            style: const TextStyle(fontSize: 28),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: chatProvider
                  .roomSnapshot!['reservations'].length, // Changed this line
              itemBuilder: (context, index) {
                // Accessing each reservation directly
                String userId =
                    chatProvider.roomSnapshot!['reservations'][index];

                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    var userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: SizedBox(
                                  width: 42.0,
                                  height: 42.0,
                                  child: Image.network(userData['profileimage'],
                                      fit: BoxFit.cover), // 이미지 불러오기
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              Text(
                                '${userData['name']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
