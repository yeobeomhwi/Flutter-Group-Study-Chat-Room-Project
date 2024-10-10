import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({super.key, required this.room});

  final room;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(children: [
          const Text('참여 인원', style: TextStyle(fontSize: 32)),
          Text('[${room['attendee']} / ${room['maxParticipants']}]',
              style: const TextStyle(fontSize: 28)),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: room['reservations'].keys.length,
              itemBuilder: (context, index) {
                return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(room['reservations'].keys.toList()[index])
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
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.1),
                                Text('${userData['name']}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            const Divider()
                          ],
                        ),
                      );
                    });
              },
            ),
          )
        ]),
      ),
    );
  }
}
