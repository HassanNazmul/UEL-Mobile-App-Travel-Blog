import 'package:blog_app/homePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class developers extends StatefulWidget {
  @override
  _developersState createState() => _developersState();
}

class _developersState extends State<developers> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return new homePage();
                }));
              },
            );
          },
        ),
        title: new Text(
          "Developers".toUpperCase(),
          style: TextStyle(fontSize: 20, fontFamily: "Cambo"),
        ),
        centerTitle: true,
      ),
      body: new Container(
        child: new ListView(
          children: <Widget>[
            SizedBox(
              height: 100.0,
            ),
            ListTile(
              title: Text(
                "Nazmul Hassan",
                style: TextStyle(fontSize: 20, fontFamily: "Cambo"),
              ),
              subtitle: Text(
                "BSc (Hons) Computer Science",
                style: TextStyle(fontSize: 14, fontFamily: "Cambo"),
              ),
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            ListTile(
              title: Text(
                "Dwipesh Patel",
                style: TextStyle(fontSize: 20, fontFamily: "Cambo"),
              ),
              subtitle: Text(
                "BSc (Hons) Computer Science",
                style: TextStyle(fontSize: 14, fontFamily: "Cambo"),
              ),
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            ListTile(
              title: Text(
                "Tejkumar Patel",
                style: TextStyle(fontSize: 20, fontFamily: "Cambo"),
              ),
              subtitle: Text(
                "BSc (Hons) Computer Science",
                style: TextStyle(fontSize: 14, fontFamily: "Cambo"),
              ),
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            ListTile(
              title: Text(
                "A V S S Kames",
                style: TextStyle(fontSize: 20, fontFamily: "Cambo"),
              ),
              subtitle: Text(
                "BSc (Hons) Computer Science",
                style: TextStyle(fontSize: 14, fontFamily: "Cambo"),
              ),
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            SizedBox(
              height: 200.0,
            ),
            Text(
              'Developed By \nNAZMUL | DWIP | TEJ | KAMES \nPowered By UEL',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Cambo",
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
