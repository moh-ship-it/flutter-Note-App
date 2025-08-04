import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/component/custombuttons.dart';
import 'package:note_app/component/textform_for_AddCategory.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class EditCategory extends StatefulWidget {
  final String docId;
  final String oldName;
  const EditCategory({super.key, required this.docId, required this.oldName});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formstat = GlobalKey();
  TextEditingController name = TextEditingController();

  // FirebaseApp secondaryApp = Firebase.app('SecondaryApp');

  final categorys = FirebaseFirestore.instance.collection('categorys');

  bool isLoad = false;

  // دالة تعديل صنف
  EditCategory() async {
    if (formstat.currentState!.validate()) {
      try {
        isLoad = true;
        setState(() {});
        // function to updat
        await categorys.doc(widget.docId).update({'name': name.text});
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('homepage', (Route) => false);
      } catch (e) {
        isLoad = false;
        setState(() {});
        print('error $e');
      }
    }
  }

  @override
  void initState() {
    name.text = widget.oldName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
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
                      myController: name,
                      validator: (val) {
                        if (val == '') {
                          return "can't be Empty";
                        }
                      },
                    ),
                  ),
                  CustomButtons(
                    title: 'Save',
                    onPressed: () {
                      EditCategory();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class CollectionReference {}
