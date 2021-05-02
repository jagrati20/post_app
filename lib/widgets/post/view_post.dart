import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ViewPost extends StatefulWidget {
  @override
  _ViewPostState createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  final String uid = FirebaseAuth.instance.currentUser.uid.toString();
  int likeCount = 0;
  bool buttonPressed = false;

  void buttonLiked() {
    buttonPressed = !buttonPressed;
    if (likeCount == 0 && buttonPressed) {
      likeCount = 1;
    } else {
      likeCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, streamSnapShot) {
        if (streamSnapShot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = streamSnapShot.data.documents;
        return ListView.builder(
            shrinkWrap: true,
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int position) => Container(
                  alignment: Alignment.center,
                  child: Card(
                    margin: EdgeInsets.all(5),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (uid == documents[position]['uid'])
                            Container(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Icon(Icons.delete),
                              ),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(documents[position]['uid'])
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text('');
                                  }
                                  return Text(
                                    snapshot.data['firstName'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                              Text(' '),
                              FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(documents[position]['uid'])
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text('');
                                  }
                                  return Text(
                                    snapshot.data['lastName'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                              Text(' posted:')
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(documents[position]['title']),
                          Text(documents[position]['description']),
                          SizedBox(
                            height: 20,
                          ),
                          if (documents[position]['image'] != null)
                            Image.network(documents[position]['image']),
                          SizedBox(
                            height: 20,
                          ),
                          Row(children: [
                            Text(documents[position]['totalLikes'].toString()),
                            TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.deepPurpleAccent,
                              ),
                              child: Icon(Icons.thumb_up_off_alt),
                              onPressed: () {
                                // setState(() {
                                buttonLiked();
                                // }
                                // );
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  primary: Colors.redAccent,
                                  alignment: Alignment.center),
                              child: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {});
                              },
                            ),
                          ]),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                ));
      },
    );
  }
}

// itemBuilder: (ctx, index) => Container(
//   padding: EdgeInsets.all(10),
//   child: Text(documents[index]['title']),
// ),
