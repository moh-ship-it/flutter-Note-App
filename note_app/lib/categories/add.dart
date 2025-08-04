import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/component/custombuttons.dart';
import 'package:note_app/component/textform_for_addcategory.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formstat = GlobalKey();
  TextEditingController name = TextEditingController();

  // FirebaseApp secondaryApp = Firebase.app('SecondaryApp');

  final categorys = FirebaseFirestore.instance.collection('categorys');

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
  addCategory() async {
    if (formstat.currentState!.validate()) {
      try {
        isLoad = true;
        setState(() {});
        DocumentReference respons = await categorys.add({
          'name': name.text,
          'id': FirebaseAuth.instance.currentUser!.uid,
        });
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
                    title: 'add',
                    onPressed: () {
                      addCategory();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class CollectionReference {}
