import 'package:flutter/material.dart';
import 'login_page.dart';
import 'sign_up.dart';

class LoginAndSignUp extends StatefulWidget {
  const LoginAndSignUp({super.key});

  @override
  State<LoginAndSignUp> createState() => _LoginAndSignUpState();
}

class _LoginAndSignUpState extends State<LoginAndSignUp> {

  bool islogin = false;

  void togglePage() {
    setState(() {
      islogin = !islogin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (islogin){
      return LoginPage(
        onPressed: togglePage
      );
    } else{
        return SignUp(
            onPressed: togglePage
        );
      }
  }
}
