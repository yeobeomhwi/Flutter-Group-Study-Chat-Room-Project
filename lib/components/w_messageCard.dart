import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Message { SEND, RECEIVE }

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.type,
    required this.message,
    required this.chatTime,
    required this.name,
    required this.profileimage,
  });

  final Message type;
  final String message;
  final DateTime chatTime;
  final String name;
  final String profileimage;

  @override
  Widget build(BuildContext context) {
    return type == Message.SEND
        ? sendMessage(context, message, chatTime, name, profileimage)
        : receiveMessage(context, message, chatTime, name, profileimage);
  }
}

Widget sendMessage(BuildContext context, String message, DateTime chatTime,
    String name, String profileimage) {
  return Column(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(DateFormat('hh:mm').format(chatTime)), // 메세지 입력 시간
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
                minHeight: MediaQuery.of(context).size.height * 0.05,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xff8A2BE2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 42.0,
                    height: 42.0,
                    child: Image.network(profileimage,
                        fit: BoxFit.cover), // 이미지 불러오기
                  ),
                ),
                Text(name),
              ],
            )
          ],
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
    ],
  );
}

Widget receiveMessage(BuildContext context, String message, DateTime chatTime,
    String name, String profileimage) {
  return Column(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 42.0,
                    height: 42.0,
                    child: Image.network(profileimage,
                        fit: BoxFit.cover), // 이미지 불러오기
                  ),
                ),
                Text(name),
              ],
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
                minHeight: MediaQuery.of(context).size.height * 0.05,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
            ),

            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Text(DateFormat('hh:mm').format(chatTime)), // 메세지 입력 시간
          ],
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
    ],
  );
}
