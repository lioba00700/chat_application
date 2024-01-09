import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {//stf
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SinginPageState();
}

class _SinginPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();


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
              TextField(
                controller: _nameController,
              ),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    String name = _nameController.text;

                    FirebaseAuth.instance
                      .createUserWithEmailAndPassword(email: email, password: password)
                      .then(
                        (value) async{
                          await value.user?.updateDisplayName(name);
                          FirebaseAuth.instance.signOut();
                      }
                    );
                  }, 
                  child: const Text('회원가입'),
              ),
            ]
          ),
        )
      ),
    );
  }
}