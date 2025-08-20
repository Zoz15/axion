import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

Future<void> createEmailPassword(
    {required String email, required String password}) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    Get.back();
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      Get.snackbar('Error', 'The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      Get.snackbar('Error', 'The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}
