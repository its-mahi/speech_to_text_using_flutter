import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechPage extends StatefulWidget {
  const SpeechPage({super.key});

  @override
  State<SpeechPage> createState() => _SpeechPageState();
}

class _SpeechPageState extends State<SpeechPage> {
  final user = FirebaseAuth.instance.currentUser;
  final SpeechToText _speechToText = SpeechToText();
  var isLis = false;
  var text = "Hold mic and start specking";
  var confidence = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout_sharp)
        )],
        centerTitle: true,
        title: const Text("Speech to Text"),
      ),
      body: SingleChildScrollView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          margin: const EdgeInsets.only(bottom: 150),
          child: Text(
            text,
            style: TextStyle(
              color: isLis ? Colors.black87 : Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        glowColor: Colors.blue,
        animate: isLis,
        endRadius: 90.0,
        duration: const Duration(milliseconds: 2000),
        repeat: true,
        showTwoGlows: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isLis) {
              bool avail = await _speechToText.initialize();
              if (avail) {
                setState(() {
                  isLis = true;
                });
                _speechToText.listen(onResult: (value) {
                  setState(() {
                    text = value.recognizedWords;
                  });
                });
              }
            } else {
              setState(() {
                isLis = false;
              });
              _speechToText.stop();
            }
          },
          onTapUp: (details) {
            setState(() {
              isLis = false;
            });
            _speechToText.stop();
          },
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 35,
            child: Icon(isLis ? Icons.mic : Icons.mic_none, color: Colors.white),
          ),
        ),
      ),
    );
  }
}