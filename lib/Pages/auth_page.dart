import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:login_signup_firebase/Pages/login_or_signup.dart';
import 'package:login_signup_speech_text/Pages/login_or_signup.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'login_or_signup.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const CircularProgressIndicator();
            }
            else{
              if(snapshot.hasData){
                return HomePage();
              }
              else{
                return const LoginAndSignUp();
              }
            }
          },
      )
    );
  }
}
