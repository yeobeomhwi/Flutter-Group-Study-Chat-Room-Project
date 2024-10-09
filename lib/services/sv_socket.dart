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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Socket 연결
  Future initializeSocketConnection() async {
    socket = IO.io(
        'http://localhost:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    socket.connect();

    socket.on('connet_error', (error) => print('Socket Connet Error: $error'));
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
        FirebaseFirestore.instance.collection('study_rooms');
    await chatsSnapshot.doc(roomId).update({
      'messages': FieldValue.arrayUnion([
        Message(
                room_id: roomId,
                user_id: FirebaseAuth.instance.currentUser!.uid,
                message_text: message,
                sent_at: DateTime.now())
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
