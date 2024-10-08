import 'package:app_team2/components/w_chatDrawer.dart';
import 'package:app_team2/components/w_messageCard.dart';
import 'package:app_team2/services/sv_socket.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String message = '';
  final chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SocketManager.instance.initializeSocketConnection();
    SocketManager.instance.listen();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/chat'));
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        message = response.body;
      });
    } else {
      setState(() {
        message = 'Failed to load users';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading:
            GestureDetector(onTap: () {}, child: const Icon(Icons.arrow_back)),
        title: const Text('방 제목 (현재 인원 / 최대 인원)'),
      ),
      endDrawer: const ChatDrawer(totalPeople: 10, currentPeople: 5),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // 나중에 리스트 뷰로 작성할 것
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(message),
                      const MessageCard(
                          type: Message.SEND,
                          message: "안녕하세요",
                          chatTime: "2:04"),
                      const MessageCard(
                          type: Message.SEND,
                          message: "안녕하세요",
                          chatTime: "2:04"),
                      const MessageCard(
                          type: Message.RECEIVE,
                          message: "안녕하세요",
                          chatTime: "2:04"),
                      const MessageCard(
                          type: Message.RECEIVE,
                          message: "안녕하세요",
                          chatTime: "2:04"),
                    ],
                  ),
                ),
              ),
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
                        onSubmitted: (text) {
                          SocketManager.instance.sendMessage(text);
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
