import 'package:flutter/material.dart';
import 'dart:html';

class PostDetails extends StatefulWidget {
  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text("Pay on: Wed, May 08 2019"),
        Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.play_arrow),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Social Security"),
                    Text("Weekly | Debit"),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text("\$45.00"),
                Text("Not Received"),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// itemBuilder: (ctx, index) => Container(
//   padding: EdgeInsets.all(10),
//   child: Text(documents[index]['title']),
// ),
