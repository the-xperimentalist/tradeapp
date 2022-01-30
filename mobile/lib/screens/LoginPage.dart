import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile/screens/HomePage.dart';
import 'package:mobile/screens/subComponents/AddTradeButton.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/widget_function.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  late SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                headerSection(),
                textSection(),
                bottomSection(),
              ],
            ),
    ));
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController usernameController = new TextEditingController();

  register(String email, pass, username) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': pass, 'username': username};
    var jsonResponse = null;
    var response = await http.post(
        Uri.parse(
            "https://thewisetraders.azurewebsites.net/api/accounts/register/"),
        body: data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        sharedPreferences.setString("username", jsonResponse['username']);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Registered Successfully!")));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            (route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Unable to register")));
    }
  }

  skipLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("token", "-1");
    sharedPreferences.setString("username", "Test User");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        (route) => false);
  }

  signIn(String email, pass, username) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': pass, 'username': username};
    var jsonResponse = null;
    var response = await http.post(
        Uri.parse(
            "https://thewisetraders.azurewebsites.net/api/accounts/login/"),
        body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        sharedPreferences.setString("username", jsonResponse['username']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            (route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid credentials")));
    }
  }

  Container bottomSection() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 15),
        margin: EdgeInsets.only(top: 15),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          FlatButton(
            onPressed: () {
              if (emailController.text == "" ||
                  passwordController.text == "" ||
                  usernameController.text == "") {
                return;
              }
              setState(() {
                _isLoading:
                true;
              });
              signIn(emailController.text, passwordController.text,
                  usernameController.text);
            },
            color: Colors.purple,
            child: Text("Sign In", style: TextStyle(color: Colors.white70)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          FlatButton(
            onPressed: () {
              if (emailController.text == "" ||
                  passwordController.text == "" ||
                  usernameController.text == "") {
                return;
              }
              setState(() {
                _isLoading:
                true;
              });
              register(emailController.text, passwordController.text,
                  usernameController.text);
            },
            color: Colors.purple,
            child: Text("Register", style: TextStyle(color: Colors.white70)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          FlatButton(
            onPressed: () {
              skipLogin();
            },
            color: Colors.purple,
            child: Text("Skip", style: TextStyle(color: Colors.white70)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          )
        ]));
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Email",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: usernameController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Username",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.verified_user, color: Colors.white70),
              hintText: "Password",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Text(
        "Trade Journal",
        style: TextStyle(
            color: Colors.white70, fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }
}
