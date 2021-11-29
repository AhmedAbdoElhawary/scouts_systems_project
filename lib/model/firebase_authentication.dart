import 'package:firebase_auth/firebase_auth.dart';
import 'package:scouts_system/common_ui/toast_show.dart';

class FirebaseAuthentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  get user => _firebaseAuth.currentUser;

  Future<User> signUp({required String email, required String password}) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user!;

    return user;
  }

  Future<User> logIn({required String email, required String password}) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user!;

    return user;
  }



  Future signOut() async {
    await _firebaseAuth.signOut();

    ToastShow().whiteToast('sign out !');
  }
}
