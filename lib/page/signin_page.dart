import 'package:chat_application/page/sighup_page/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
              ),
              TextField(
                controller: _passwordController,
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  String email = _emailController.text;
                  String password = _passwordController.text;

                  FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                },
                child: const Text('로그인'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:(context) => const SignupPage(),


                    )
                  ), 
                  child: const Text('회원가입'),
                ),
              ],
            ),
          )
        ),
    );
  }
}

