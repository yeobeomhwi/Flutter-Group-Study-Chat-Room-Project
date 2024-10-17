import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UserService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static final instance = UserService();
  String currentUserId = '';
  UserCredential? userCredential;
  DocumentSnapshot? userSnapshot;

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

  // 현재 로그인한 사용자의 정보를 가져오는 메서드
  Future<void> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      currentUserId = user.uid; // 현재 사용자의 UID 설정
    } else {
      throw Exception('사용자가 로그인되어 있지 않습니다.');
    }
  }

  Stream<DocumentSnapshot> fetchUserData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  void listenUserData(String uid) {
    fetchUserData(uid).listen((data) {
      userSnapshot = data;
      notifyListeners();
    });
  }

  // Firestore에서 현재 사용자 이름과 프로필 이미지를 가져오는 메서드
  Future<Map<String, dynamic>> getUserNameImageParticipationList() async {
    User? user = _auth.currentUser; // 현재 로그인한 사용자
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      return {
        'name': userDoc['name'], // Firestore에서 이름 가져오기
        'profileimage': userDoc['profileimage'], // 프로필 이미지 가져오기
        'participationList': userDoc['participationList'],
      };
    }
    throw Exception('사용자가 로그인되어 있지 않습니다.');
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


  // 사용자 이름을 업데이트하는 메서드
  Future<void> updateUserName(String newName) async {
    User? user = _auth.currentUser; // 현재 로그인한 사용자
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'name': newName, // Firestore에서 이름 업데이트하기
        });
        print("사용자 이름이 성공적으로 업데이트되었습니다.");
      } catch (e) {
        print("사용자 이름 업데이트 오류: $e");
      }
    } else {
      throw Exception('사용자가 로그인되어 있지 않습니다.');
    }
  }

  Future<void> updateProfileImage() async {
    User? user = _auth.currentUser; // 현재 로그인한 사용자
    if (user != null) {
      try {
        // 갤러리 접근 권한 요청
        var status = await Permission.contacts.status;
        if (status.isGranted) {
          print('갤러리 허락됨');
        } else {
          print('갤러리 거절됨.');
          Permission.contacts.request();
        }

        // 권한이 허용된 경우 이미지 선택
        final ImagePicker picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);

        if (image != null) {
          // 선택한 이미지 파일
          File imageFile = File(image.path);

          // Firebase Storage에 이미지 업로드
          String fileName = 'profile_images/${user.uid}.jpg';
          UploadTask uploadTask = _storage.ref(fileName).putFile(imageFile);
          TaskSnapshot snapshot = await uploadTask;

          // 업로드 완료 후 다운로드 URL 가져오기
          String downloadUrl = await snapshot.ref.getDownloadURL();

          // Firestore에서 프로필 이미지 URL 업데이트
          await _firestore.collection('users').doc(user.uid).update({
            'profileimage': downloadUrl, // Firestore에서 프로필 이미지 URL 업데이트
          });

          print("프로필 이미지가 성공적으로 업데이트되었습니다.");
        } else {
          print("이미지가 선택되지 않았습니다.");
        }
      } catch (e) {
        print("프로필 이미지 업데이트 오류: $e");
      }
    } else {
      throw Exception('사용자가 로그인되어 있지 않습니다.');
    }
  }
}
