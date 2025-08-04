// import 'dart:io';

// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_app/component/custombuttons.dart';
import 'package:note_app/component/customlogo.dart';
import 'package:note_app/component/textformfelied.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();
  bool isLoading = true;

  // داله تسجيل الدخول باستخدام جوجل
  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  // //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  CustomLogo(),
                  // ],
                  // ),
                  SizedBox(height: 30),
                  ListTile(
                    title: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('Login to contenu using the app'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Email",
                    // textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  CustomTextForm(
                    hintText: 'Eter Your Email',
                    myController: email,
                    validator: (val) {
                      if (val == "") {
                        return "can't be Empty";
                      }
                    },
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Password",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  CustomTextForm(
                    hintText: 'Eter Your Password',
                    myController: password,
                    validator: (val) {
                      if (val == "") {
                        return "can't be Empty";
                      }
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      if (email.text == " ") {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'Warring',
                          desc: 'الرجاء ادخال البريد الالكتروني اولا',
                          // btnCancelOnPress: () {},
                          // btnOkOnPress: () {},
                        ).show();
                        return;
                      }
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: email.text,
                        );
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'Warring',
                          desc:
                              '  لقد تم ارسال لينك الى بريدك الالكتروني الرجاء التوجه الى هناك واعاده تعيير الباسوورد',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {},
                        ).show();
                        return;
                      } catch (e) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Warring',
                          desc: ' الرجاء التاكد من صحة البريد الالكتروني',
                          // btnCancelOnPress: () {},
                          // btnOkOnPress: () {},
                        ).show();
                        return;
                      }
                    },
                    child: Container(
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      child: Text(
                        "Forgot Password ?",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomButtons(
              title: 'Logim',
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    isLoading = true;
                    setState(() {});
                    // ignore: unused_local_variable
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                          email: email.text,
                          password: password.text,
                        );
                    isLoading = false;
                    setState(() {});
                    // if (credential.user!.emailVerified) {
                      Navigator.of(context).pushReplacementNamed("homepage");
                    // } else {
                    //   AwesomeDialog(
                    //     context: context,
                    //     dialogType: DialogType.warning,
                    //     animType: AnimType.rightSlide,
                    //     title: 'Warring',
                    //     desc:
                    //         'الرجاء التوجه الى البريد الالكتروني واكمال خطوه التحقق',
                    //     btnCancelOnPress: () {},
                    //     btnOkOnPress: () {},
                    //   ).show();
                    // }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (password.text == 'wrong-password') {
                      print('Wrong password provided for that user.');
                    }
                  }
                } else {
                  print('Not Validate');
                }
              },
            ),
            SizedBox(height: 30),
            MaterialButton(
              color: Colors.pink,
              onPressed: () {
                // signInWithGoogle();
              },
              height: 40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Countiue with Google  ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Image.asset('images/google-icons.png', width: 50),
                ],
              ),
            ),
            SizedBox(height: 30),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("signup");
              },
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't Have an Account ? ",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextSpan(
                        text: 'Register',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// extension on GoogleSignIn {
  // Future<GoogleSignInAccount?> signIn() {}
// }
