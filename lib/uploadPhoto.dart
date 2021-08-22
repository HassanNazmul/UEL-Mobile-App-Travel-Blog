import 'dart:io';
import 'package:blog_app/homePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class uploadPhoto extends StatefulWidget {
  @override
  _uploadPhotoState createState() => _uploadPhotoState();
}

class _uploadPhotoState extends State<uploadPhoto> {
  File sampleImage;
  String _myTitel;
  String _myDescription;
  String url;
  final formKey = new GlobalKey<FormState>();

  Future imageFromGallery() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  Future imageFromCamera() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      sampleImage = tempImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new Container(),
        title: new Text(
          "UEL Travel Bolg".toUpperCase(),
          style: TextStyle(fontSize: 20, fontFamily: "Cambo"),
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.home),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return new homePage();
              }));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: new Center(
          child: sampleImage == null
              ? Text(
                  "Select an Image".toUpperCase(),
                  style: TextStyle(fontSize: 16, fontFamily: "Cambo"),
                )
              : enableUpload(),
        ),
      ),
      floatingActionButton: SpeedDial(
          backgroundColor: Colors.orangeAccent,
          closeManually: false,
          animatedIcon: AnimatedIcons.menu_close,
          overlayColor: Colors.white,
          overlayOpacity: 0.7,
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              child: Icon(Icons.add_a_photo),
              backgroundColor: Colors.blue,
              onTap: imageFromCamera,
            ),
            SpeedDialChild(
              child: Icon(Icons.image),
              backgroundColor: Colors.pink,
              onTap: imageFromGallery,
            ),
            SpeedDialChild(
              child: Icon(Icons.home),
              backgroundColor: Colors.deepPurpleAccent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return new homePage();
                }));
              },
            )
          ]),
    );
  }

  Widget enableUpload() {
    return new Container(
      child: new Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Image.file(
              sampleImage,
              height: 240.0,
              width: 360.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              decoration: new InputDecoration(labelText: 'Title'),
              validator: (value) {
                return value.isEmpty ? '*Required' : null;
              },
              onSaved: (value) {
                return _myTitel = value;
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              decoration: new InputDecoration(labelText: 'Description'),
              validator: (value) {
                return value.isEmpty ? '*Required' : null;
              },
              onSaved: (value) {
                return _myDescription = value;
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              elevation: 10.0,
              child: Text("Create Post",
                  style: new TextStyle(fontSize: 20.0)),
              textColor: Colors.white,
              color: Colors.lightBlueAccent,
              onPressed: uploadFeatureImage,
            )
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void uploadFeatureImage() async {
    if (validateAndSave()) {
      final StorageReference postImageRef =
          FirebaseStorage.instance.ref().child("Post Images");
      var timeKey = new DateTime.now();

      final StorageUploadTask uploadTask =
          postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      url = ImageUrl.toString();

      print("Image Url = " + url);

      goToHomePage();

      saveToDatabase(url);
    }
  }

  void goToHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new homePage();
    }));
  }

  void saveToDatabase(url) {
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "image": url,
      "title": _myTitel,
      "description": _myDescription,
      "date": date,
      "time": time,
    };

    ref.child("Posts").push().set(data);
  }
}
