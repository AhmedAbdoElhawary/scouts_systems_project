import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:scouts_system/view/students/students_screen.dart';

import 'common_ui/toast_show.dart';
import 'home_screen.dart';
import 'leader_screen.dart';
import 'model/firebase_authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool userNameValidate = false;
  bool userPasswordValidate = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool visibilityPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blue[500],
        child: buildColumnOfLoginScreen(),
      ),
    );
  }

  SingleChildScrollView buildColumnOfLoginScreen() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildLoginText(),
            buildContainerOfTheFields(),
          ],
        ),
      ),
    );
  }

  Text buildLoginText() {
    return const Text(
      "Login",
      style: TextStyle(
          fontSize: 45, color: Colors.white, fontWeight: FontWeight.w300),
    );
  }

  Padding buildContainerOfTheFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 45),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black54.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: buildColumnOfField(),
      ),
    );
  }

  Column buildColumnOfField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildTextFormFieldInfo(emailController, "Email"),
        buildTextFormFieldInfo(passwordController, "Password"),
        buildLoginTextButton(),
        buildSignupTextButton(),
      ],
    );
  }

  Container buildLoginTextButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black54.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: buildLoginButton(),
    );
  }

  Padding buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextButton(
        onPressed: () async {
          if (validateTextField(emailController.text) &&
              validateTextField(passwordController.text)) {
            FirebaseAuthentication()
                .logIn(
                    email: emailController.text,
                    password: passwordController.text)
                .then((user) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }).catchError((e) {
              ToastShow().whiteToast(e);
            });
          }
        },
        child: const Text(
          "LOGIN",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }

  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        userNameValidate = true;
        userPasswordValidate = true;
      });
      return false;
    }
    setState(() {
      userNameValidate = false;
      userPasswordValidate = false;
    });
    return true;
  }

  TextButton buildSignupTextButton() {
    return TextButton(
      onPressed: () {
        if (validateTextField(emailController.text) &&
            validateTextField(passwordController.text)) {
          FirebaseAuthentication()
              .signUp(
                  email: emailController.text,
                  password: passwordController.text)
              .then((user) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      emailController.text == "leader@gmail.com"
                          ? const LeaderPage()
                          : const StudentsPage()),
            );
          }).catchError((e) {
            ToastShow().whiteToast(e);
          });
        }
      },
      child: Text(
        "SIGNUP",
        style: TextStyle(fontSize: 15, color: Colors.blue[300]),
      ),
    );
  }

  TextFormField buildTextFormFieldInfo(
      TextEditingController controller, String text) {
    return TextFormField(
      cursorColor: Colors.blue,
      obscureText: text == "Email" ? false : visibilityPassword,
      style: const TextStyle(height: 0.8, fontSize: 14),
      controller: controller,
      decoration: InputDecoration(
          fillColor: const Color.fromRGBO(146, 191, 215, 0.23529411764705882),
          filled: true,
          prefixIcon: text == "Email"
              ? const Icon(Icons.person_pin, size: 30)
              : const Icon(Icons.lock, size: 25),
          suffixIcon: text == "Email"
              ? const Icon(Icons.person_pin,
                  color: Color.fromRGBO(2, 2, 2, 0.0))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      visibilityPassword = !visibilityPassword;
                    });
                  },
                  icon: Icon(
                    visibilityPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
          errorText: userNameValidate ? "invalid $text" : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              50.0,
            ),
          ),
          labelText: text),
    );
  }
}
