import 'package:app_team2/components/w_chatDrawer.dart';
import 'package:app_team2/components/w_messageCard.dart';
import 'package:app_team2/services/sv_chatService.dart';
import 'package:app_team2/services/sv_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.room, required this.roomId});

  final Map<String, dynamic> room;
  final String roomId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // 메시지 전송 함수
  void _sendMessage() {
    if (_chatController.text.isNotEmpty) {
      ChatService.instance.sendMessage(widget.roomId, _chatController.text);
      _chatController.clear();
    }
  }

  // 스크롤을 맨 아래로 이동
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  // 사용자 이름을 가져오는 함수
  Stream<DocumentSnapshot> getUserData(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  Widget _buildMessageList() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.roomId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No messages yet."));
        }

        // 스크롤을 맨 아래로 이동
        _scrollToBottom();

        var messages = snapshot.data!['messages'] as List<dynamic>;

        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final messageData = messages[index];
            final bool isSendByCurrentUser = messageData['user_id'] ==
                FirebaseAuth.instance.currentUser!.uid;
            final String uid = messageData['user_id'];

            return StreamBuilder(
              stream: getUserData(uid),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator()); // 사용자 이름 로딩 중 표시
                } else if (userSnapshot.hasError) {
                  return const Text('Error fetching user name');
                } else if (!userSnapshot.hasData) {
                  return const Text('No name found');
                }

                return MessageCard(
                    type: isSendByCurrentUser ? Message.SEND : Message.RECEIVE,
                    message: messageData['message_text'],
                    chatTime: messageData['sent_at'].toDate(),
                    name: userSnapshot.data!['name'], // 사용자 이름을 MessageCard에 전달
                    profileimage: userSnapshot.data!['profileimage']);
              },
            );
          },
        );
      },
    );
  }

  // 채팅 입력 필드와 보내기 버튼을 렌더링하는 메서드
  Widget _buildInputField() {
    return Container(
      color: const Color(0xffF3EDF7),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {},
            child: Icon(
              Icons.add_circle,
              size: MediaQuery.of(context).size.width * 0.08,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _chatController,
              onSubmitted: (_) => _sendMessage(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          '${widget.room['title']} (${chatProvider.roomSnapshot!['reservations'].length} / ${chatProvider.roomSnapshot!['maxParticipants']})',
        ),
      ),
      endDrawer: ChatDrawer(room: widget.room),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _buildMessageList(),
              ),
            ),
            _buildInputField(),
          ],
        ),
      ),
    );
  }
}
