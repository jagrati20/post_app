import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
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

  bool postLiked = false;

  Future<void> addLikeCount(String id) async {
    CollectionReference getUser = FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .collection('likedUserList');
    getUser.add({'userID': uid});

    Stream<QuerySnapshot> snapshot = FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .collection('likedUserList')
        .snapshots();
    likeCount = await snapshot.length;
  }

  void removeLikeCount(String id) {
    CollectionReference getUser = FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .collection('likedUserList');
  }

  bool checkLikedPost(id) {
    Stream<QuerySnapshot> snapshot = FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .collection('likedUserList')
        .snapshots();

    snapshot.forEach((element) {
      element.docs.forEach((e) {
        if (e.data().containsValue(uid) && !postLiked) {
          postLiked = true;
        }
      });
    });
    return postLiked;
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
        // final id = streamSnapShot.data.docs;
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
                          const Divider(
                            thickness: 1,
                          ),
                          Text(
                            documents[position]['title'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(documents[position]['description']),
                          if (documents[position]['image'] != null)
                            const Divider(
                              thickness: 1,
                            ),
                          if (documents[position]['image'] != null)
                            Image.network(documents[position]['image']),
                          Row(children: [
                            Text(likeCount.toString()),
                            if (checkLikedPost(documents[position].id))
                              TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.red,
                                  ),
                                  onPressed: () async {
                                    removeLikeCount(documents[position].id);
                                  },
                                  child: Icon(
                                    Icons.favorite,
                                  )),
                            if (!checkLikedPost(documents[position].id))
                              TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.deepPurpleAccent,
                                  ),
                                  onPressed: () {
                                    addLikeCount(documents[position].id);
                                  },
                                  child: Icon(
                                    Icons.favorite_border,
                                  ))
                          ]),
                          if (uid == documents[position]['uid'])
                            Container(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      primary: Colors.redAccent,
                                      alignment: Alignment.center),
                                  child: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      FirebaseFirestore.instance.runTransaction(
                                          (Transaction myTransaction) async {
                                        myTransaction.delete(
                                            documents[position].reference);
                                      });
                                    });
                                  },
                                ),
                              ),
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
