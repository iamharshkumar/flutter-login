import 'dart:convert';

import 'package:flutter/material.dart';
import '../mixins/validation_mixins.dart';
import 'package:http/http.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> with ValidationMixin {
  final formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';

  void login(String username, String password) async {
    final Map<String, dynamic> userData = {
      'username': username,
      'password': password
    };
    var response = await post(
      'http://192.168.43.201:8080/api/login/',
      body: json.encode(userData),
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    print(responseData);
    if (responseData.containsKey('token')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      final snackBar = SnackBar(content: Text(responseData['error']));

    // Find the Scaffold in the widget tree and use it to show a SnackBar.
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Widget build(context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            emailField(),
            passwordField(),
            Container(margin: EdgeInsets.only(bottom: 25.0)),
            submitButton()
          ],
        ),
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration:
          InputDecoration(labelText: 'Username', hintText: 'example123'),
      onSaved: (value) {
        username = value;
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
          print('Time to post my $username and $password to API!');
          login(username, password);
        }
      },
    );
  }
}
