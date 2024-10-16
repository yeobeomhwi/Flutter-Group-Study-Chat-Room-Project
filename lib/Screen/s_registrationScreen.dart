import 'package:app_team2/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _currentStep = 0;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  // Firebase Storage에 있는 기본 프로필 이미지 URL
  final String _defaultProfileImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/elice-flutter-team2.appspot.com/o/Default-Profile.png?alt=media';

  List<Step> _steps() => [
        Step(
          title: const Text('이메일 입력',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: '이메일'),
            keyboardType: TextInputType.emailAddress,
          ),
          isActive: _currentStep >= 0,
        ),
        Step(
          title: const Text('비밀번호 입력',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: '비밀번호'),
            obscureText: true,
          ),
          isActive: _currentStep >= 1,
        ),
        Step(
          title: const Text('이름 입력',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: '이름'),
          ),
          isActive: _currentStep >= 2,
        ),
      ];

  Future<void> registerUser() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      // Invalid email
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('유효한 이메일을 입력하세요.')),
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      // Password too short
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호는 최소 6자 이상이어야 합니다.')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading
    });

    try {
      // Firebase Auth를 사용하여 사용자 등록
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Firestore에 사용자 정보 저장
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': _nameController.text,
        'email': _emailController.text,
        'profileimage':
            _defaultProfileImageUrl, // Firebase Storage의 기본 프로필 이미지 URL 저장
      });

      // 스낵바 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입이 완료되었습니다.')),
      );

      // 2초 후 로그인 페이지로 이동
      await Future.delayed(const Duration(seconds: 2));

      // 회원가입 후 로그인 페이지로 이동
      GoRouter.of(context).push('/Login');
    } on FirebaseAuthException catch (e) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? '회원가입에 실패했습니다.')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Loading indicator
          : Theme(
              data: ThemeData(
                  colorScheme: const ColorScheme.light(primary: main_color)),
              child: Center(
                child: Stepper(
                  stepIconHeight: 40,
                  stepIconWidth: 40,
                  stepIconBuilder: (stepIndex, stepState) {
                    return Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        child: Text((stepIndex + 1).toString(),
                            style: TextStyle(
                                color: _currentStep >= stepIndex
                                    ? Colors.white
                                    : Colors.black)));
                  },
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_currentStep < _steps().length - 1) {
                      setState(() {
                        _currentStep++;
                      });
                    } else {
                      registerUser(); // 마지막 단계에서 회원가입 처리
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() {
                        _currentStep--;
                      });
                    }
                  },
                  steps: _steps(),
                ),
              ),
            ),
    );
  }
}
