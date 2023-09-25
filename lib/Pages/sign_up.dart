import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class SignUp extends StatefulWidget {
  final void Function()? onPressed;
  const SignUp({super.key, required this.onPressed});

  @override
  State<SignUp> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  createUserWithEmailAndPassword() async{

    try {
      setState(() {
        isLoading = true;
      });
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text,
          password: _password.text
      );
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'weak-password') {
        return ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content : Text("The password provided is too weak.")
            )
        );
      } else if (e.code == 'email-already-in-use') {
        return ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content : Text("The account already exists for that email.")
            )
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Signup"),
        ),
        body : Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key : _formKey,
              child: OverflowBar(
                overflowSpacing: 20,
                children: [
                  TextFormField(
                    controller: _email,
                    validator: (text) {
                      if(text == null || text.isEmpty){
                        return 'Email is empty.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: "Email"),
                  ),

                  TextFormField(
                    obscureText: true,
                    controller: _password,
                    validator: (text) {
                      if(text == null || text.isEmpty){
                        return 'Password is empty.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: "Password"),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          createUserWithEmailAndPassword();
                        }
                      },
                      child: isLoading
                          ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                          :const Text("Signup"),
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: widget.onPressed,
                      child: const Text("You have account? Login"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}