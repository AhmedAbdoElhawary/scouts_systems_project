import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:scouts_system/home_screen.dart';
import 'model/firebase_authentication.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return FirebaseAuthentication()
          .logIn(email: data.name, password: data.password)
          .then((value) {
        return "";
      }).catchError((e) {
        return "Something wrong";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'LOGIN',
      onLogin: _authUser,
      onSignup: (p0) {
        FirebaseAuthentication()
            .signUp(email: p0.name!, password: p0.password!);
        _authUser;
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
      },
      onRecoverPassword: (p0) async {
        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
        await _firebaseAuth.sendPasswordResetEmail(email: p0).then((value) {});
      },
    );
  }
}
