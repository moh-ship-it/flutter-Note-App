import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/categories/add.dart';
import 'package:note_app/categories/edit.dart';
import 'package:note_app/homepage.dart';
import 'package:note_app/notes/add-note.dart';
import 'package:note_app/notes/edit-not.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  final String categoryId;
  const NotesPage({super.key, required this.categoryId});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  //
  bool isLoading = true;

  //  مصفوفة سنخزن داخلها البيانات القادة من قاعدة البيانات
  List<QueryDocumentSnapshot> data = [];

  //  دالة لجلب البيانات من قاعدة البيانات
  getdata() async {
    // categorys استقبال البيانات من
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categorys')
        .doc(widget.categoryId)
        .collection('notes_collection')
        .get();
    // تخزين البيانات في المصفوفة
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {
      //  هذه الدالة للتحديث
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNont(docId: widget.categoryId),
            ),
          );
        },
        child: Icon(Icons.add),
      ),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: Colors.blueAccent,
        title: Text(""),
        //  Text('NotesPage'),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => Homepage()));
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 130,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onLongPress: () async {
                    await showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => CupertinoActionSheet(
                        title: Text('Welco'),
                        message: Text('What achtion you want to do'),
                        actions: [
                          CupertinoActionSheetAction(
                            isDefaultAction: true,
                            onPressed: () {},
                            child: Text('Close'),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () async {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UpdateNote(
                                    categoryId: widget.categoryId,
                                    docId: data[index].id,
                                    oldName: data[index]['note'],
                                  ),
                                ),
                              );
                            },
                            child: Text('Edit'),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('categorys')
                                  .doc(widget.categoryId)
                                  .collection('notes_collection')
                                  .doc(data[index].id)
                                  .delete();

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NotesPage(categoryId: widget.categoryId),
                                ),
                              );
                            },
                            child: Text('Delet'),
                          ),
                        ],
                      ),
                    );
                    // AwesomeDialog(
                    //   context: context,
                    //   dialogType: DialogType.warning,
                    //   animType: AnimType.rightSlide,
                    //   title: '  اختر العملية التي تريدها',
                    //   btnCancelText: 'تعديل',
                    //   btnOkText: 'حذف',
                    //   btnOkOnPress: () async {
                    //     // ;
                    //   },
                    //   btnCancelOnPress: () async {
                    //
                    //   },
                    // ).show();
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(children: [Text("${data[index]['note']}")]),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
