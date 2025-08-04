import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/component/custombuttons.dart';
import 'package:note_app/component/textform_for_addcategory.dart';
import 'package:note_app/notes/notes-page.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class AddNont extends StatefulWidget {
  final String docId;
  const AddNont({super.key, required this.docId});

  @override
  State<AddNont> createState() => _AddNontState();
}

class _AddNontState extends State<AddNont> {
  GlobalKey<FormState> formstat = GlobalKey();
  TextEditingController note = TextEditingController();

  // FirebaseApp secondaryApp = Firebase.app('SecondaryApp');

  // داله اضافة صنف
  // Future<void> addUser() {
  //   // Call the user's CollectionReference to add a new user
  //   return categorys
  //       .add({
  //         'name': name.text, // John Doe
  //       })
  //       .then((value) => print("User Added"))
  //       .catchError((error) => print("Failed to add user: $error"));
  // }
  bool isLoad = false;
  // دالة اضافة صنف
  // نفس الدالة التي فوقها ولكن بطريقة اخرى
  addNont() async {
    final notes_collection = FirebaseFirestore.instance
        .collection('categorys')
        .doc(widget.docId)
        .collection('notes_collection');
    if (formstat.currentState!.validate()) {
      try {
        isLoad = true;
        setState(() {});
        DocumentReference respons = await notes_collection.add({
          'note': note.text,
        });
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => NotesPage(categoryId: widget.docId),
          ),
          (Route) => false,
        );
      } catch (e) {
        isLoad = false;
        setState(() {});
        print('error $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('homepage');
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Form(
        key: formstat,
        child: isLoad
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                    child: TextformForAdd(
                      hintText: 'Name',
                      myController: note,
                      validator: (val) {
                        if (val == '') {
                          return "can't be Empty";
                        }
                      },
                    ),
                  ),
                  CustomButtons(
                    title: 'add Note',
                    onPressed: () {
                      addNont();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

// class CollectionReference {}
