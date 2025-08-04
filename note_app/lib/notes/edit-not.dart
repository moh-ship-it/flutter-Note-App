import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/component/custombuttons.dart';
import 'package:note_app/component/textform_for_addcategory.dart';
import 'package:note_app/notes/notes-page.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateNote extends StatefulWidget {
  final String docId;
  final String categoryId;
  final String oldName;
  const UpdateNote({
    super.key,
    required this.docId,
    required this.oldName,
    required this.categoryId,
  });

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  GlobalKey<FormState> formstat = GlobalKey();
  TextEditingController note = TextEditingController();

  bool isLoad = false;
  // دالة تعديل ملاحضة
  updateNote() async {
    final notes_collection = FirebaseFirestore.instance
        .collection('categorys')
        .doc(widget.categoryId)
        .collection('notes_collection');
    if (formstat.currentState!.validate()) {
      try {
        isLoad = true;
        setState(() {});
        await notes_collection.doc(widget.docId).update({'note': note.text});
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => NotesPage(categoryId: widget.categoryId),
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
  void initState() {
    note.text = widget.oldName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("update Note"),
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
                      updateNote();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

// class CollectionReference {}
