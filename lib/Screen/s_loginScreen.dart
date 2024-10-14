import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> loginUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // 로그인 성공 후의 동작
      print("로그인 성공: ${userCredential.user!.email}");
      GoRouter.of(context).pushReplacement('/Main');
    } on FirebaseAuthException catch (e) {
      // 에러 메시지 출력
      print("로그인 오류: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그인 오류: ${e.message}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash/group_study.png',
                color: const Color(0xff8A2BE2),
                width: MediaQuery.of(context).size.width * 0.5),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Login',
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "ID"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: loginUser,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff8A2BE2)),
                child:
                    const Text('Login', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).push('/Registration');
                },
                child: const Text('Sign Up',
                    style: TextStyle(color: Color(0xff8A2BE2))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
