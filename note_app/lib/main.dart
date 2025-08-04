import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_app/auth/login.dart';
import 'package:note_app/auth/signup.dart';
import 'package:note_app/categories/add.dart';
// import 'package:note_app/firebase_options.dart';
// import 'package:note_app/firebase_options.dart';
import 'package:note_app/homepage.dart';
import 'package:note_app/notes/notes-page.dart';
import 'package:note_app/users.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('============================User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          titleTextStyle: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
          iconTheme: IconThemeData(color: Colors.amber),
        ),
      ),

      home:
          (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? Homepage()
          : Login(),
      routes: {
        "signup": (context) => SignUp(),
        "Login": (context) => Login(),
        "homepage": (context) => Homepage(),
        "addcategory": (context) => AddCategory(),
        // "notepage":(context)=> NotesPage(),
      },
    );
  }
}
