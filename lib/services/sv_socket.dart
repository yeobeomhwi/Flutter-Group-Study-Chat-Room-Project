import 'dart:async';

import 'package:app_team2/data/message.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  static final SocketManager instance = SocketManager();
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

    socket.connect();

    socket.on('connet_error', (error) => print('Socket Connet Error: $error'));
  }

  // Socket 연결 해제
  Future socketDisconnection() async {
    socket.disconnect();
    socket.onDisconnect((_) => debugPrint('Socket Disconnected'));
  }

  void listen() {
    socket.on('message', (data) {
      print(data['content']);
      allChats.add(Message(message_text: data['content']));
    });
  }

  void sendMessage(String content) {
    socket.emit('message', {'sender': 'FlutterUser', 'content': content});
  }
}
