import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/categories/edit.dart';
import 'package:note_app/notes/notes-page.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //
  bool isLoading = true;

  //  مصفوفة سنخزن داخلها البيانات القادة من قاعدة البيانات
  List<QueryDocumentSnapshot> data = [];

  //  دالة لجلب البيانات من قاعدة البيانات
  getdata() async {
    // categorys استقبال البيانات من
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categorys')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
          Navigator.of(context).pushNamed("addcategory");
        },
        child: Icon(Icons.add),
      ),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: Colors.blueAccent,
        title: Text('HomePage'),
        actions: [
          IconButton(
            onPressed: () async {
              isLoading = true;
              setState(() {});
              await FirebaseAuth.instance.signOut();
              isLoading = false;
              setState(() {});

              if (isLoading == true) {
                Center(child: CircularProgressIndicator());
              } else {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil("Login", (Route) => false);
              }
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            NotesPage(categoryId: data[index].id),
                      ),
                    );
                  },
                  onLongPress: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: '  اختر العملية التي تريدها',
                      btnCancelText: 'تعديل',
                      btnOkText: 'حذف',
                      btnOkOnPress: () async {
                        await FirebaseFirestore.instance
                            .collection('categorys')
                            .doc(data[index].id)
                            .delete();
                        Navigator.of(context).pushReplacementNamed('homepage');
                      },
                      btnCancelOnPress: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditCategory(
                              docId: data[index].id,
                              oldName: data[index]['name'],
                            ),
                          ),
                        );
                      },
                    ).show();
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [

                          Image.asset(
                            'images/folders.png',
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                          Text("${data[index]['name']}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
