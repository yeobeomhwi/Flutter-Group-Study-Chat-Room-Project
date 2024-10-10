import 'package:app_team2/components/w_chatDrawer.dart';
import 'package:app_team2/components/w_messageCard.dart';
import 'package:app_team2/services/sv_socket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.room, required this.roomId});

  final room;
  final roomId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String message = '';
  final chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 메세지 수신
    SocketService.instance.listen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading:
            GestureDetector(onTap: () {}, child: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text(
            '방 제목 (${widget.room['attendee']} / ${widget.room['maxParticipants']})'),
      ),
      endDrawer: ChatDrawer(room: widget.room),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // 나중에 리스트 뷰로 작성할 것
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .doc(widget.roomId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_scrollController.hasClients) {
                            _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent);
                          }
                        });

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                            controller: _scrollController,
                            itemCount: snapshot.data!['messages'].length,
                            itemBuilder: (context, index) {
                              return MessageCard(
                                  type: snapshot.data!['messages'][index]
                                              ['user'] ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? Message.SEND
                                      : Message.RECEIVE,
                                  message: snapshot.data!['messages'][index]
                                      ['message'],
                                  chatTime: snapshot.data!['messages'][index]
                                          ['createDate']
                                      .toDate());
                            });
                      })),
            ),
            Container(
                color: const Color(0xffF3EDF7),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.add_circle,
                      size: MediaQuery.of(context).size.width * 0.08,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: TextField(
                        controller: chatController,
                        onSubmitted: (mesage) {
                          SocketService.instance
                              .sendMessage(widget.roomId, mesage);

                          chatController.clear();
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            filled: true,
                            fillColor: Colors.white),
                      ),
                    ),
                    const Icon(Icons.send),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
