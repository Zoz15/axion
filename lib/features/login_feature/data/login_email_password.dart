import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

Future<void> loginEmailPassword({
  required String email,
  required String password,
}) async {
  print(email);
  print(password);

  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if(FirebaseAuth.instance.currentUser!.emailVerified){
      Get.offAllNamed('/home');
    }else{
      
    Get.offAllNamed('/verification');
    }
  } on FirebaseAuthException catch (e) {
    print('-----------------------------');
    print(e.code);
    if (e.code == 'user-not-found') {
      print('No user exists with this email.');
      Get.snackbar('Error', 'No user exists with this email.');
    } else if (e.code == 'wrong-password') {
      print('Incorrect Password.');
      Get.snackbar('Error', 'Incorrect Password.');
    } else if (e.code == 'invalid-credential') {
      print('Email not found');
      Get.snackbar('Error', 'Email not found');
    }
  }
}
// }
