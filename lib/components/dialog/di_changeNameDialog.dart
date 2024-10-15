// change_name_dialog.dart
import 'package:flutter/material.dart';
import 'package:app_team2/services/sv_userService.dart';

class ChangeNameDialog {
  static void show(BuildContext context, UserService userService, Function refresh) {
    final TextEditingController _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('이름 변경'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: "새로운 이름 입력"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                String newName = _nameController.text.trim();
                if (newName.isNotEmpty) {
                  await userService.updateUserName(newName); // Firestore에 이름 업데이트
                  refresh(); // 사용자 데이터 다시 가져오기
                  Navigator.of(context).pop(); // 모달 닫기
                } else {
                  // 이름 입력이 비어있을 경우 경고 표시
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('이름을 입력해 주세요.')),
                  );
                }
              },
              child: const Text('확인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }
}
