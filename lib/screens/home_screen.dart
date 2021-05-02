import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:post_app/widgets/post/create_post.dart';
import 'package:post_app/widgets/post/view_post.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  // String _userPostTitle = '';
  // String _userPostDescription = '';
  // File _userImagePicker;

  // _createPost(File image, String title, String desc) {
  //   _userImagePicker = image;
  //   _userPostTitle = title;
  //   _userPostDescription = desc;
  // }

  userLogOut() {
    FirebaseAuth.instance.signOut();
  }

  static List<Widget> _widgetOptions = <Widget>[
    CreatePost(),
    ViewPost(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post App'),
        actions: [
          GestureDetector(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).primaryIconTheme.color,
                )),
            onTap: userLogOut,
          ),
        ],
      ),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Create Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_agenda_outlined),
            label: 'See Post',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurpleAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
