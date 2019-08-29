import 'dart:convert';

import 'package:flutter/material.dart';
import '../mixins/validation_mixins.dart';
import 'package:http/http.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  createState() {
    return SignUpScreenState();
  }
}

class SignUpScreenState extends State<SignUpScreen> with ValidationMixin {
  final formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  String email = '';

  void login(String username, String password, String email) async {
    final Map<String, dynamic> userData = {
      'email': email,
      'username': username,
      'password': password,
    };
    var response = await post(
      'http://192.168.1.18:8000/api/signup/',
      body: json.encode(userData),
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    print(responseData);
    if (responseData.containsKey('token')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  Widget build(context) {
    return MaterialApp(
      title: ('SignUp'),
      home: Scaffold(
        body: Container(
          margin: EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            usernameField(),
            emailField(),
            passwordField(),
            Container(margin: EdgeInsets.only(bottom: 25.0)),
            submitButton()
          ],
        ),
      ),
    ),
      ),
    );

  }

  Widget usernameField() {
    return TextFormField(
      decoration:
      InputDecoration(labelText: 'Username', hintText: 'example123'),
      onSaved: (value) {
        username = value;
      },
    );
  }

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration:
      InputDecoration(labelText: 'Email', hintText: 'example@gmail.com'),
      onSaved: (value) {
        email = value;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      decoration:
      InputDecoration(labelText: 'Enter Password', hintText: 'Password'),
      validator: validatePassword,
      onSaved: (value) {
        password = value;
      },
    );
  }

  Widget submitButton() {
    return RaisedButton(
      color: Colors.blue,
      child: Text('Submit'),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print('Time to post my $email $username and $password to API!');
          login(username,password,email);
        }
      },
    );
  }
}
