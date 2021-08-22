import 'package:blog_app/authentication.dart';
import 'package:blog_app/mapping.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BlogApp());
}

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UEL Travel Blog',
      home: mappingPage(
        auth: Auth(),
      ),
    );
  }
}