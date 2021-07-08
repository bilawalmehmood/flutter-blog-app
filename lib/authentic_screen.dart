import 'package:blogapp/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'HomeScreen.dart';

class AuthenticScreen extends StatefulWidget {
  const AuthenticScreen({Key key}) : super(key: key);

  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  String _button_text="Login";
  String _switched_Text="Dont/` Have an Account? Register";

  bool _loading=false;

  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordControllr=TextEditingController();

  void _velidation(){
    if(_emailController.text.isEmpty && _passwordControllr.text.isEmpty){
      Fluttertoast.showToast(msg: "Please Enter a Password and Email ");
    }
    else if(_emailController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please Enter a  Email ");
    }
    else if(_passwordControllr.text.isEmpty){
      Fluttertoast.showToast(msg: "Please Enter a Password  ");

    }
    else{
      setState(() {
        _loading=true;
      });
      if(_button_text=="Login"){
        _login();
      }
      else{
        _register();
      }
    }
  }
  void _login(){
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordControllr.text
    ).then((UserCredential userCredential){
      setState(() {
        _loading=false;
      });
      // move to home screen
      Fluttertoast.showToast(msg: "Login Successfully ");
      _moveHomeScreen();

    }).catchError((error){
      setState(() {
        _loading=false;
      });
      Fluttertoast.showToast(msg: error.toString());

    });

  }
  void _moveHomeScreen(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
  void _register(){
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordControllr.text
    ).then((UserCredential userCredential){
      setState(() {
        _loading=false;
      });
      // move to home screen
      Fluttertoast.showToast(msg: "Registered Successfully ");

    }).catchError((error){
      setState(() {
        _loading=false;
      });
      Fluttertoast.showToast(msg: error.toString());

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog App"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 30.0,),
                Image.asset("assets/images/blog.png",
                height: 200.0,
                width: 200.0,
                fit: BoxFit.cover,),
                SizedBox(height: 30.0,),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email"
                  ),
                ),
                SizedBox(height: 10.0,),
                TextField(
                  controller: _passwordControllr,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Password"
                  ),
                ),
                SizedBox(height: 40.0,),
                _loading ? circularProgress() :GestureDetector(
                  onTap: _velidation,
                  child: Container(
                    color: Colors.green,
                    width: double.infinity,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        _button_text,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                FlatButton(
                  onPressed: (){
                    setState(() {
                      if(_button_text=='Login'){
                        _button_text="Register";
                        _switched_Text="Have an Account? Login";
                      }
                      else{
                        _button_text="Login";
                        _switched_Text="Dont/` Have an Account? Register";
                      }

                    });
                  },
                    child: Text(
                      _switched_Text,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.blue
                      ),
                    ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
