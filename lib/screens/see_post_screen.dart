// body:
/*
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts/JNzfNchbu9x3bXlL8yKW/post')
            .snapshots(),
        builder: (context, streamSnapShot) {
          if (streamSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = streamSnapShot.data.documents;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (ctx, index) => Container(
              padding: EdgeInsets.all(10),
              child: Text(documents[index]['title']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('posts/JNzfNchbu9x3bXlL8yKW/post')
              .add({
            'title': 'this is the new title',
            'description': 'this is the new description'
          });
        },
      ),

*/
