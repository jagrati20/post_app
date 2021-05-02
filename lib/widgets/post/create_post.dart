import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CreatePost extends StatefulWidget {
  // CreatePost(this.createPostfn);

  // final void Function(
  //   File pickedImage,
  //   String postTitle,
  //   String postDescription,
  // ) createPostfn;

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  bool imageSelected = false;
  final _formKey = GlobalKey<FormState>();
  File _pickedImage;
  String _postTitle = '';
  String _postDescription = '';
  int totolLikes = 0;
  var uuid = Uuid().v1();

  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState.validate();
    //close the keyboard
    FocusScope.of(context).unfocus();
    final ref =
        FirebaseStorage.instance.ref().child('user_image').child(uuid + '.jpg');
    var url;
    if (_pickedImage != null) {
      await ref.putFile(_pickedImage);
      url = await ref.getDownloadURL();
    }

    if (isValid) {
      _formKey.currentState.save();
      final String uid = FirebaseAuth.instance.currentUser.uid.toString();

      try {
        await posts.add({
          'title': _postTitle,
          'description': _postDescription,
          'uid': uid,
          'image': url,
          'totalLikes': 0,
        });
        CircularProgressIndicator();
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Post Added Successfully'),
          ),
        );
      } catch (err) {
        final scaffold = Scaffold.of(context);
        scaffold.showSnackBar(
          SnackBar(
            content: Text(err),
          ),
        );
      }
    }
  }

  void _pickImage() async {
    // final pickedImageFile = await ImagePicker.pickImage(...);
    final picker = ImagePicker();
    imageSelected = !imageSelected;
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
      _trySubmit();
    });
    // widget.createPostfn(
    //   _pickedImage,
    //   _postTitle,
    //   _postDescription,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(5.0),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              key: ValueKey('title'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a title.';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Post Title',
              ),
              onSaved: (value) {
                _postTitle = value;
              },
            ),
            TextFormField(
              key: ValueKey('description'),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              onSaved: (value) {
                _postDescription = value;
              },
            ),
            SizedBox(height: 12),
            Row(
              children: [
                if (!imageSelected)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      primary: Colors.deepPurple,
                    ),
                    onPressed: _pickImage,
                    icon: Icon(Icons.image),
                    label: Text('Add Image'),
                  ),
                if (imageSelected)
                  CircleAvatar(
                    backgroundImage:
                        _pickedImage != null ? FileImage(_pickedImage) : null,
                    radius: 10,
                  ),
                if (imageSelected)
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      imageSelected = !imageSelected;
                      setState(() {
                        _pickedImage = null;
                      });
                    },
                  ),
              ],
            ),
            SizedBox(height: 12),
            ElevatedButton(
              child: Text('Create Post'),
              onPressed: _trySubmit,
            ),
          ],
        ),
      ),
    );
  }
}
