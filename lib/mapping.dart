import 'package:blog_app/authentication.dart';
import 'package:blog_app/homePage.dart';
import 'package:blog_app/loginPage.dart';
import 'package:flutter/cupertino.dart';

class mappingPage extends StatefulWidget {
  final AuthImplementation auth;

  mappingPage({
    this.auth,
  });

  State<StatefulWidget> createState() {
    return _mappingPageState();
  }
}

enum AuthStatus { notSignedIn, signedIn }

class _mappingPageState extends State<mappingPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();

    widget.auth.getCurrentUser().then((firebaseUserId) {
      setState(() {
        authStatus = firebaseUserId == null
            ? AuthStatus.notSignedIn
            : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new loginPage(auth: widget.auth, onSignedIn: _signedIn);

      case AuthStatus.signedIn:
        return new homePage(auth: widget.auth, onSignedOut: _signOut);
    }
    return null;
  }
}
