import 'package:blog_app/authentication.dart';
import 'package:blog_app/dialogBox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class loginPage extends StatefulWidget {
  loginPage({
    this.auth,
    this.onSignedIn,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  State<StatefulWidget> createState() {
    return _loginPageState();
  }
}

enum FormType { login, register }

class _loginPageState extends State<loginPage> {
  dialogBox DialogBox = new dialogBox();
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: new Container(
          margin: EdgeInsets.all(20.0),
          child: new Form(
            key: formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: createInputs() + createButtons(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createInputs() {
    return [
      SizedBox(
        height: 120.0,
      ),
      logo(),
      SizedBox(
        height: 100.0,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) {
          return value.isEmpty ? '*Required' : null;
        },
        onSaved: (value) {
          return _email = value;
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) {
          return value.isEmpty ? '*Required' : null;
        },
        onSaved: (value) {
          return _password = value;
        },
      ),
      SizedBox(
        height: 50.0,
      ),
    ];
  }

  Widget logo() {
    return new Hero(
      tag: 'hero',
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 50.0,
        child: Image.asset('images/app_logo.png'),
      ),
    );
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          child: new Text(
            "Log In",
            style: TextStyle(fontSize: 24),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textColor: Colors.white,
          color: Colors.lightBlueAccent,
          onPressed: validateAndSubmit,
        ),
        SizedBox(
          height: 15.0,
        ),
        new FlatButton(
          child: new Text("Don't have an Account?",
              style: new TextStyle(fontSize: 16.0, fontFamily: "Cambo")),
          textColor: Colors.blue,
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        new RaisedButton(
          child: new Text("Register",
              style: new TextStyle(fontSize: 24.0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textColor: Colors.white,
          color: Colors.lightBlueAccent,
          onPressed: validateAndSubmit,
        ),
        SizedBox(
          height: 15.0,
        ),
        new FlatButton(
          child: new Text("Already have an Account?",
              style: new TextStyle(fontSize: 16.0, fontFamily: "Cambo")),
          textColor: Colors.blue,
          onPressed: moveToLogin,
        ),
      ];
    }
  }

  //METHODS
  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.SignIn(_email, _password);
          print("Login userId = " + userId);
        } else {
          String userId = await widget.auth.SignUp(_email, _password);
          print("Register userId = " + userId);
        }

        widget.onSignedIn();
      } catch (e) {
        DialogBox.information(context, "Error !!!", e.toString());
        //print("Error: " + e.toString());
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();

    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();

    setState(() {
      _formType = FormType.login;
    });
  }
}
