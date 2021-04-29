import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

class CreatePost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, index) => Container(
          padding: EdgeInsets.all(10),
          child: Text('It works!!'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('posts/JNzfNchbu9x3bXlL8yKW/post')
              .snapshots()
              .listen((event) {
            // ignore: deprecated_member_use
            print(event.documents[0]['title']);
          });
        },
      ),
    );
  }
}
