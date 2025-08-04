import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

List<QueryDocumentSnapshot> data = [];

class _UsersState extends State<Users> {
  addUser() async {
    final users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot = await users.get();
    data.addAll(querySnapshot.docs);
  }

  @override
  void initState() {
    addUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('list of users')),
      body: ListView.builder(
        itemCount: data.length,
        // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        //   maxCrossAxisExtent: 2,
        // ),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(" name :  ${data[index]['name']}"),
              subtitle: Text(" age: ${data[index]['age']} "),
            ),
          );
        },
      ),
    );
  }
}
