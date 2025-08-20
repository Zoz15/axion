import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(FirebaseAuth.instance.currentUser!.emailVerified);
    print('-----------------------------------------');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            TextButton(
  onPressed: () async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is signed in.');
      return;
    }

    if (!user.emailVerified) {
      print('Email not verified. Sending verification email...');
      await user.sendEmailVerification();

      // Periodically check for email verification
      const oneSec = Duration(seconds: 1);
      Timer.periodic(oneSec, (Timer t) async {
        // Reload the user to get the latest email verification status
        await user.reload();
        final updatedUser = FirebaseAuth.instance.currentUser;

        if (updatedUser != null && updatedUser.emailVerified) {
          t.cancel(); // Stop the timer
          Get.offAllNamed('/home'); // Navigate to the home screen
        }
      });
    } else {
      // If the email is already verified, navigate to the home screen
      Get.offAllNamed('/home');
    }
  },
  child: const Text("Verification"),
),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Get.offAllNamed('/splash');
              },
              child: const Text("logout"),
            ),
          ],
        ),
      ),
    );
  }
}
