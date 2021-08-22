import 'package:blog_app/authentication.dart';
import 'package:blog_app/Posts.dart';
import 'package:blog_app/developers.dart';
import 'package:blog_app/uploadPhoto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  homePage({
    this.auth,
    this.onSignedOut,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  List<Posts> postsList = [];

  @override
  void initState() {
    super.initState();

    DatabaseReference postsRef =
        FirebaseDatabase.instance.reference().child("Posts");

    postsRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      postsList.clear();

      for (var individualKey in KEYS) {
        Posts posts = new Posts(
          DATA[individualKey]['image'],
          DATA[individualKey]['title'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['time'],
        );

        postsList.add(posts);
      }

      setState(() {
        print('Length : $postsList.length');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: _logoutUser,
            );
          },
        ),
        title: new Text(
          "Home".toUpperCase(),
          style: TextStyle(fontSize: 20, fontFamily: "Cambo"),
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.person),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return new developers();
              }));
            },
          )
        ],
      ),
      body: new Container(
        child: postsList.length == 0
            ? new Text("No Post Available")
            : new ListView.builder(
                itemCount: postsList.length,
                itemBuilder: (_, index) {
                  return PostsUI(
                    postsList[index].image,
                    postsList[index].title,
                    postsList[index].description,
                    postsList[index].date,
                    postsList[index].time,
                  );
                }),
      ),
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.loupe),
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return new uploadPhoto();
          }));
        },
      ),
    );
  }

  void _logoutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  Widget PostsUI(String image, String title, String description, String date,
      String time) {
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding: new EdgeInsets.all(14.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  date,
                  style: TextStyle(fontSize: 14, fontFamily: "Cambo"),
                  textAlign: TextAlign.center,
                ),
                new Text(
                  time,
                  style: TextStyle(fontSize: 14, fontFamily: "Cambo"),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            new Image.network(
              image,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 10.0,
            ),
            new Text(
              title.toUpperCase(),
              style: TextStyle(fontSize: 18, fontFamily: "Cambo"),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.0,
            ),
            new Text(
              description,
              style: TextStyle(fontSize: 14, fontFamily: "Cambo"),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
