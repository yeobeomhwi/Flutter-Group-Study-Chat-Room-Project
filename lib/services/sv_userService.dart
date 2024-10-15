import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final instance = UserService();

  UserCredential? userCredential;
  DocumentSnapshot? userSnapshot;
  final _fireStore = FirebaseFirestore.instance;

  Future<void> loginUser(String email, String password) async {
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 로그인 성공 후의 동작
      print("로그인 성공: ${userCredential!.user!.email}");
    } on FirebaseAuthException catch (e) {
      // 에러 메시지 출력
      print("로그인 오류: ${e.message}");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("로그인 오류: ${e.message}")),
      // );
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("로그아웃 오류: $e");
    }
  }

  Stream<DocumentSnapshot> fetchUserData(String uid) {
    return _fireStore.collection('users').doc(uid).snapshots();
  }

  void listenUserData(String uid) {
    fetchUserData(uid).listen((data) {
      userSnapshot = data;
      notifyListeners();
    });
  }


  // Firestore에서 현재 사용자 이름과 프로필 이미지를 가져오는 메서드
  Future<Map<String, dynamic>> getUserNameImage() async {
    User? user = _auth.currentUser; // 현재 로그인한 사용자
    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user.uid).get();
      return {
        'name': userDoc['name'], // Firestore에서 이름 가져오기
        'profileimage': userDoc['profileimage'], // 프로필 이미지 가져오기
      };
    }
    throw Exception('사용자가 로그인되어 있지 않습니다.');
  }
}
