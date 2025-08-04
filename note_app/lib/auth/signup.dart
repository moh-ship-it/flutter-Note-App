import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/component/custombuttons.dart';
import 'package:note_app/component/customlogo.dart';
import 'package:note_app/component/textformfelied.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();



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
                      'SignUp',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('SignUp to contenu using the app'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Username",
                    // textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  CustomTextForm(
                    hintText: 'Eter Your Username',
                    myController: username,
                    validator: (val) {
                      if (val == "") {
                        return "can't be Empty";
                      }
                    },
                  ),
                  SizedBox(height: 8),
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
                  Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      "Forgot Password ?",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            CustomButtons(
              title: 'Logim',
              onPressed: () async {
                var acs = ActionCodeSettings(
                  // URL you want to redirect back to. The domain (www.example.com) for this
                  // URL must be whitelisted in the Firebase Console.
                    url: 'https://www.mohammed.com/finishSignUp?cartId=1234',
                    // This must be true
                    handleCodeInApp: true,
                    iOSBundleId: 'com.example.ios',
                    androidPackageName: 'com.example.note_app',
                    // installIfNotAvailable
                    androidInstallApp: true,
                    // minimumVersion
                    androidMinimumVersion: '12');
                if (formState.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                          email: email.text,
                          password: password.text,
                        );


                    var emailAuth = email.text;
                    FirebaseAuth.instance.sendSignInLinkToEmail(
                        email: emailAuth, actionCodeSettings: acs)
                        .catchError((onError) => print('Error sending email verification $onError'))
                        .then((value) => print('Successfully sent email verification'));

                    Navigator.of(context).pushReplacementNamed("Login");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Warring',
                        desc: 'The password provided is too weak.',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();

                      // print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Warring',
                        desc: 'The account already exists for that email',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                      // print('The account already exists for that email.');
                    }
                  } catch (e) {
                    print(e);
                  }
                } else {
                  print("Not Valide");
                }
              },
            ),
            SizedBox(height: 30),

            SizedBox(height: 30),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("Login");
              },
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: " Have an Account ? ",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextSpan(
                        text: 'Login',
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
