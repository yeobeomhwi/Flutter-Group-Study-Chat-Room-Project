import 'package:app_team2/data/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  static final instance = ChatService();

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
