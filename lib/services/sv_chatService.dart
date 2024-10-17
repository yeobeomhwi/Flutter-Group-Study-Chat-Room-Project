import 'package:app_team2/data/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final instance = ChatService();
  DocumentSnapshot? chatSnapshot;
  DocumentSnapshot? roomSnapshot;

  Stream<DocumentSnapshot> fetchRoomData(String roomId) {
    return _firestore.collection('study_rooms').doc(roomId).snapshots();
  }

  void listenRoomData(String roomId) {
    fetchRoomData(roomId).listen((data) {
      roomSnapshot = data;
      notifyListeners();
    });
  }

  Stream<DocumentSnapshot> fetchChatData(String roomId) {
    return _firestore.collection('chats').doc(roomId).snapshots();
  }

  void listenUserData(String roomId) {
    fetchChatData(roomId).listen((data) {
      chatSnapshot = data;
      notifyListeners();
    });
  }

  void sendMessage(String roomId, String message) async {
    CollectionReference chatsSnapshot =
        FirebaseFirestore.instance.collection('chats');
    await chatsSnapshot.doc(roomId).update({
      'messages': FieldValue.arrayUnion([
        Message(
                user_id: FirebaseAuth.instance.currentUser!.uid,
                message_text: message,
                sent_at: DateTime.now())
            .toMap()
      ]),
    });
  }
}
