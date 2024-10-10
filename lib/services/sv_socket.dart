import 'dart:async';

import 'package:app_team2/data/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService instance = SocketService();
  StreamController<List<Message>> chatController =
      StreamController<List<Message>>();
  List<Message> allChats = [];

  late IO.Socket socket;

  // Socket 연결
  Future initializeSocketConnection() async {
    socket = IO.io(
        'http://10.0.2.2:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    socket.onConnect((_) {
      print('Connected to socket server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket server');
    });

    socket.connect();
  }

  // Socket 연결 해제
  Future socketDisconnection() async {
    socket.disconnect();
    socket.onDisconnect((_) => debugPrint('Socket Disconnected'));
  }

  void listen() {
    socket.on('message', (message) {
      print('$message');
      // allChats.add(Message(message_text: data['content']));
    });
  }

  void sendMessage(String roomId, String message) async {
    CollectionReference chatsSnapshot =
        FirebaseFirestore.instance.collection('chats');
    await chatsSnapshot.doc(roomId).update({
      'messages': FieldValue.arrayUnion([
        Message(
                user: FirebaseAuth.instance.currentUser!.uid,
                message: message,
                createDate: DateTime.now())
            .toMap()
      ]),
    });
    socket.emit('message', {
      'room_id': roomId,
      'user_id': FirebaseAuth.instance.currentUser!.uid,
      'message_text': message,
      'sent_at': DateTime.now().toString(),
    });
  }
}
